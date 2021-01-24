unit jclass_file;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common,
  jclass_constants,
  jclass_attributes,
  jclass_fields,
  jclass_methods,
  jclass_common_abstract,
  jclass_common_types,
  jclass_interface_list;

type

  { TJClassFile }

  TJClassFile = class(TJClassFileAbstract)
  private
    FMagic: UInt32;
    FMinorVersion: UInt16;
    FMajorVersion: UInt16;
    FAccessFlags: UInt16;
    FThisClass: TConstIndex;
    FSuperClass: TConstIndex;
    FFields: TJClassFields;
    FMethods: TJClassMethods;
    FConstants: TJClassConstants;
    FInterfaces: TJClassInterfaces;
    FAttributes: TJClassAttributes;
    function GetAccessFlags: string;
    function GetSuperClass: TJClassClassConstant;
    function GetThisClass: TJClassClassConstant;
  public
    function FindConstant(AIndex: TConstIndex): TJClassConstant; override;
    function FindConstantSafe(AIndex: TConstIndex;
      AClass: TJClassConstantClass): TJClassConstant; override;
    function FindUtf8Constant(AIndex: TConstIndex): string; override;
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    procedure LoadFromStream(AStream: TStream); override;

    property MinorVersion: UInt16 read FMinorVersion;
    property MajorVersion: UInt16 read FMajorVersion;
    property AccessFlags: string read GetAccessFlags;
    property ThisClass: TJClassClassConstant read GetThisClass;
    property SuperClass: TJClassClassConstant read GetSuperClass;
    property Constants: TJClassConstants read FConstants;
    property Interfaces: TJClassInterfaces read FInterfaces;
    property Fields: TJClassFields read FFields;
    property Methods: TJClassMethods read FMethods;
    property Attributes: TJClassAttributes read FAttributes;
    constructor Create;
    destructor Destroy; override;
  end;



implementation

uses
  jclass_enum;

const
  MAGIC = $CAFEBABE;

function TJClassFile.GetAccessFlags: string;
begin
  Result := ClassAccessFlagsToString(FAccessFlags);
end;

function TJClassFile.GetSuperClass: TJClassClassConstant;
begin
  Result := TJClassClassConstant(FindConstantSafe(FSuperClass, TJClassClassConstant));
end;

function TJClassFile.GetThisClass: TJClassClassConstant;
begin
  Result := TJClassClassConstant(FindConstantSafe(FThisClass, TJClassClassConstant));
end;

function TJClassFile.FindConstant(AIndex: TConstIndex): TJClassConstant;
begin
  Result := FConstants.FindConstant(AIndex);
end;

function TJClassFile.FindConstantSafe(AIndex: TConstIndex;
  AClass: TJClassConstantClass): TJClassConstant;
begin
  Result := FConstants.FindConstantSafe(AIndex, AClass);
end;

function TJClassFile.FindUtf8Constant(AIndex: TConstIndex): string;
begin
  Result := FConstants.FindUtf8Constant(AIndex);
end;

procedure TJClassFile.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sVersion: %d,%d', [AIndent, MajorVersion, MinorVersion]);
  AOutput.Add('%sAccess flags: %s', [AIndent, AccessFlags]);
  AOutput.Add('%sThis class: %s', [AIndent, FindUtf8Constant(ThisClass.NameIndex)]);
  AOutput.Add('%sSuper class: %s', [AIndent, FindUtf8Constant(SuperClass.NameIndex)]);
  AOutput.Add('%sInterfaces', [AIndent]);
  FInterfaces.BuildDebugInfo(AIndent + '  ', AOutput);
  AOutput.Add('%sFields', [AIndent]);
  FFields.BuildDebugInfo(AIndent + '  ', AOutput);
  AOutput.Add('%sMethods', [AIndent]);
  FMethods.BuildDebugInfo(AIndent + '  ', AOutput);
  AOutput.Add('%sAttributes', [AIndent]);
  FAttributes.BuildDebugInfo(AIndent + '  ', AOutput);
  AOutput.Add('%sConstants pool', [AIndent]);
  FConstants.BuildDebugInfo(AIndent + '  ', AOutput);
end;

procedure TJClassFile.LoadFromStream(AStream: TStream);
var
  i: integer;
begin
  if not Assigned(AStream) then
    raise Exception.Create('null input stream');
  FMagic := ReadDWord(AStream);
  FMinorVersion := ReadWord(AStream);
  FMajorVersion := ReadWord(AStream);
  FConstants.LoadFromStream(AStream);
  FAccessFlags := ReadWord(AStream);
  FThisClass := ReadWord(AStream);
  FSuperClass := ReadWord(AStream);
  FInterfaces.LoadFromStream(AStream);
  FFields.LoadFromStream(AStream);
  FMethods.LoadFromStream(AStream);
  FAttributes.LoadFromStream(AStream, alClassFile);
end;

constructor TJClassFile.Create;
begin
  FMethods := TJClassMethods.Create(Self);
  FFields := TJClassFields.Create(Self);
  FAttributes := TJClassAttributes.Create(Self);
  FInterfaces := TJClassInterfaces.Create(Self);
  FConstants := TJClassConstants.Create(True);
end;

destructor TJClassFile.Destroy;
begin
  FMethods.Free;
  FAttributes.Free;
  FInterfaces.Free;
  FFields.Free;
  FConstants.Free;
  inherited Destroy;
end;

end.
