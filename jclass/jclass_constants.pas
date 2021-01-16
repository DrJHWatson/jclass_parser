unit jclass_constants;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common;

type
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
  public
    procedure LoadFromStream(AStream: TStream); override;
    property AsInteger: Int32 read FInteger;
  end;

  { TJClassFloatConstant }

  TJClassFloatConstant = class(TJClassConstant)
  private
    FFloat: single;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property AsFloat: single read FFloat;
  end;

  { TJClassLongConstant }

  TJClassLongConstant = class(TJClassConstant)
  private
    FLong: int64;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property AsLong: int64 read FLong;
  end;

  { TJClassDoubleConstant }

  TJClassDoubleConstant = class(TJClassConstant)
  private
    FDouble: double;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property AsDouble: double read FDouble;
  end;

  { TJClassClassConstant }

  TJClassClassConstant = class(TJClassConstant)
  private
    FNameIndex: UInt16;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property NameIndex: UInt16 read FNameIndex;
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
  public
    procedure LoadFromStream(AStream: TStream); override;
    property RefIndex: UInt16 read FRefIndex;
  end;

  TJClassFieldrefConstant = class(TJClassRefConstant);
  TJClassMethodrefConstant = class(TJClassRefConstant);
  TJClassInterfaceMethodrefConstant = class(TJClassRefConstant);

  { TJClassNameAndTypeConstant }

  TJClassNameAndTypeConstant = class(TJClassConstant)
  private
    FNameIndex: UInt16;
    FDescriptorIndex: UInt16;
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

  { TJClassInvokeDynamicConstant }

  TJClassInvokeDynamicConstant = class(TJClassConstant)
  private
    FBootstrapMethodAttrIndex: UInt16;
    FNameAndTypeIndex: UInt16;
  public
    procedure LoadFromStream(AStream: TStream); override;
    property BootstrapMethodAttrIndex: UInt16 read FBootstrapMethodAttrIndex;
    property NameAndTypeIndex: UInt16 read FNameAndTypeIndex;
  end;

const
  JConstantTypeNames: array[1..18] of string = (
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
    'ERROR',
    'InvokeDynamic'
    );

  JConstantTypes: array[1..18] of TJClassConstantClass = (
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
    nil,
    TJClassInvokeDynamicConstant
    );

implementation

uses
  jclass_enum;

{ TJClassNameAndTypeConstant }

procedure TJClassNameAndTypeConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FNameIndex, etWord);
  ReadElement(AStream, @FDescriptorIndex, etWord);
end;

{ TJClassInvokeDynamicConstant }

procedure TJClassInvokeDynamicConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FBootstrapMethodAttrIndex, etWord);
  ReadElement(AStream, @FNameAndTypeIndex, etWord);
end;

{ TJClassMethodTypeConstant }

procedure TJClassMethodTypeConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FDescriptorIndex, etWord);
end;

{ TJClassMethodHandleConstant }

procedure TJClassMethodHandleConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FReferenceKind, etByte);
  ReadElement(AStream, @FReferenceIndex, etWord);
end;

{ TJClassRefConstant }

procedure TJClassRefConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FRefIndex, etWord);
  ReadElement(AStream, @FNameAndTypeIndex, etWord);
end;

{ TJClassStringConstant }

procedure TJClassStringConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FStringIndex, etWord);
end;

{ TJClassClassConstant }

procedure TJClassClassConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FNameIndex, etWord);
end;

{ TJClassDoubleConstant }

procedure TJClassDoubleConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FDouble, etDWord);
  ReadElement(AStream, PByte(@FDouble) + 4, etDWord);
end;

{ TJClassLongConstant }

procedure TJClassLongConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FLong, etDWord);
  ReadElement(AStream, PByte(@FLong) + 4, etDWord);
end;

{ TJClassFloatConstant }

procedure TJClassFloatConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FFloat, etDWord);
end;

{ TJClassIntegerConstant }

procedure TJClassIntegerConstant.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FInteger, etDWord);
end;

{ TJClassUtf8Constant }

function TJClassUtf8Constant.GetDescription: string;
begin
  Result:= Format('UTF8: "%s"', [FUtf8String]);
end;

procedure TJClassUtf8Constant.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
begin
  ReadElement(AStream, @buf, etWord);
  SetLength(FUtf8String, buf);
  if buf > 0 then
    AStream.Read(FUtf8String[1], buf);
end;

function TJClassUtf8Constant.AsString: string;
begin
  Result := FUtf8String;
end;

end.
