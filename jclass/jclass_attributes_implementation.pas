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
  jclass_constants;

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
    function AsString: string; override;
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
    FAttributes: TList;
    procedure LoadCodeAttributes(ASource: TStream; ACount: UInt16);
  public
    function AsString: string; override;
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
    constructor Create(AConstantSearch: TJClassConstantSearch); override;
  end;

  { TJClassInnerClassesAttribute }

  TJClassInnerClassesAttribute = class(TJClassAttribute)
  private
    FClasses: array of TJClassInnerClass;
  public
    class function GetName: string; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
    function AsString: string; override;
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
  i, j: Integer;
begin
  inherited LoadFromStream(AStream);
  ReadElement(AStream, @FModuleNameIndex, etWord);
  ReadElement(AStream, @FModuleFlags, etWord);
  ReadElement(AStream, @FModuleVersionIndex, etWord);
  ReadElement(AStream, @buf, etWord);
  SetLength(FRequires, buf);
  for i:=0 to buf-1 do
  begin
    ReadElement(AStream, @FRequires[i].RequirementIndex, etWord);
    ReadElement(AStream, @FRequires[i].RequirementFlags, etWord);
    ReadElement(AStream, @FRequires[i].RequirementVersionIndex, etWord);
  end;

  ReadElement(AStream, @buf, etWord);
  SetLength(FExports, buf);
  for i:=0 to buf-1 do
  begin
    ReadElement(AStream, @FExports[i].ExportsIndex, etWord);
    ReadElement(AStream, @FExports[i].ExportsFlags, etWord);
    ReadElement(AStream, @bufL2, etWord);
    SetLength(FExports[i].ExportsToIndices, bufL2);
    for j:=0 to bufL2-1 do
      ReadElement(AStream, @FExports[i].ExportsToIndices[j], etWord);
  end;

  ReadElement(AStream, @buf, etWord);
  SetLength(FOpens, buf);
  for i:=0 to buf-1 do
  begin
    ReadElement(AStream, @FOpens[i].OpensIndex, etWord);
    ReadElement(AStream, @FOpens[i].OpensFlags, etWord);
    ReadElement(AStream, @bufL2, etWord);
    SetLength(FOpens[i].OpensToIndices, bufL2);
    for j:=0 to bufL2-1 do
      ReadElement(AStream, @FOpens[i].OpensToIndices[j], etWord);
  end;

  ReadElement(AStream, @buf, etWord);
  SetLength(FUsesIndices, buf);
  for i:=0 to buf-1 do
    ReadElement(AStream, @FUsesIndices[i], etWord);

  ReadElement(AStream, @buf, etWord);
  SetLength(FProvides, buf);
  for i:=0 to buf-1 do
  begin
    ReadElement(AStream, @FProvides[i].ProvidesIndex, etWord);
    ReadElement(AStream, @bufL2, etWord);
    SetLength(FProvides[i].ProvidesWithIndices, bufL2);
    for j:=0 to bufL2-1 do
      ReadElement(AStream, @FProvides[i].ProvidesWithIndices[j], etWord);
  end;
end;

{ TJClassModulePackagesAttribute }

class function TJClassModulePackagesAttribute.GetName: string;
begin
  Result := 'ModulePackages';
end;

class function TJClassModulePackagesAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation = alClassFile;
end;

procedure TJClassModulePackagesAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: Integer;
begin
  inherited LoadFromStream(AStream);
  ReadElement(AStream, @buf, etWord);
  SetLength(FPackageIndices, buf);
  if buf > 0 then
    for i := 0 to buf - 1 do
      ReadElement(AStream, @FPackageIndices[i], etWord);
end;

{ TJClassModuleMainClassAttribute }

class function TJClassModuleMainClassAttribute.GetName: string;
begin
  Result := 'ModuleMainClass';
end;

class function TJClassModuleMainClassAttribute.SupportsLocation(ALocation: TJAttributeLocation): boolean;
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
  i: Integer;
begin
  inherited LoadFromStream(AStream);
  ReadElement(AStream, @buf, etWord);
  SetLength(FClasses, buf);
  if buf > 0 then
    for i := 0 to buf - 1 do
      ReadElement(AStream, @FClasses[i], etWord);
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
  ReadElement(AStream, @buf, etWord);
  SetLength(FEntries, buf);
  for i := 0 to buf - 1 do
  begin
    FEntries[i] := TJClassStackMapFrame.Create;
    FEntries[i].LoadFromStream(AStream);
  end;
end;

{ TJClassLineNumberTableAttribute }

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
  ReadElement(AStream, @buf, etWord);
  SetLength(FLineNumberTable, buf);
  for i := 0 to buf - 1 do
  begin
    ReadElement(AStream, @FLineNumberTable[i].StartPC, etWord);
    ReadElement(AStream, @FLineNumberTable[i].LineNumber, etWord);
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
  ReadElement(AStream, @buf, etByte);
  SetLength(FParameters, buf);
  for i := 0 to buf - 1 do
  begin
    ReadElement(AStream, @FParameters[i].NameIndex, etWord);
    ReadElement(AStream, @FParameters[i].AccessFlags, etWord);
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
  ReadElement(AStream, @methodsCount, etWord);
  SetLength(FBootstrapMethods, methodsCount);
  for i := 0 to methodsCount - 1 do
  begin
    ReadElement(AStream, @FBootstrapMethods[i].BootstrapMethodRef, etWord);
    ReadElement(AStream, @argumentsCount, etWord);
    SetLength(FBootstrapMethods[i].BootstrapArguments, argumentsCount);
    for j := 0 to argumentsCount - 1 do
      ReadElement(AStream, @FBootstrapMethods[i].BootstrapArguments[j], etWord);
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
  ReadElement(AStream, @FClassIndex, etWord);
  ReadElement(AStream, @FMethodIndex, etWord);
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
  ReadElement(AStream, @buf, etWord);
  SetLength(FClasses, buf);
  for i := 0 to buf - 1 do
  begin
    ReadElement(AStream, @FClasses[i].InnerClassInfoIndex, etWord);
    ReadElement(AStream, @FClasses[i].OuterClassInfoIndex, etWord);
    ReadElement(AStream, @FClasses[i].InnerNameIndex, etWord);
    ReadElement(AStream, @FClasses[i].InnerClassAccessFlags, etWord);
  end;
end;

function TJClassInnerClassesAttribute.AsString: string;
var
  i: integer;
  innerClassName: string;
begin
  Result := '';
  for i := 0 to Length(FClasses) - 1 do
  begin
    if FClasses[i].InnerNameIndex = 0 then
      innerClassName := 'anonymous'
    else
      innerClassName := TJClassUtf8Constant(FConstantSearch(
        FClasses[i].InnerNameIndex, TJClassUtf8Constant)).AsString;
    Result := Result + Format(' %s (%s);', [innerClassName,
      ClassAccessFlagsToString(FClasses[i].InnerClassAccessFlags)]);
  end;
  Result := Trim(Result);
  if Result = '' then
    Result := 'empty';
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

function TJClassSourceFileAttribute.AsString: string;
begin
  Result := TJClassUtf8Constant(FConstantSearch(FIndex, TJClassUtf8Constant)).AsString;
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
  ReadElement(AStream, @buf, etWord);
  SetLength(FExceptionIndexTable, buf);
  for i := 0 to buf - 1 do
    ReadElement(AStream, @FExceptionIndexTable[i], etWord);
end;

{ TJClassCodeAttribute }

procedure TJClassCodeAttribute.LoadCodeAttributes(ASource: TStream; ACount: UInt16);
var
  attribute: TJClassAttribute;
  nameIndex: UInt16;
  attributeName: string;
  i: integer;
begin
  for i := 0 to ACount - 1 do
  begin
    ReadElement(ASource, @nameIndex, etWord);
    attributeName := TJClassUtf8Constant(FConstantSearch(nameIndex, TJClassUtf8Constant)).AsString;
    attribute := FindAttributeClass(attributeName, alClassFile).Create(FConstantSearch);
    try
      attribute.LoadFromStream(ASource);
      FAttributes.Add(attribute);
    except
      attribute.Free;
      raise;
    end;
  end;
end;

function TJClassCodeAttribute.AsString: string;
var
  i: Integer;
begin
  Result:='----------------'+LineEnding;
  Result:=Result+Format('MaxStack: %d', [FMaxStack])+LineEnding;
  Result:=Result+Format('MaxLocals: %d', [FMaxLocals])+LineEnding;
  for i:=0 to Length(FExceptionTable)-1 do
    Result:=Result+Format('Exception: StartPC %d, EndPC %d, HandlerPC %d, CatchType %d', [
      FExceptionTable[i].StartPC,
      FExceptionTable[i].EndPC,
      FExceptionTable[i].HandlerPC,
      FExceptionTable[i].CatchType
    ])+LineEnding;
  Result:=Result+'----------------';
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
  buf: UInt16;
  i: integer;
begin
  inherited;
  ReadElement(AStream, @FMaxStack, etWord);
  ReadElement(AStream, @FMaxLocals, etWord);
  ReadElement(AStream, @codeLength, etDWord);
  SetLength(FCode, codeLength);
  if codeLength > 0 then
    AStream.Read(FCode[0], codeLength);
  ReadElement(AStream, @buf, etWord);
  SetLength(FExceptionTable, buf);
  for i := 0 to buf - 1 do
  begin
    ReadElement(AStream, @FExceptionTable[i].StartPC, etWord);
    ReadElement(AStream, @FExceptionTable[i].EndPC, etWord);
    ReadElement(AStream, @FExceptionTable[i].HandlerPC, etWord);
    ReadElement(AStream, @FExceptionTable[i].CatchType, etWord);
  end;
  ReadElement(AStream, @buf, etWord);
  LoadCodeAttributes(AStream, buf);
end;

constructor TJClassCodeAttribute.Create(AConstantSearch: TJClassConstantSearch);
begin
  inherited Create(AConstantSearch);
  FAttributes := TList.Create;
end;

end.
