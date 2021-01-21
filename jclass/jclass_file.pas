unit jclass_file;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_types,
  jclass_data_classfile,
  jclass_common,
  jclass_constants,
  jclass_attributes,
  jclass_fields,
  jclass_methods;

type

  { TJClassFile }

  TJClassFile = class(TJClassLoadable)
  private
    FData: TJClassFileData;
    function GetAccessFlags: string;
    function GetAttributesCount: integer;
    function GetClassAttribute(AIndex: integer): TJClassAttribute;
    function GetClassConstant(AIndex: integer): TJClassConstant;
    function GetClassField(AIndex: integer): TJClassField;
    function GetClassMethod(AIndex: integer): TJClassMethod;
    function GetConstantCount: integer;
    function GetFieldsCount: integer;
    function GetInterface(AIndex: integer): TJClassClassConstant;
    function GetInterfacesCount: integer;
    function GetMethodsCount: integer;
    function GetSuperClass: TJClassClassConstant;
    function GetThisClass: TJClassClassConstant;
    procedure LoadClassConstants(ASource: TStream; ACount: UInt16);
    procedure LoadClassFields(ASource: TStream; ACount: UInt16);
    procedure LoadClassMethods(ASource: TStream; ACount: UInt16);
    procedure LoadClassAttributes(ASource: TStream; ACount: UInt16);
    function GetClassConstantSafe(AIndex: integer;
      AConstantClass: TJClassConstantClass): TJClassConstant;
  public
    function GetStringConstant(AIndex: integer): string;
    property MinorVersion: UInt16 read FData.MinorVersion;
    property MajorVersion: UInt16 read FData.MajorVersion;
    property AccessFlags: string read GetAccessFlags;
    property ThisClass: TJClassClassConstant read GetThisClass;
    property SuperClass: TJClassClassConstant read GetSuperClass;
    property ConstantsCount: integer read GetConstantCount;
    property ConstantPool[AIndex: integer]: TJClassConstant read GetClassConstant;
    property InterfacesCount: integer read GetInterfacesCount;
    property Interfaces[AIndex: integer]: TJClassClassConstant read GetInterface;
    property FieldsCount: integer read GetFieldsCount;
    property Fields[AIndex: integer]: TJClassField read GetClassField;
    property MethodsCount: integer read GetMethodsCount;
    property Methods[AIndex: integer]: TJClassMethod read GetClassMethod;
    property AttributesCount: integer read GetAttributesCount;
    property Attributes[AIndex: integer]: TJClassAttribute read GetClassAttribute;
    procedure LoadFromStream(AStream: TStream); override;
    constructor Create;
    destructor Destroy; override;
  end;



implementation

uses
  jclass_enum;

const
  MAGIC = $CAFEBABE;

function TJClassFile.GetClassAttribute(AIndex: integer): TJClassAttribute;
begin
  Result := TJClassAttribute(FData.Attributes[AIndex]);
end;

function TJClassFile.GetAttributesCount: integer;
begin
  Result := FData.Attributes.Count;
end;

function TJClassFile.GetAccessFlags: string;
begin
  Result := ClassAccessFlagsToString(FData.AccessFlags);
end;

function TJClassFile.GetClassConstant(AIndex: integer): TJClassConstant;
begin
  Result := TJClassConstant(FData.ConstantPool[AIndex]);
end;

function TJClassFile.GetClassField(AIndex: integer): TJClassField;
begin
  Result := TJClassField(FData.Fields[AIndex]);
end;

function TJClassFile.GetClassMethod(AIndex: integer): TJClassMethod;
begin
  Result := TJClassMethod(FData.Methods[AIndex]);
end;

function TJClassFile.GetConstantCount: integer;
begin
  Result := FData.ConstantPool.Count;
end;

function TJClassFile.GetFieldsCount: integer;
begin
  Result := FData.Fields.Count;
end;

function TJClassFile.GetInterface(AIndex: integer): TJClassClassConstant;
begin
  Result := TJClassClassConstant(GetClassConstantSafe(FData.Interfaces[AIndex], TJClassClassConstant));
end;

function TJClassFile.GetInterfacesCount: integer;
begin
  Result := Length(FData.Interfaces);
end;

function TJClassFile.GetMethodsCount: integer;
begin
  Result := FData.Methods.Count;
end;

function TJClassFile.GetSuperClass: TJClassClassConstant;
begin
  Result := TJClassClassConstant(GetClassConstantSafe(FData.SuperClass, TJClassClassConstant));
end;

function TJClassFile.GetThisClass: TJClassClassConstant;
begin
  Result := TJClassClassConstant(GetClassConstantSafe(FData.ThisClass, TJClassClassConstant));
end;

procedure TJClassFile.LoadClassConstants(ASource: TStream; ACount: UInt16);
var
  constant: TJClassConstant;
  tag: UInt8;
  i: integer;
  doubleSize: boolean;
begin
  i := 0;
  while i < ACount do
  begin
    tag := ReadByte(ASource);
    constant := JConstantTypes[tag].Create(@GetClassConstantSafe, doubleSize);
    try
      constant.LoadFromStream(ASource);
      FData.ConstantPool.Add(constant);
    except
      constant.Free;
      raise;
    end;
    if doubleSize then
    begin
      FData.ConstantPool.Add(TJClassEmptyConstant.Create(@GetClassConstantSafe, doubleSize));
      Inc(i);
    end;
    Inc(i);
  end;
end;

procedure TJClassFile.LoadClassFields(ASource: TStream; ACount: UInt16);
var
  field: TJClassField;
  i: integer;
begin
  for i := 0 to ACount - 1 do
  begin
    field := TJClassField.Create(@GetClassConstantSafe);
    try
      field.LoadFromStream(ASource);
      FData.Fields.Add(field);
    except
      field.Free;
      raise;
    end;
  end;
end;

procedure TJClassFile.LoadClassMethods(ASource: TStream; ACount: UInt16);
var
  method: TJClassMethod;
  i: integer;
begin
  for i := 0 to ACount - 1 do
  begin
    method := TJClassMethod.Create(@GetClassConstantSafe);
    try
      method.LoadFromStream(ASource);
      FData.Methods.Add(method);
    except
      method.Free;
      raise;
    end;
  end;
end;

procedure TJClassFile.LoadClassAttributes(ASource: TStream; ACount: UInt16);
var
  attribute: TJClassAttribute;
  nameIndex: UInt16;
  attributeName: string;
  i: integer;
begin
  for i := 0 to ACount - 1 do
  begin
    nameIndex := ReadWord(ASource);
    attributeName := TJClassUtf8Constant(GetClassConstantSafe(nameIndex,
      TJClassUtf8Constant)).AsString;
    attribute := FindAttributeClass(attributeName, alClassFile).Create(@GetClassConstantSafe);
    try
      attribute.LoadFromStream(ASource);
      FData.Attributes.Add(attribute);
    except
      attribute.Free;
      raise;
    end;
  end;
end;

function TJClassFile.GetClassConstantSafe(AIndex: integer;
  AConstantClass: TJClassConstantClass): TJClassConstant;
begin
  Result := GetClassConstant(AIndex - 1);
  if not (Result is AConstantClass) then
    raise Exception.CreateFmt('Wrong constant type "%s", expected "%s" at %d',
      [Result.ClassName, AConstantClass.ClassName, AIndex - 1]);
end;

function TJClassFile.GetStringConstant(AIndex: integer): string;
begin
  Result := TJClassUtf8Constant(GetClassConstantSafe(AIndex, TJClassUtf8Constant)).AsString;
end;

procedure TJClassFile.LoadFromStream(AStream: TStream);
var
  i: integer;
  buf: UInt16;
begin
  if not Assigned(AStream) then
    raise Exception.Create('null input stream');
  FData.Magic := ReadDWord(AStream);
  FData.MinorVersion := ReadWord(AStream);
  FData.MajorVersion := ReadWord(AStream);
  buf := ReadWord(AStream);
  LoadClassConstants(AStream, buf - 1);
  FData.AccessFlags := ReadWord(AStream);
  FData.ThisClass := ReadWord(AStream);
  FData.SuperClass := ReadWord(AStream);
  buf := ReadWord(AStream);
  SetLength(FData.Interfaces, buf);
  for i := 0 to buf - 1 do
    FData.Interfaces[i] := ReadWord(AStream);
  buf := ReadWord(AStream);
  LoadClassFields(AStream, buf);
  buf := ReadWord(AStream);
  LoadClassMethods(AStream, buf);
  buf := ReadWord(AStream);
  LoadClassAttributes(AStream, buf);
end;

constructor TJClassFile.Create;
begin
  FData.Fields := TList.Create;
  FData.Methods := TList.Create;
  FData.Attributes := TList.Create;
  FData.ConstantPool := TList.Create;
end;

destructor TJClassFile.Destroy;
var
  p: Pointer;
begin
  for p in FData.Fields do
    TObject(p).Free;
  FData.Fields.Free;
  for p in FData.Methods do
    TObject(p).Free;
  FData.Methods.Free;
  for p in FData.Attributes do
    TObject(p).Free;
  FData.Attributes.Free;
  for p in FData.ConstantPool do
    TObject(p).Free;
  FData.ConstantPool.Free;
  inherited Destroy;
end;

end.
