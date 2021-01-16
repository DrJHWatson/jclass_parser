unit jclass_attributes;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_types,
  jclass_common,
  jclass_enum;

type
  { TJClassAttribute }

  TJClassAttribute = class(TJClassLoadable)
  protected
    FAttributeNameIndex: UInt16;
    FConstantSearch: TJClassConstantSearch;
    FAttributeLength: UInt32;
  public
    class function GetName: string; virtual; abstract;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; virtual; abstract;
    constructor Create(AConstantSearch: TJClassConstantSearch); virtual;
    procedure LoadFromStream(AStream: TStream); override;
    function AsString: string; virtual;
  end;

  TJClassAttributeClass = class of TJClassAttribute;

function FindAttributeClass(AName: string; ALocation: TJAttributeLocation): TJClassAttributeClass;

implementation

uses
  jclass_attributes_implementation;

var
  classList: TList = nil;

function FindAttributeClass(AName: string; ALocation: TJAttributeLocation): TJClassAttributeClass;
var
  c: Pointer;
begin
  Result := nil;
  for c in classList do
    with TJClassAttributeClass(c) do
      if SameText(AName, GetName) and SupportsLocation(ALocation) then
      begin
        Result := TJClassAttributeClass(c);
        Break;
      end;
  if not Assigned(Result) then
    Result := TJClassUnknownAttribute;
end;

{ TJClassAttribute }

procedure TJClassAttribute.LoadFromStream(AStream: TStream);
begin
  ReadElement(AStream, @FAttributeLength, etDWord);
end;

function TJClassAttribute.AsString: string;
begin
  Result := 'value is not available';
end;

constructor TJClassAttribute.Create(AConstantSearch: TJClassConstantSearch);
begin
  FConstantSearch := AConstantSearch;
end;

initialization
  classList := TList.Create;

  classList.Add(TJClassSyntheticAttribute);
  classList.Add(TJClassDeprecatedAttribute);
  classList.Add(TJClassSourceFileAttribute);
  classList.Add(TJClassSignatureAttribute);
  classList.Add(TJClassSourceDebugExtensionAttribute);
  classList.Add(TJClassUnknownAttribute);
  classList.Add(TJClassRuntimeVisibleParameterAnnotationsAttribute);
  classList.Add(TJClassRuntimeInvisibleParameterAnnotationsAttribute);
  classList.Add(TJClassLocalVariableTableAttribute);
  classList.Add(TJClassLocalVariableTypeTableAttribute);
  classList.Add(TJClassRuntimeVisibleAnnotationsAttribute);
  classList.Add(TJClassRuntimeInvisibleAnnotationsAttribute);
  classList.Add(TJClassAnnotationDefaultAttribute);
  classList.Add(TJClassExceptionsAttribute);
  classList.Add(TJClassCodeAttribute);
  classList.Add(TJClassInnerClassesAttribute);
  classList.Add(TJClassRuntimeVisibleTypeAnnotationsAttribute);
  classList.Add(TJClassRuntimeInvisibleTypeAnnotationsAttribute);
  classList.Add(TJClassEnclosingMethodAttribute);
  classList.Add(TJClassBootstrapMethodsAttribute);
  classList.Add(TJClassLineNumberTableAttribute);
  classList.Add(TJClassStackMapTableAttribute);
  classList.Add(TJClassMethodParametersAttribute);
  classList.Add(TJClassModuleAttribute);
  classList.Add(TJClassModulePackagesAttribute);
  classList.Add(TJClassModuleMainClassAttribute);
  classList.Add(TJClassNestHostAttribute);
  classList.Add(TJClassNestMembersAttribute);

finalization
  classList.Free;

end.
