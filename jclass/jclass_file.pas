unit jclass_file;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_types,
  jclass_common,
  jclass_constants,
  jclass_attributes,
  jclass_fields,
  jclass_methods;

type

  { TJClassFile }

  TJClassFile = class(TJClassLoadable)
  private
    FMagic: UInt32;
    FMinorVersion: UInt16;
    FMajorVersion: UInt16;
    FConstantPool: TList;
    FAccessFlags: UInt16;
    FThisClass: UInt16;
    FSuperClass: UInt16;
    FInterfaces: array of UInt16;
    FFields: TList;
    FMethods: TList;
    FAttributes: TList;
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
    property MinorVersion: UInt16 read FMinorVersion;
    property MajorVersion: UInt16 read FMajorVersion;
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
  Result := TJClassAttribute(FAttributes[AIndex]);
end;

function TJClassFile.GetAttributesCount: integer;
begin
  Result := FAttributes.Count;
end;

function TJClassFile.GetAccessFlags: string;
begin
  Result := AccessFlagsToString(FAccessFlags);
end;

function TJClassFile.GetClassConstant(AIndex: integer): TJClassConstant;
begin
  Result := TJClassConstant(FConstantPool[AIndex]);
end;

function TJClassFile.GetClassField(AIndex: integer): TJClassField;
begin
  Result := TJClassField(FFields[AIndex]);
end;

function TJClassFile.GetClassMethod(AIndex: integer): TJClassMethod;
begin
  Result := TJClassMethod(FMethods[AIndex]);
end;

function TJClassFile.GetConstantCount: integer;
begin
  Result := FConstantPool.Count;
end;

function TJClassFile.GetFieldsCount: integer;
begin
  Result := FFields.Count;
end;

function TJClassFile.GetInterface(AIndex: integer): TJClassClassConstant;
begin
  Result := TJClassClassConstant(GetClassConstant(FInterfaces[AIndex]));
end;

function TJClassFile.GetInterfacesCount: integer;
begin
  Result := Length(FInterfaces);
end;

function TJClassFile.GetMethodsCount: integer;
begin
  Result := FMethods.Count;
end;

function TJClassFile.GetSuperClass: TJClassClassConstant;
begin
  Result := TJClassClassConstant(GetClassConstantSafe(FSuperClass, TJClassClassConstant));
end;

function TJClassFile.GetThisClass: TJClassClassConstant;
begin
  Result := TJClassClassConstant(GetClassConstantSafe(FThisClass, TJClassClassConstant));
end;

procedure TJClassFile.LoadClassConstants(ASource: TStream; ACount: UInt16);
var
  constant: TJClassConstant;
  tag: UInt8;
  i: integer;
begin
  for i := 0 to ACount - 1 do
  begin
    ReadElement(ASource, @tag, etByte);
    constant := JConstantTypes[tag].Create;
    try
      constant.LoadFromStream(ASource);
      FConstantPool.Add(constant);
    except
      constant.Free;
      raise;
    end;
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
      FFields.Add(field);
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
      FMethods.Add(method);
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
    ReadElement(ASource, @nameIndex, etWord);
    attributeName := TJClassUtf8Constant(GetClassConstantSafe(nameIndex,
      TJClassUtf8Constant)).AsString;
    attribute := FindAttributeClass(attributeName, alClassFile).Create(@GetClassConstantSafe);
    try
      attribute.LoadFromStream(ASource);
      FAttributes.Add(attribute);
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
  ReadElement(AStream, @FMagic, etDWord);
  ReadElement(AStream, @FMinorVersion, etWord);
  ReadElement(AStream, @FMajorVersion, etWord);
  ReadElement(AStream, @buf, etWord);
  LoadClassConstants(AStream, buf - 1);
  ReadElement(AStream, @FAccessFlags, etWord);
  ReadElement(AStream, @FThisClass, etWord);
  ReadElement(AStream, @FSuperClass, etWord);
  ReadElement(AStream, @buf, etWord);
  SetLength(FInterfaces, buf);
  for i := 0 to buf - 1 do
    ReadElement(AStream, @FInterfaces[i], etWord);
  ReadElement(AStream, @buf, etWord);
  LoadClassFields(AStream, buf);
  ReadElement(AStream, @buf, etWord);
  LoadClassMethods(AStream, buf);
  ReadElement(AStream, @buf, etWord);
  LoadClassAttributes(AStream, buf);
end;

constructor TJClassFile.Create;
begin
  FFields := TList.Create;
  FMethods := TList.Create;
  FAttributes := TList.Create;
  FConstantPool := TList.Create;
end;

destructor TJClassFile.Destroy;
var
  p: Pointer;
begin
  for p in FFields do
    TObject(p).Free;
  FFields.Free;
  for p in FMethods do
    TObject(p).Free;
  FMethods.Free;
  for p in FAttributes do
    TObject(p).Free;
  FAttributes.Free;
  for p in FConstantPool do
    TObject(p).Free;
  FConstantPool.Free;
  inherited Destroy;
end;

end.
