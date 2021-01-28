unit jclass_attributes_abstract;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_attributes,
  jclass_types,
  jclass_annotations,
  jclass_enum;

type
  { TJClassBufferAttribute }

  TJClassBufferAttribute = class(TJClassAttribute)
  protected
    FData: TBytes;
  public
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassIndexAttribute }

  TJClassIndexAttribute = class(TJClassAttribute)
  protected
    FIndex: UInt16;
  public
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassRuntimeParameterAnnotationsAttribute }

  TJClassRuntimeParameterAnnotationsAttribute = class(TJClassAttribute)
  private
    FParameters: TList;
  public
    destructor Destroy; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassLocalVariableAttribute }

  TJClassLocalVariableAttribute = class(TJClassAttribute)
  private
    FLocalVariableTable: array of TLocalVariableTableRecord;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassRuntimeAnnotationsAttribute }

  TJClassRuntimeAnnotationsAttribute = class(TJClassAttribute)
  private
    FAnnotations: TList;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    destructor Destroy; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  //ClassFile,field_info,method_info, Code

  { TJClassRuntimeTypeAnnotationsAttribute }

  TJClassRuntimeTypeAnnotationsAttribute = class(TJClassAttribute)
  private
    FAnnotations: TList;
  public
    destructor Destroy; override;
    class function SupportsLocation(ALocation: TJAttributeLocation): boolean; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

implementation

{ TJClassRuntimeTypeAnnotationsAttribute }

destructor TJClassRuntimeTypeAnnotationsAttribute.Destroy;
var
  i: integer;
begin
  if Assigned(FAnnotations) then
  begin
    for i := 0 to FAnnotations.Count - 1 do
      TObject(FAnnotations[i]).Free;
    FAnnotations.Free;
  end;
  inherited Destroy;
end;

class function TJClassRuntimeTypeAnnotationsAttribute.SupportsLocation(
  ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation in [alClassFile, alMethodInfo, alFieldInfo, alCode];
end;

procedure TJClassRuntimeTypeAnnotationsAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  annotation: TJClassTypeAnnotation;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  FAnnotations := TList.Create;
  buf := ReadWord(AStream);
  for i := 0 to buf - 1 do
  begin
    annotation := TJClassTypeAnnotation.Create;
    try
      annotation.LoadFromStream(AStream);
      FAnnotations.Add(annotation);
    except
      annotation.Free;
      raise;
    end;
  end;
end;

{ TJClassRuntimeAnnotationsAttribute }

procedure TJClassRuntimeAnnotationsAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, FAnnotations.Count]);
  for i := 0 to FAnnotations.Count - 1 do
    TJClassAnnotation(FAnnotations[i]).BuildDebugInfo(AIndent + '  ', AOutput);
end;

destructor TJClassRuntimeAnnotationsAttribute.Destroy;
var
  i: integer;
begin
  if Assigned(FAnnotations) then
  begin
    for i := 0 to FAnnotations.Count - 1 do
      TObject(FAnnotations[i]).Free;
    FAnnotations.Free;
  end;
  inherited Destroy;
end;

class function TJClassRuntimeAnnotationsAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation in [alClassFile, alMethodInfo, alFieldInfo];
end;

procedure TJClassRuntimeAnnotationsAttribute.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  annotation: TJClassAnnotation;
  i: integer;
begin
  inherited LoadFromStream(AStream);
  FAnnotations := TList.Create;
  buf := ReadWord(AStream);
  for i := 0 to buf - 1 do
  begin
    annotation := TJClassAnnotation.Create;
    try
      annotation.LoadFromStream(AStream);
      FAnnotations.Add(annotation);
    except
      annotation.Free;
      raise;
    end;
  end;
end;

{ TJClassLocalVariableAttribute }

procedure TJClassLocalVariableAttribute.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, Length(FLocalVariableTable)]);
  for i := 0 to High(FLocalVariableTable) do
    with FLocalVariableTable[i] do
    begin
      AOutput.Add('%s  Name: %s', [AIndent, FClassFile.FindUtf8Constant(NameIndex)]);
      AOutput.Add('%s    %.8x (%.8x)', [AIndent, StartPC, Length]);
      AOutput.Add('%s    Target: %d', [AIndent, TargetIndex]);
      AOutput.Add('%s    Index: %d', [AIndent, Index]);
    end;
end;

class function TJClassLocalVariableAttribute.SupportsLocation(ALocation:
  TJAttributeLocation): boolean;
begin
  Result := ALocation = alCode;
end;

procedure TJClassLocalVariableAttribute.LoadFromStream(AStream: TStream);
var
  i: integer;
begin
  inherited LoadFromStream(AStream);
  SetLength(FLocalVariableTable, ReadWord(AStream));
  for i := 0 to High(FLocalVariableTable) do
  begin
    FLocalVariableTable[i].StartPC := ReadWord(AStream);
    FLocalVariableTable[i].Length := ReadWord(AStream);
    FLocalVariableTable[i].NameIndex := ReadWord(AStream);
    FLocalVariableTable[i].TargetIndex := ReadWord(AStream);
    FLocalVariableTable[i].Index := ReadWord(AStream);
  end;
end;

{ TJClassRuntimeParameterAnnotationsAttribute }

destructor TJClassRuntimeParameterAnnotationsAttribute.Destroy;
var
  i, j: integer;
begin
  for i := 0 to FParameters.Count - 1 do
  begin
    for j := 0 to TList(FParameters[i]).Count - 1 do
      TObject(TList(FParameters[i])[j]).Free;
    TObject(FParameters[i]).Free;
  end;
  FParameters.Free;
  inherited Destroy;
end;

class function TJClassRuntimeParameterAnnotationsAttribute.SupportsLocation(
  ALocation: TJAttributeLocation): boolean;
begin
  Result := ALocation = alMethodInfo;
end;

procedure TJClassRuntimeParameterAnnotationsAttribute.LoadFromStream(AStream: TStream);
var
  paramCount: UInt8;
  annotationsCount: UInt16;
  annotations: TList;
  annotation: TJClassAnnotation;
  i, j: integer;
begin
  inherited LoadFromStream(AStream);
  FParameters := TList.Create;
  paramCount := ReadByte(AStream);
  for i := 0 to paramCount - 1 do
  begin
    annotations := TList.Create;
    try
      annotationsCount := ReadWord(AStream);
      for j := 0 to annotationsCount - 1 do
      begin
        annotation := TJClassAnnotation.Create;
        try
          annotation.LoadFromStream(AStream);
          annotations.Add(annotation);
        except
          annotation.Free;
          raise;
        end;
      end;
      FParameters.Add(annotations);
    except
      for j := 0 to annotations.Count - 1 do
        TObject(annotations[i]).Free;
      annotations.Free;
      raise;
    end;
  end;
end;

{ TJClassIndexAttribute }

procedure TJClassIndexAttribute.LoadFromStream(AStream: TStream);
begin
  inherited LoadFromStream(AStream);
  FIndex := ReadWord(AStream);
end;

{ TJClassBufferAttribute }

procedure TJClassBufferAttribute.LoadFromStream(AStream: TStream);
begin
  inherited;
  SetLength(FData, FAttributeLength);
  if FAttributeLength > 0 then
    AStream.Read(FData[0], FAttributeLength);
end;

end.
