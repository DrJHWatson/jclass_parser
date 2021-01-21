unit jclass_constants;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common;

type
  TJClassConstant = class;
  TJClassConstantClass = class of TJClassConstant;
  TJClassConstantSearch = function(AIndex: integer;
    AConstantClass: TJClassConstantClass): TJClassConstant of object;

  { TJClassConstant }

  TJClassConstant = class(TJClassLoadable)
  protected
    FConstantSearch: TJClassConstantSearch;
    function StringByIndex(AIndex: integer): string;
    function GetDescription: string; virtual;
  public
    constructor Create(AConstantSearch: TJClassConstantSearch; out ADoubleSize: boolean); virtual;
    property Description: string read GetDescription;
  end;

  { TJClassEmptyConstant }

  TJClassEmptyConstant = class(TJClassConstant)
  protected
    function GetDescription: string; override;
  end;

  { TJClassUtf8Constant }

  TJClassUtf8Constant = class(TJClassConstant)
  private
    FUtf8String: UTF8String;
  protected
    function GetDescription: string; override;
  public
    procedure LoadFromStream(AStream: TStream); override;
    function AsString: string;
  end;

  { TJClassIntegerConstant }

  TJClassIntegerConstant = class(TJClassConstant)
  private
    FInteger: Int32;
  protected
    function GetDescription: string; override;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property AsInteger: Int32 read FInteger;
  end;

  { TJClassFloatConstant }

  TJClassFloatConstant = class(TJClassConstant)
  private
    FFloat: single;
  protected
    function GetDescription: string; override;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property AsFloat: single read FFloat;
  end;

  { TJClassLongConstant }

  TJClassLongConstant = class(TJClassConstant)
  private
    FLong: int64;
  protected
    function GetDescription: string; override;
  public
    constructor Create(AConstantSearch: TJClassConstantSearch; out ADoubleSize: boolean); override;
    procedure LoadFromStream(AStream: TStream); override;
    property AsLong: int64 read FLong;
  end;

  { TJClassDoubleConstant }

  TJClassDoubleConstant = class(TJClassConstant)
  private
    FDouble: double;
  protected
    function GetDescription: string; override;
  public
    constructor Create(AConstantSearch: TJClassConstantSearch; out ADoubleSize: boolean); override;
    procedure LoadFromStream(AStream: TStream); override;
    property AsDouble: double read FDouble;
  end;

  { TJClassNamedConstant }

  TJClassNamedConstant = class(TJClassConstant)
  private
    FNameIndex: UInt16;
  protected
    function GetDescription: string; override;
    function GetTypeName: string; virtual; abstract;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property NameIndex: UInt16 read FNameIndex;
  end;

  { TJClassClassConstant }

  TJClassClassConstant = class(TJClassNamedConstant)
  protected
    function GetTypeName: string; override;
  end;

  { TJClassModuleConstant }

  TJClassModuleConstant = class(TJClassNamedConstant)
  protected
    function GetTypeName: string; override;
  end;

  { TJClassPackageConstant }

  TJClassPackageConstant = class(TJClassNamedConstant)
  protected
    function GetTypeName: string; override;
  end;

  { TJClassStringConstant }

  TJClassStringConstant = class(TJClassConstant)
  private
    FStringIndex: UInt16;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property StringIndex: UInt16 read FStringIndex;
  end;

  { TJClassRefConstant }

  TJClassRefConstant = class(TJClassConstant)
  private
    FRefIndex: UInt16;
    FNameAndTypeIndex: UInt16;
  protected
    function GetDescription: string; override;
    function GetRefName: string; virtual; abstract;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property RefIndex: UInt16 read FRefIndex;
  end;

  { TJClassFieldrefConstant }

  TJClassFieldrefConstant = class(TJClassRefConstant)
  protected
    function GetRefName: string; override;
  end;

  { TJClassMethodrefConstant }

  TJClassMethodrefConstant = class(TJClassRefConstant)
  protected
    function GetRefName: string; override;
  end;

  { TJClassInterfaceMethodrefConstant }

  TJClassInterfaceMethodrefConstant = class(TJClassRefConstant)
  protected
    function GetRefName: string; override;
  end;

  { TJClassNameAndTypeConstant }

  TJClassNameAndTypeConstant = class(TJClassConstant)
  private
    FNameIndex: UInt16;
    FDescriptorIndex: UInt16;
  protected
    function GetDescription: string; override;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property NameIndex: UInt16 read FNameIndex;
    property DescriptorIndex: UInt16 read FDescriptorIndex;
  end;

  { TJClassMethodHandleConstant }

  TJClassMethodHandleConstant = class(TJClassConstant)
  private
    FReferenceKind: UInt8;
    FReferenceIndex: UInt16;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property ReferenceKind: UInt8 read FReferenceKind;
    property ReferenceIndex: UInt16 read FReferenceIndex;
  end;

  { TJClassMethodTypeConstant }

  TJClassMethodTypeConstant = class(TJClassConstant)
  private
    FDescriptorIndex: UInt16;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property DescriptorIndex: UInt16 read FDescriptorIndex;
  end;

  { TJClassDynamicGeneralConstant }

  TJClassDynamicGeneralConstant = class(TJClassConstant)
  private
    FBootstrapMethodAttrIndex: UInt16;
    FNameAndTypeIndex: UInt16;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property BootstrapMethodAttrIndex: UInt16 read FBootstrapMethodAttrIndex;
    property NameAndTypeIndex: UInt16 read FNameAndTypeIndex;
  end;

  TJClassDynamicConstant = class(TJClassDynamicGeneralConstant);
  TJClassInvokeDynamicConstant = class(TJClassDynamicGeneralConstant);

const
  JConstantTypeNames: array[1..20] of string = (
    'Utf8',
    'ERROR',
    'Integer',
    'Float',
    'Long',
    'Double',
    'Class',
    'String',
    'Fieldref',
    'Methodref',
    'InterfaceMethodref',
    'NameAndType',
    'ERROR',
    'ERROR',
    'MethodHandle',
    'MethodType',
    'Dynamic',
    'InvokeDynamic',
    'Module',
    'Package'
    );

  JConstantTypes: array[1..20] of TJClassConstantClass = (
    TJClassUtf8Constant,
    nil,
    TJClassIntegerConstant,
    TJClassFloatConstant,
    TJClassLongConstant,
    TJClassDoubleConstant,
    TJClassClassConstant,
    TJClassStringConstant,
    TJClassFieldrefConstant,
    TJClassMethodrefConstant,
    TJClassInterfaceMethodrefConstant,
    TJClassNameAndTypeConstant,
    nil,
    nil,
    TJClassMethodHandleConstant,
    TJClassMethodTypeConstant,
    TJClassDynamicConstant,
    TJClassInvokeDynamicConstant,
    TJClassModuleConstant,
    TJClassPackageConstant
    );

implementation

uses
  jclass_enum;

{ TJClassInterfaceMethodrefConstant }

function TJClassInterfaceMethodrefConstant.GetRefName: string;
begin
  Result := 'InterfaceMethod';
end;

{ TJClassMethodrefConstant }

function TJClassMethodrefConstant.GetRefName: string;
begin
  Result := 'Method';
end;

{ TJClassFieldrefConstant }

function TJClassFieldrefConstant.GetRefName: string;
begin
  Result := 'Field';
end;

{ TJClassPackageConstant }

function TJClassPackageConstant.GetTypeName: string;
begin
  Result := 'Package';
end;

{ TJClassModuleConstant }

function TJClassModuleConstant.GetTypeName: string;
begin
  Result := 'Module';
end;

{ TJClassClassConstant }

function TJClassClassConstant.GetTypeName: string;
begin
  Result := 'Class';
end;

{ TJClassEmptyConstant }

function TJClassEmptyConstant.GetDescription: string;
begin
  Result := 'Empty slot after 8-byte constant';
end;

{ TJClassConstant }

function TJClassConstant.StringByIndex(AIndex: integer): string;
begin
  Result := TJClassUtf8Constant(FConstantSearch(AIndex, TJClassUtf8Constant)).AsString;
end;

function TJClassConstant.GetDescription: string;
begin
  Result := ClassName;
end;

constructor TJClassConstant.Create(AConstantSearch: TJClassConstantSearch;
  out ADoubleSize: boolean);
begin
  FConstantSearch := AConstantSearch;
  ADoubleSize := False;
end;

{ TJClassNameAndTypeConstant }

function TJClassNameAndTypeConstant.GetDescription: string;
begin
  Result := Format('Name and type: name "%s", type "%s"',
    [StringByIndex(FNameIndex), StringByIndex(FDescriptorIndex)]);
end;

procedure TJClassNameAndTypeConstant.LoadFromStream(AStream: TStream);
begin
  FNameIndex := ReadWord(AStream);
  FDescriptorIndex := ReadWord(AStream);
end;

{ TJClassDynamicGeneralConstant }

procedure TJClassDynamicGeneralConstant.LoadFromStream(AStream: TStream);
begin
  FBootstrapMethodAttrIndex := ReadWord(AStream);
  FNameAndTypeIndex := ReadWord(AStream);
end;

{ TJClassMethodTypeConstant }

procedure TJClassMethodTypeConstant.LoadFromStream(AStream: TStream);
begin
  FDescriptorIndex := ReadWord(AStream);
end;

{ TJClassMethodHandleConstant }

procedure TJClassMethodHandleConstant.LoadFromStream(AStream: TStream);
begin
  FReferenceKind := ReadByte(AStream);
  FReferenceIndex := ReadWord(AStream);
end;

{ TJClassRefConstant }

function TJClassRefConstant.GetDescription: string;
begin
  Result := Format('%sref: target (%d), name and type (%d)',
    [GetRefName, FRefIndex, FNameAndTypeIndex]);
end;

procedure TJClassRefConstant.LoadFromStream(AStream: TStream);
begin
  FRefIndex := ReadWord(AStream);
  FNameAndTypeIndex := ReadWord(AStream);
end;

{ TJClassStringConstant }

procedure TJClassStringConstant.LoadFromStream(AStream: TStream);
begin
  FStringIndex := ReadWord(AStream);
end;

{ TJClassNamedConstant }

function TJClassNamedConstant.GetDescription: string;
begin
  Result := Format('%s: %s', [GetTypeName, StringByIndex(FNameIndex)]);
end;

procedure TJClassNamedConstant.LoadFromStream(AStream: TStream);
begin
  FNameIndex := ReadWord(AStream);
end;

{ TJClassDoubleConstant }

function TJClassDoubleConstant.GetDescription: string;
begin
  Result := Format('Double: %f', [FDouble]);
end;

constructor TJClassDoubleConstant.Create(AConstantSearch: TJClassConstantSearch;
  out ADoubleSize: boolean);
begin
  inherited Create(AConstantSearch, ADoubleSize);
  ADoubleSize := True;
end;

procedure TJClassDoubleConstant.LoadFromStream(AStream: TStream);
var
  doubleBuf: double;
  valueBuf: array[0..1] of UInt32 absolute doubleBuf;
begin
  valueBuf[1] := ReadDWord(AStream);
  valueBuf[0] := ReadDWord(AStream);
  FDouble := doubleBuf;
end;

{ TJClassLongConstant }

function TJClassLongConstant.GetDescription: string;
begin
  Result := Format('Long: %d', [FLong]);
end;

constructor TJClassLongConstant.Create(AConstantSearch: TJClassConstantSearch;
  out ADoubleSize: boolean);
begin
  inherited Create(AConstantSearch, ADoubleSize);
  ADoubleSize := True;
end;

procedure TJClassLongConstant.LoadFromStream(AStream: TStream);
var
  longBuf: UInt64;
  valueBuf: array[0..1] of UInt32 absolute longBuf;
begin
  valueBuf[1] := ReadDWord(AStream);
  valueBuf[0] := ReadDWord(AStream);
  FLong := longBuf;
end;

{ TJClassFloatConstant }

function TJClassFloatConstant.GetDescription: string;
begin
  Result := Format('Float: %f', [FFloat]);
end;

procedure TJClassFloatConstant.LoadFromStream(AStream: TStream);
begin
  FFloat := ReadDWord(AStream);
end;

{ TJClassIntegerConstant }

function TJClassIntegerConstant.GetDescription: string;
begin
  Result := Format('Int: %d', [FInteger]);
end;

procedure TJClassIntegerConstant.LoadFromStream(AStream: TStream);
begin
  FInteger := ReadDWord(AStream);
end;

{ TJClassUtf8Constant }

function TJClassUtf8Constant.GetDescription: string;
begin
  Result := Format('UTF8: "%s"', [FUtf8String]);

end;

procedure TJClassUtf8Constant.LoadFromStream(AStream: TStream);
begin
  SetLength(FUtf8String, ReadWord(AStream));
  if Length(FUtf8String) > 0 then
    AStream.Read(FUtf8String[1], Length(FUtf8String));
end;

function TJClassUtf8Constant.AsString: string;
begin
  Result := FUtf8String;
end;

end.
