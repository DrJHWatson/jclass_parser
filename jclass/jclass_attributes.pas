unit jclass_attributes;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common,
  jclass_enum,
  jclass_constants,
  jclass_common_abstract,
  fgl;

type
  { TJClassAttribute }

  TJClassAttribute = class(TJClassLoadable)
  protected
    FAttributeNameIndex: UInt16;
    FClassFile: TJClassFileAbstract;
    FAttributeLength: UInt32;
  public
    class function GetName: string; virtual; abstract;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; virtual; abstract;
    constructor Create(AClassFile: TJClassFileAbstract); virtual;
    procedure LoadFromStream(AStream: TStream); override;
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    generic function AsClass<T>: T;
  end;

  TJClassAttributeClass = class of TJClassAttribute;

  { TJClassAttributes }

  TJClassAttributes = class(specialize TFPGObjectList<TJClassAttribute>)
  private
    class var
      FClassList: TList;
  private
    FClassFile: TJClassFileAbstract;
    function FindAttributeClass(AName: string;
      ALocation: TJAttributeLocation): TJClassAttributeClass;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings);
    procedure LoadFromStream(AStream: TStream; ALocation: TJAttributeLocation);
    function NewAttribute(AName: string; ALocation: TJAttributeLocation): TJClassAttribute;
    constructor Create(AClassFile: TJClassFileAbstract);
    class constructor ClassCreate;
    class destructor ClassDestroy;
  end;

implementation

uses
  jclass_attributes_implementation;

function TJClassAttributes.FindAttributeClass(AName: string;
  ALocation: TJAttributeLocation): TJClassAttributeClass;
var
  c: Pointer;
begin
  Result := nil;
  for c in FClassList do
    with TJClassAttributeClass(c) do
      if SameText(AName, GetName) and SupportsLocation(ALocation) then
      begin
        Result := TJClassAttributeClass(c);
        Break;
      end;
  if not Assigned(Result) then
    Result := TJClassUnknownAttribute;
end;

procedure TJClassAttributes.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: Integer;
begin
  AOutput.Add('%sCount %d', [AIndent, Count]);
  for i:=0 to Count-1 do
  begin
    AOutput.Add('%s  %s', [AIndent, Items[i].GetName]);
    Items[i].BuildDebugInfo(AIndent + '    ', AOutput);
  end;
end;

procedure TJClassAttributes.LoadFromStream(AStream: TStream; ALocation: TJAttributeLocation);
var
  attrCount: UInt16;
  attrNameIndex: UInt16;
  attributeName: string;
  i: integer;
begin
  attrCount := FClassFile.ReadWord(AStream);
  for i := 0 to attrCount - 1 do
  begin
    attrNameIndex := FClassFile.ReadWord(AStream);
    attributeName := FClassFile.FindUtf8Constant(attrNameIndex);
    NewAttribute(attributeName, ALocation).LoadFromStream(AStream);
  end;
end;

function TJClassAttributes.NewAttribute(AName: string; ALocation: TJAttributeLocation): TJClassAttribute;
begin
  Result := FindAttributeClass(AName, ALocation).Create(FClassFile);
  Add(Result);
end;

constructor TJClassAttributes.Create(AClassFile: TJClassFileAbstract);
begin
  inherited Create();
  FClassFile:= AClassFile;
end;

class constructor TJClassAttributes.ClassCreate;
begin
  FClassList := TList.Create;

  FClassList.Add(TJClassSyntheticAttribute);
  FClassList.Add(TJClassDeprecatedAttribute);
  FClassList.Add(TJClassSourceFileAttribute);
  FClassList.Add(TJClassSignatureAttribute);
  FClassList.Add(TJClassSourceDebugExtensionAttribute);
  FClassList.Add(TJClassUnknownAttribute);
  FClassList.Add(TJClassRuntimeVisibleParameterAnnotationsAttribute);
  FClassList.Add(TJClassRuntimeInvisibleParameterAnnotationsAttribute);
  FClassList.Add(TJClassLocalVariableTableAttribute);
  FClassList.Add(TJClassLocalVariableTypeTableAttribute);
  FClassList.Add(TJClassRuntimeVisibleAnnotationsAttribute);
  FClassList.Add(TJClassRuntimeInvisibleAnnotationsAttribute);
  FClassList.Add(TJClassAnnotationDefaultAttribute);
  FClassList.Add(TJClassExceptionsAttribute);
  FClassList.Add(TJClassCodeAttribute);
  FClassList.Add(TJClassInnerClassesAttribute);
  FClassList.Add(TJClassRuntimeVisibleTypeAnnotationsAttribute);
  FClassList.Add(TJClassRuntimeInvisibleTypeAnnotationsAttribute);
  FClassList.Add(TJClassEnclosingMethodAttribute);
  FClassList.Add(TJClassBootstrapMethodsAttribute);
  FClassList.Add(TJClassLineNumberTableAttribute);
  FClassList.Add(TJClassStackMapTableAttribute);
  FClassList.Add(TJClassMethodParametersAttribute);
  FClassList.Add(TJClassModuleAttribute);
  FClassList.Add(TJClassModulePackagesAttribute);
  FClassList.Add(TJClassModuleMainClassAttribute);
  FClassList.Add(TJClassNestHostAttribute);
  FClassList.Add(TJClassNestMembersAttribute);
end;

class destructor TJClassAttributes.ClassDestroy;
begin
  FClassList.Free;
end;

{ TJClassAttribute }

procedure TJClassAttribute.LoadFromStream(AStream: TStream);
begin
  FAttributeLength := ReadDWord(AStream);
end;

procedure TJClassAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('not supported (%s)', [ClassName]);
end;

generic function TJClassAttribute.AsClass<T>: T;
begin
  Result := T(Self);
end;

constructor TJClassAttribute.Create(AClassFile: TJClassFileAbstract);
begin
  FClassFile := AClassFile;
end;

end.
