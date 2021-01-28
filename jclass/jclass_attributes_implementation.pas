unit jclass_attributes_implementation;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_attributes_abstract,
  jclass_attributes,
  jclass_annotations,
  jclass_types,
  jclass_common,
  jclass_stack_map_frame,
  jclass_enum,
  jclass_constants,
  jclass_common_abstract,
  jclass_code_sequence;

type
  { TJClassSyntheticAttribute }

  TJClassSyntheticAttribute = class(TJClassAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
  end;

  { TJClassDeprecatedAttribute }

  TJClassDeprecatedAttribute = class(TJClassAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
  end;

  { TJClassSourceFileAttribute }

  TJClassSourceFileAttribute = class(TJClassIndexAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    property SourceFileIndex: UInt16 read FIndex;
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
  end;

  { TJClassSignatureAttribute }

  TJClassSignatureAttribute = class(TJClassIndexAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    property SignatureIndex: UInt16 read FIndex;
  end;

  { TJClassConstantValueAttribute }

  TJClassConstantValueAttribute = class(TJClassIndexAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    property ConstantValueIndex: UInt16 read FIndex;
  end;

  { TJClassSourceDebugExtensionAttribute }

  TJClassSourceDebugExtensionAttribute = class(TJClassBufferAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    property SourceDebugExtension: TBytes read FData;
  end;

  { TJClassUnknownAttribute }

  TJClassUnknownAttribute = class(TJClassBufferAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    property RawData: TBytes read FData;
  end;

  { TJClassRuntimeVisibleParameterAnnotationsAttribute }

  TJClassRuntimeVisibleParameterAnnotationsAttribute =
    class(TJClassRuntimeParameterAnnotationsAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassRuntimeInvisibleParameterAnnotationsAttribute }

  TJClassRuntimeInvisibleParameterAnnotationsAttribute =
    class(TJClassRuntimeParameterAnnotationsAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassLocalVariableTableAttribute }

  TJClassLocalVariableTableAttribute = class(TJClassLocalVariableAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassLocalVariableTypeTableAttribute }

  TJClassLocalVariableTypeTableAttribute = class(TJClassLocalVariableAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassRuntimeVisibleAnnotationsAttribute }

  TJClassRuntimeVisibleAnnotationsAttribute = class(TJClassRuntimeAnnotationsAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassRuntimeInvisibleAnnotationsAttribute }

  TJClassRuntimeInvisibleAnnotationsAttribute = class(TJClassRuntimeAnnotationsAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassAnnotationDefaultAttribute }

  TJClassAnnotationDefaultAttribute = class(TJClassAttribute)
  private
    FElementValue: TJClassElementValue;
  public
    destructor Destroy; override;
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassExceptionsAttribute }

  TJClassExceptionsAttribute = class(TJClassAttribute)
  private
    FExceptionIndexTable: array of UInt16;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassCodeAttribute }

  TJClassCodeAttribute = class(TJClassAttribute)
  private
    FMaxStack: UInt16;
    FMaxLocals: UInt16;
    FCode: TBytes;
    FExceptionTable: array of TJClassCodeException;
    FAttributes: TJClassAttributes;
    FCodeSequence: TJClassCodeSequence;
    procedure LoadCodeSequesce;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
    constructor Create(AClassFile: TJClassFileAbstract); override;
    destructor Destroy; override;
  end;

  { TJClassInnerClassesAttribute }

  TJClassInnerClassesAttribute = class(TJClassAttribute)
  private
    FClasses: array of TJClassInnerClass;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
  end;

  { TJClassRuntimeVisibleTypeAnnotationsAttribute }

  TJClassRuntimeVisibleTypeAnnotationsAttribute = class(TJClassRuntimeTypeAnnotationsAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassRuntimeInvisibleTypeAnnotationsAttribute }

  TJClassRuntimeInvisibleTypeAnnotationsAttribute = class(TJClassRuntimeTypeAnnotationsAttribute)
  public
    class function GetName: string; override;
  end;

  { TJClassEnclosingMethodAttribute }

  TJClassEnclosingMethodAttribute = class(TJClassAttribute)
  private
    FClassIndex: UInt16;
    FMethodIndex: UInt16;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassBootstrapMethodsAttribute }

  TJClassBootstrapMethodsAttribute = class(TJClassAttribute)
  private
    FBootstrapMethods: array of TJClassBootstrapMethods;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassMethodParametersAttribute }

  TJClassMethodParametersAttribute = class(TJClassAttribute)
  private
    FParameters: array of TJClassMethodParameter;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassLineNumberTableAttribute }

  TJClassLineNumberTableAttribute = class(TJClassAttribute)
  private
    FLineNumberTable: array of TJClassLineNumberEntry;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassStackMapTableAttribute }

  TJClassStackMapTableAttribute = class(TJClassAttribute)
  private
    FEntries: array of TJClassStackMapFrame;
  public
    destructor Destroy; override;
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassModuleAttribute }

  TJClassModuleAttribute = class(TJClassAttribute)
  private
    FModuleNameIndex: UInt16;
    FModuleFlags: UInt16;
    FModuleVersionIndex: UInt16;
    FRequires: array of TJClassModuleRequirement;
    FExports: array of TJClassModuleExports;
    FOpens: array of TJClassModuleOpens;
    FUsesIndices: array of UInt16;
    FProvides: array of TJClassModuleProvides;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassModulePackagesAttribute }

  TJClassModulePackagesAttribute = class(TJClassAttribute)
  private
    FPackageIndices: array of UInt16;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassModuleMainClassAttribute }

  TJClassModuleMainClassAttribute = class(TJClassIndexAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
  end;

  { TJClassNestHostAttribute }

  TJClassNestHostAttribute = class(TJClassIndexAttribute)
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
  end;

  { TJClassNestMembersAttribute }

  TJClassNestMembersAttribute = class(TJClassAttribute)
  private
    FClasses: array of UInt16;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
  end;

implementation

{ TJClassModuleAttribute }

class function TJClassModuleAttribute.GetName: string;
begin
  Result := 'Module';
end;

class function TJClassModuleAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassModuleAttribute.LoadFromStream(AStream: TStream);
var
  buf, bufL2: UInt16;
  i, j: integer;
begin
  inherited LoadFromStream(AStream);
  FModuleNameIndex := ReadWord(AStream);
  FModuleFlags := ReadWord(AStream);
  FModuleVersionIndex := ReadWord(AStream);
  buf := ReadWord(AStream);
  SetLength(FRequires, buf);
  for i := 0 to buf - 1 do
  begin
    FRequires[i].RequirementIndex := ReadWord(AStream);
    FRequires[i].RequirementFlags := ReadWord(AStream);
    FRequires[i].RequirementVersionIndex := ReadWord(AStream);
  end;

  buf := ReadWord(AStream);
  SetLength(FExports, buf);
  for i := 0 to buf - 1 do
  begin
    FExports[i].ExportsIndex := ReadWord(AStream);
    FExports[i].ExportsFlags := ReadWord(AStream);
    bufL2 := ReadWord(AStream);
    SetLength(FExports[i].ExportsToIndices, bufL2);
    for j := 0 to bufL2 - 1 do
      FExports[i].ExportsToIndices[j] := ReadWord(AStream);
  end;

  buf := ReadWord(AStream);
  SetLength(FOpens, buf);
  for i := 0 to buf - 1 do
  begin
    FOpens[i].OpensIndex := ReadWord(AStream);
    FOpens[i].OpensFlags := ReadWord(AStream);
    bufL2 := ReadWord(AStream);
    SetLength(FOpens[i].OpensToIndices, bufL2);
    for j := 0 to bufL2 - 1 do
      FOpens[i].OpensToIndices[j] := ReadWord(AStream);
  end;

  buf := ReadWord(AStream);
  SetLength(FUsesIndices, buf);
  for i := 0 to buf - 1 do
    FUsesIndices[i] := ReadWord(AStream);

  buf := ReadWord(AStream);
  SetLength(FProvides, buf);
  for i := 0 to buf - 1 do
  begin
    FProvides[i].ProvidesIndex := ReadWord(AStream);
    bufL2 := ReadWord(AStream);
    SetLength(FProvides[i].ProvidesWithIndices, bufL2);
    for j := 0 to bufL2 - 1 do
      FProvides[i].ProvidesWithIndices[j] := ReadWord(AStream);
  end;
end;

{ TJClassModulePackagesAttribute }

class function TJClassModulePackagesAttribute.GetName: string;
begin
  Result := 'ModulePackages';
end;

class function TJClassModulePackagesAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassModulePackagesAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  buf := ReadWord(AStream);
  SetLength(FPackageIndices, buf);
  if buf > 0 then
    for i := 0 to buf - 1 do
      FPackageIndices[i] := ReadWord(AStream);
end;

{ TJClassModuleMainClassAttribute }

class function TJClassModuleMainClassAttribute.GetName: string;
begin
  Result := 'ModuleMainClass';
end;

class function TJClassModuleMainClassAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

{ TJClassNestHostAttribute }

class function TJClassNestHostAttribute.GetName: string;
begin
  Result := 'NestHost';
end;

class function TJClassNestHostAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

{ TJClassNestMembersAttribute }

class function TJClassNestMembersAttribute.GetName: string;
begin
  Result := 'NestMembers';
end;

class function TJClassNestMembersAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassNestMembersAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  buf := ReadWord(AStream);
  SetLength(FClasses, buf);
  if buf > 0 then
    for i := 0 to buf - 1 do
      FClasses[i] := ReadWord(AStream);
end;

procedure TJClassNestMembersAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  cl: TJClassClassConstant;
  i: integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, Length(FClasses)]);
  for i := 0 to High(FClasses) do
  begin
    cl := FClassFile.FindConstantSafe(FClasses[i], TJClassClassConstant) as TJClassClassConstant;
    AOutput.Add('%s  %s', [AIndent, FClassFile.FindUtf8Constant(cl.NameIndex)]);
  end;
end;

{ TJClassSignatureAttribute }

class function TJClassSignatureAttribute.GetName: string;
begin
  Result := 'Signature';
end;

class function TJClassSignatureAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation in [alClassFile, alMethodInfo, alFieldInfo];
end;

{ TJClassStackMapTableAttribute }

destructor TJClassStackMapTableAttribute.Destroy;
var
  e: TJClassStackMapFrame;
begin
  for e in FEntries do
    e.Free;
  inherited Destroy;
end;

class function TJClassStackMapTableAttribute.GetName: string;
begin
  Result := 'StackMapTable';
end;

class function TJClassStackMapTableAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alCode;
end;

procedure TJClassStackMapTableAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  buf := ReadWord(AStream);
  SetLength(FEntries, buf);
  for i := 0 to buf - 1 do
  begin
    FEntries[i] := TJClassStackMapFrame.Create;
    FEntries[i].LoadFromStream(AStream);
  end;
end;

{ TJClassLineNumberTableAttribute }

procedure TJClassLineNumberTableAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, Length(FLineNumberTable)]);
  for i := 0 to Length(FLineNumberTable) - 1 do
    with FLineNumberTable[i] do
      AOutput.Add('%s  #%d -- %.8x', [AIndent, LineNumber, StartPC]);
end;

class function TJClassLineNumberTableAttribute.GetName: string;
begin
  Result := 'LineNumberTable';
end;

class function TJClassLineNumberTableAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alCode;
end;

procedure TJClassLineNumberTableAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  buf := ReadWord(AStream);
  SetLength(FLineNumberTable, buf);
  for i := 0 to buf - 1 do
  begin
    FLineNumberTable[i].StartPC := ReadWord(AStream);
    FLineNumberTable[i].LineNumber := ReadWord(AStream);
  end;
end;

{ TJClassMethodParametersAttribute }

class function TJClassMethodParametersAttribute.GetName: string;
begin
  Result := 'MethodParameters';
end;

class function TJClassMethodParametersAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alMethodInfo;
end;

procedure TJClassMethodParametersAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt8;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  buf := ReadByte(AStream);
  SetLength(FParameters, buf);
  for i := 0 to buf - 1 do
  begin
    FParameters[i].NameIndex := ReadWord(AStream);
    FParameters[i].AccessFlags := ReadWord(AStream);
  end;
end;

{ TJClassBootstrapMethodsAttribute }

class function TJClassBootstrapMethodsAttribute.GetName: string;
begin
  Result := 'BootstrapMethods';
end;

class function TJClassBootstrapMethodsAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassBootstrapMethodsAttribute.LoadFromStream(AStream: TStream);
var
  methodsCount: UInt16;
  argumentsCount: UInt16;
  i, j: integer;
begin
  inherited LoadFromStream(AStream);
  methodsCount := ReadWord(AStream);
  SetLength(FBootstrapMethods, methodsCount);
  for i := 0 to methodsCount - 1 do
  begin
    FBootstrapMethods[i].BootstrapMethodRef := ReadWord(AStream);
    argumentsCount := ReadWord(AStream);
    SetLength(FBootstrapMethods[i].BootstrapArguments, argumentsCount);
    for j := 0 to argumentsCount - 1 do
      FBootstrapMethods[i].BootstrapArguments[j] := ReadWord(AStream);
  end;
end;

{ TJClassEnclosingMethodAttribute }

class function TJClassEnclosingMethodAttribute.GetName: string;
begin
  Result := 'EnclosingMethod';
end;

class function TJClassEnclosingMethodAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassEnclosingMethodAttribute.LoadFromStream(AStream: TStream);
begin
  inherited LoadFromStream(AStream);
  FClassIndex := ReadWord(AStream);
  FMethodIndex := ReadWord(AStream);
end;

{ TJClassRuntimeInvisibleTypeAnnotationsAttribute }

class function TJClassRuntimeInvisibleTypeAnnotationsAttribute.GetName: string;
begin
  Result := 'RuntimeInvisibleTypeAnnotations';
end;

{ TJClassRuntimeVisibleTypeAnnotationsAttribute }

class function TJClassRuntimeVisibleTypeAnnotationsAttribute.GetName: string;
begin
  Result := 'RuntimeVisibleTypeAnnotations';
end;

{ TJClassInnerClassesAttribute }

class function TJClassInnerClassesAttribute.GetName: string;
begin
  Result := 'InnerClasses';
end;

class function TJClassInnerClassesAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassInnerClassesAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  buf := ReadWord(AStream);
  SetLength(FClasses, buf);
  for i := 0 to buf - 1 do
  begin
    FClasses[i].InnerClassInfoIndex := ReadWord(AStream);
    FClasses[i].OuterClassInfoIndex := ReadWord(AStream);
    FClasses[i].InnerNameIndex := ReadWord(AStream);
    FClasses[i].InnerClassAccessFlags := ReadWord(AStream);
  end;
end;

procedure TJClassInnerClassesAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
  innerClassName: string;
begin
  AOutput.Add('%sCount: %d', [AIndent, Length(FClasses)]);
  for i := 0 to Length(FClasses) - 1 do
  begin
    if FClasses[i].InnerNameIndex = 0 then
      innerClassName := 'anonymous'
    else
      innerClassName := FClassFile.FindUtf8Constant(FClasses[i].InnerNameIndex);
    AOutput.Add('%s  %s (%s);', [AIndent, innerClassName, ClassAccessFlagsToString(
      FClasses[i].InnerClassAccessFlags)]);
  end;
end;

{ TJClassAnnotationDefaultAttribute }

destructor TJClassAnnotationDefaultAttribute.Destroy;
begin
  FElementValue.Free;
  inherited Destroy;
end;

class function TJClassAnnotationDefaultAttribute.GetName: string;
begin
  Result := 'AnnotationDefault';
end;

class function TJClassAnnotationDefaultAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alMethodInfo;
end;

procedure TJClassAnnotationDefaultAttribute.LoadFromStream(AStream: TStream);
begin
  inherited LoadFromStream(AStream);
  FElementValue := TJClassElementValue.Create;
  FElementValue.LoadFromStream(AStream);
end;

{ TJClassRuntimeInvisibleAnnotationsAttribute }

class function TJClassRuntimeInvisibleAnnotationsAttribute.GetName: string;
begin
  Result := 'RuntimeInvisibleAnnotations';
end;

{ TJClassRuntimeVisibleAnnotationsAttribute }

class function TJClassRuntimeVisibleAnnotationsAttribute.GetName: string;
begin
  Result := 'RuntimeVisibleAnnotations';
end;

{ TJClassLocalVariableTypeTableAttribute }

class function TJClassLocalVariableTypeTableAttribute.GetName: string;
begin
  Result := 'LocalVariableTypeTable';
end;

{ TJClassLocalVariableTableAttribute }

class function TJClassLocalVariableTableAttribute.GetName: string;
begin
  Result := 'LocalVariableTable';
end;

{ TJClassRuntimeInvisibleParameterAnnotationsAttribute }

class function TJClassRuntimeInvisibleParameterAnnotationsAttribute.GetName: string;
begin
  Result := 'RuntimeInvisibleParameterAnnotations';
end;

{ TJClassRuntimeVisibleParameterAnnotationsAttribute }

class function TJClassRuntimeVisibleParameterAnnotationsAttribute.GetName: string;
begin
  Result := 'RuntimeVisibleParameterAnnotations';
end;

{ TJClassSyntheticAttribute }

class function TJClassSyntheticAttribute.GetName: string;
begin
  Result := 'Synthetic';
end;

class function TJClassSyntheticAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation in [alClassFile, alMethodInfo, alFieldInfo];
end;

{ TJClassDeprecatedAttribute }

class function TJClassDeprecatedAttribute.GetName: string;
begin
  Result := 'Deprecated';
end;

class function TJClassDeprecatedAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation in [alClassFile, alMethodInfo, alFieldInfo];
end;

{ TJClassUnknownAttribute }

class function TJClassUnknownAttribute.GetName: string;
begin
  Result := 'UNKNOWN';
end;

class function TJClassUnknownAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation in [alClassFile, alMethodInfo, alFieldInfo, alCode];
end;

{ TJClassSourceFileAttribute }

class function TJClassSourceFileAttribute.GetName: string;
begin
  Result := 'SourceFile';
end;

class function TJClassSourceFileAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassSourceFileAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add(AIndent + FClassFile.FindUtf8Constant(FIndex));
end;

{ TJClassConstantValueAttribute }

class function TJClassConstantValueAttribute.GetName: string;
begin
  Result := 'ConstantValue';
end;

class function TJClassConstantValueAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alFieldInfo;
end;

{ TJClassSourceDebugExtensionAttribute }

class function TJClassSourceDebugExtensionAttribute.GetName: string;
begin
  Result := 'SourceDebugExtension';
end;

class function TJClassSourceDebugExtensionAttribute.SupportsLocation(
  ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

{ TJClassExceptionsAttribute }

class function TJClassExceptionsAttribute.GetName: string;
begin
  Result := 'Exceptions';
end;

class function TJClassExceptionsAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alMethodInfo;
end;

procedure TJClassExceptionsAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: integer;
begin
  inherited;
  buf := ReadWord(AStream);
  SetLength(FExceptionIndexTable, buf);
  for i := 0 to buf - 1 do
    FExceptionIndexTable[i] := ReadWord(AStream);
end;

{ TJClassCodeAttribute }

procedure TJClassCodeAttribute.LoadCodeSequesce;
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.Write(FCode[0], Length(FCode));
    ms.Position := 0;
    FCodeSequence.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;

procedure TJClassCodeAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
begin
  AOutput.Add('%s---Code-------------', [AIndent]);
  AOutput.Add('%sMaxStack: %d', [AIndent, FMaxStack]);
  AOutput.Add('%sMaxLocals: %d', [AIndent, FMaxLocals]);
  AOutput.Add('%sCode sequence (length: %d)', [AIndent, FCodeSequence.Count]);
  FCodeSequence.BuildDebugInfo(AIndent + '  ', AOutput);
  for i := 0 to Length(FExceptionTable) - 1 do
    AOutput.Add('%sException: StartPC %d, EndPC %d, HandlerPC %d, CatchType %d',
      [AIndent, FExceptionTable[i].StartPC, FExceptionTable[i].EndPC,
      FExceptionTable[i].HandlerPC, FExceptionTable[i].CatchType]);
  AOutput.Add('%sAttributes', [AIndent]);
  FAttributes.BuildDebugInfo(AIndent + '  ', AOutput);
  AOutput.Add('%s--------------------', [AIndent]);
end;

class function TJClassCodeAttribute.GetName: string;
begin
  Result := 'Code';
end;

class function TJClassCodeAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation = alMethodInfo;
end;

procedure TJClassCodeAttribute.LoadFromStream(AStream: TStream);
var
  codeLength: UInt32;
  i: integer;
begin
  inherited;
  FMaxStack := ReadWord(AStream);
  FMaxLocals := ReadWord(AStream);
  codeLength := ReadDWord(AStream);
  SetLength(FCode, codeLength);
  if codeLength > 0 then
    AStream.Read(FCode[0], codeLength);
  LoadCodeSequesce;
  SetLength(FExceptionTable, ReadWord(AStream));
  for i := 0 to High(FExceptionTable) do
  begin
    FExceptionTable[i].StartPC := ReadWord(AStream);
    FExceptionTable[i].EndPC := ReadWord(AStream);
    FExceptionTable[i].HandlerPC := ReadWord(AStream);
    FExceptionTable[i].CatchType := ReadWord(AStream);
  end;
  FAttributes.LoadFromStream(AStream, alCode);
end;

constructor TJClassCodeAttribute.Create(AClassFile: TJClassFileAbstract);
begin
  inherited Create(AClassFile);
  FAttributes := TJClassAttributes.Create(AClassFile);
  FCodeSequence := TJClassCodeSequence.Create;
end;

destructor TJClassCodeAttribute.Destroy;
begin
  FAttributes.Free;
  FCodeSequence.Free;
  inherited Destroy;
end;

end.
