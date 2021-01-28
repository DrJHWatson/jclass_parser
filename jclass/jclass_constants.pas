unit jclass_constants;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common,
  jclass_enum,
  jclass_common_types,
  fgl;

type
  TJClassConstant = class;
  TJClassConstants = class;
  TJClassConstantClass = class of TJClassConstant;

  { TJClassConstant }

  TJClassConstant = class(TJClassLoadable)
  protected
    FConstants: TJClassConstants;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    constructor Create(AConstants: TJClassConstants; out ADoubleSize: boolean); virtual;
  end;

  { TJClassEmptyConstant }

  TJClassEmptyConstant = class(TJClassConstant)
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassUtf8Constant }

  TJClassUtf8Constant = class(TJClassConstant)
  private
    FUtf8String: UTF8String;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    procedure LoadFromStream(AStream: TStream); override;
    function AsString: string;
  end;

  { TJClassIntegerConstant }

  TJClassIntegerConstant = class(TJClassConstant)
  private
    FInteger: Int32;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    procedure LoadFromStream(AStream: TStream); override;
    property AsInteger: Int32 read FInteger;
  end;

  { TJClassFloatConstant }

  TJClassFloatConstant = class(TJClassConstant)
  private
    FFloat: single;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    procedure LoadFromStream(AStream: TStream); override;
    property AsFloat: single read FFloat;
  end;

  { TJClassLongConstant }

  TJClassLongConstant = class(TJClassConstant)
  private
    FLong: int64;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    constructor Create(AConstants: TJClassConstants; out ADoubleSize: boolean); override;
    procedure LoadFromStream(AStream: TStream); override;
    property AsLong: int64 read FLong;
  end;

  { TJClassDoubleConstant }

  TJClassDoubleConstant = class(TJClassConstant)
  private
    FDouble: double;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    constructor Create(AConstants: TJClassConstants; out ADoubleSize: boolean); override;
    procedure LoadFromStream(AStream: TStream); override;
    property AsDouble: double read FDouble;
  end;

  { TJClassNamedConstant }

  TJClassNamedConstant = class(TJClassConstant)
  private
    FNameIndex: UInt16;
  protected
    function GetTypeName: string; virtual; abstract;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
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
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    property StringIndex: UInt16 read FStringIndex;
  end;

  { TJClassRefConstant }

  TJClassRefConstant = class(TJClassConstant)
  private
    FRefIndex: UInt16;
    FNameAndTypeIndex: UInt16;
  protected
    function GetRefName: string; virtual; abstract;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
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
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
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

  { TJClassConstants }

  TJClassConstants = class(specialize TFPGObjectList<TJClassConstant>)
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings);
    procedure LoadFromStream(AStream: TStream);
    function CreateNewConst(ATag: TJConstantType; out ADoubleSize: boolean): TJClassConstant;
    function FindConstant(AIndex: TConstIndex): TJClassConstant;
    function FindConstantSafe(AIndex: TConstIndex; AClass: TJClassConstantClass): TJClassConstant;
    function FindUtf8Constant(AIndex: TConstIndex): string;
  end;

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

{ TJClassEmptyConstant }

procedure TJClassEmptyConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add(AIndent + 'Empty slot after 8-byte constant');
end;

procedure TJClassEmptyConstant.LoadFromStream(AStream: TStream);
begin

end;

{ TJClassConstants }

procedure TJClassConstants.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, Count]);
  for i := 0 to Count - 1 do
    Items[i].BuildDebugInfo(AIndent + '  ', AOutput);
end;

procedure TJClassConstants.LoadFromStream(AStream: TStream);
var
  constant: TJClassConstant;
  constantCount: UInt16;
  tag: UInt8;
  i: integer;
  doubleSize: boolean;
begin
  constantCount := TJClassConstant.ReadWord(AStream) - 1;
  i := 0;
  while i < constantCount do
  begin
    tag := TJClassConstant.ReadByte(AStream);
    constant := JConstantTypes[tag].Create(self, doubleSize);
    try
      constant.LoadFromStream(AStream);
      Add(constant);
    except
      constant.Free;
      raise;
    end;
    if doubleSize then
    begin
      Add(TJClassEmptyConstant.Create(Self, doubleSize));
      Inc(i);
    end;
    Inc(i);
  end;
end;

function TJClassConstants.CreateNewConst(ATag: TJConstantType;
  out ADoubleSize: boolean): TJClassConstant;
begin
  if (Ord(ATag) < 1) or (Ord(ATag) > 20) then
    raise Exception.Create('Constant type index out of bounds');
  if not Assigned(JConstantTypes[Ord(ATag)]) then
    raise Exception.Create('Constant type not found');
  Result := JConstantTypes[Ord(ATag)].Create(Self, ADoubleSize);
end;

function TJClassConstants.FindConstant(AIndex: TConstIndex): TJClassConstant;
begin
  Result := Items[AIndex - 1];
end;

function TJClassConstants.FindConstantSafe(AIndex: TConstIndex;
  AClass: TJClassConstantClass): TJClassConstant;
begin
  Result := FindConstant(AIndex);
  if not (Result is AClass) then
    raise Exception.CreateFmt('Wrong constant type "%s", expected "%s" at %d',
      [Result.ClassName, AClass.ClassName, AIndex - 1]);
end;

function TJClassConstants.FindUtf8Constant(AIndex: TConstIndex): string;
begin
  Result := TJClassUtf8Constant(FindConstantSafe(AIndex, TJClassUtf8Constant)).AsString;
end;

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

{ TJClassConstant }

procedure TJClassConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add(AIndent + ClassName);
end;

constructor TJClassConstant.Create(AConstants: TJClassConstants; out ADoubleSize: boolean);
begin
  FConstants := AConstants;
  ADoubleSize := False;
end;

{ TJClassNameAndTypeConstant }

procedure TJClassNameAndTypeConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sName and type: name "%s", type "%s"',
    [AIndent, FConstants.FindUtf8Constant(FNameIndex),
    FConstants.FindUtf8Constant(FDescriptorIndex)]);
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

procedure TJClassRefConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%s%sref: target (%d), name and type (%d)',
    [AIndent, GetRefName, FRefIndex, FNameAndTypeIndex]);
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

procedure TJClassStringConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sString: "%s"', [AIndent, FConstants.FindUtf8Constant(FStringIndex)]);
end;

{ TJClassNamedConstant }

procedure TJClassNamedConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%s%s: %s', [AIndent, GetTypeName, FConstants.FindUtf8Constant(FNameIndex)]);
end;

procedure TJClassNamedConstant.LoadFromStream(AStream: TStream);
begin
  FNameIndex := ReadWord(AStream);
end;

{ TJClassDoubleConstant }

procedure TJClassDoubleConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sDouble: %f', [AIndent, FDouble]);
end;

constructor TJClassDoubleConstant.Create(AConstants: TJClassConstants; out ADoubleSize: boolean);
begin
  inherited Create(AConstants, ADoubleSize);
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

procedure TJClassLongConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sLong: %d', [AIndent, FLong]);
end;

constructor TJClassLongConstant.Create(AConstants: TJClassConstants; out ADoubleSize: boolean);
begin
  inherited Create(AConstants, ADoubleSize);
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

procedure TJClassFloatConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sFloat: %f', [AIndent, FFloat]);
end;

procedure TJClassFloatConstant.LoadFromStream(AStream: TStream);
begin
  FFloat := ReadDWord(AStream);
end;

{ TJClassIntegerConstant }

procedure TJClassIntegerConstant.BuildDebugInfo(AIndent: string; AOutput: TStrings);

begin
  AOutput.Add('%sInt: %d', [AIndent, FInteger]);
end;

procedure TJClassIntegerConstant.LoadFromStream(AStream: TStream);
begin
  FInteger := ReadDWord(AStream);
end;

{ TJClassUtf8Constant }

procedure TJClassUtf8Constant.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sUTF8: "%s"', [AIndent, FUtf8String]);
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
