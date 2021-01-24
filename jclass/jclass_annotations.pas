unit jclass_annotations;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common,
  jclass_types;

type
  TJClassAnnotation = class;

  { TJClassElementValue }

  TJClassElementValue = class(TJClassLoadable)
  private
    FTag: UInt8;
    FFirstIndex: UInt16;
    FSecondIndex: UInt16;
    FArrayValue: TList;
    FAnnotation: TJClassAnnotation;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  TJClassElementValuePair = record
    ElementNameIndex: UInt16;
    ElementValue: TJClassElementValue;
  end;

  { TJClassAnnotation }

  TJClassAnnotation = class(TJClassLoadable)
  private
    FTypeIndex: UInt16;
    FElementValuePairs: array of TJClassElementValuePair;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassTypeAnnotation }

  TJClassTypeAnnotation = class(TJClassLoadable)
  private
    FTargetType: UInt8;

    FTypeParameterTarget: TJClassTypeParameterTarget;
    FSupertypeTarget: TJClassSupertypeTarget;
    FTypeParameterBoundTarget: TJClassTypeParameterBoundTarget;
    FMethodFormalParameterTarget: TJClassMethodFormalParameterTarget;
    FThrowsTarget: TJClassThrowsTarget;
    FLocalvarTarget: TJClassLocalvarTarget;
    FCatchTarget: TJClassCatchTarget;
    FOffsetTarget: TJClassOffsetTarget;
    FTypeArgumentTarget: TJClassTypeArgumentTarget;

    FTypePath: array of TJClassTypePath;
    FTypeIndex: UInt16;
    FElementValuePairs: array of TJClassElementValuePair;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

implementation

uses
  jclass_enum;

{ TJClassTypeAnnotation }

procedure TJClassTypeAnnotation.BuildDebugInfo(AIndent: string;
  AOutput: TStrings);
begin
  AOutput.Add('not supported (TJClassTypeAnnotation)');
end;

destructor TJClassTypeAnnotation.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(FElementValuePairs) do
    FElementValuePairs[i].ElementValue.Free;
  inherited Destroy;
end;

procedure TJClassTypeAnnotation.LoadFromStream(AStream: TStream);
var
  i: integer;
begin
  FTargetType := ReadByte(AStream);
  case FTargetType of
    0, 1: FTypeParameterTarget := ReadByte(AStream);
    $10: FSupertypeTarget := ReadWord(AStream);
    $11, $12:
    begin
      FTypeParameterBoundTarget.TypeParameterIndex := ReadByte(AStream);
      FTypeParameterBoundTarget.BoundIndex := ReadByte(AStream);
    end;
    $16: FMethodFormalParameterTarget := ReadByte(AStream);
    $17: FThrowsTarget := ReadWord(AStream);
    $40, $41:
    begin
      SetLength(FLocalvarTarget, ReadWord(AStream));
      for i := 0 to High(FLocalvarTarget) do
      begin
        FLocalvarTarget[i].StartPC := ReadWord(AStream);
        FLocalvarTarget[i].Length := ReadWord(AStream);
        FLocalvarTarget[i].Index := ReadWord(AStream);
      end;
    end;
    $42: FCatchTarget := ReadWord(AStream);
    $43, $44, $45, $46: FOffsetTarget := ReadWord(AStream);
    $47, $48, $49, $4A, $4B:
    begin
      FTypeArgumentTarget.Offset := ReadWord(AStream);
      FTypeArgumentTarget.TypeArguementIndex := ReadByte(AStream);
    end;
  end;
end;

{ TJClassAnnotation }

procedure TJClassAnnotation.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('not supported (TJClassAnnotation)');
end;

destructor TJClassAnnotation.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(FElementValuePairs) - 1 do
    FElementValuePairs[i].ElementValue.Free;
  inherited Destroy;
end;

procedure TJClassAnnotation.LoadFromStream(AStream: TStream);
var
  i: integer;
begin
  FTypeIndex := ReadWord(AStream);
  SetLength(FElementValuePairs, ReadWord(AStream));
  for i := 0 to High(FElementValuePairs) do
  begin
    FElementValuePairs[i].ElementNameIndex := ReadWord(AStream);
    FElementValuePairs[i].ElementValue := TJClassElementValue.Create;
    FElementValuePairs[i].ElementValue.LoadFromStream(AStream);
  end;
end;

{ TJClassElementValue }

procedure TJClassElementValue.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('not supported (TJClassElementValue)');
end;

destructor TJClassElementValue.Destroy;
var
  i: integer;
begin
  if Assigned(FArrayValue) then
  begin
    for i := 0 to FArrayValue.Count - 1 do
      TJClassElementValue(FArrayValue[i]).Free;
    FArrayValue.Free;
  end;
  FAnnotation.Free;
  inherited Destroy;
end;

procedure TJClassElementValue.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
  i: integer;
  elementValue: TJClassElementValue;
begin
  FTag := ReadByte(AStream);
  case char(FTag) of
    'e':
    begin
      FFirstIndex := ReadWord(AStream);
      FSecondIndex := ReadWord(AStream);
    end;
    '@':
    begin
      FAnnotation := TJClassAnnotation.Create;
      FAnnotation.LoadFromStream(AStream);
    end;
    '[':
    begin
      buf := ReadWord(AStream);
      FArrayValue := TList.Create;
      for i := 0 to buf - 1 do
      begin
        elementValue := TJClassElementValue.Create;
        try
          elementValue.LoadFromStream(AStream);
          FArrayValue.Add(elementValue);
        except
          elementValue.Free;
          raise;
        end;
      end;
    end
    else
      FFirstIndex := ReadWord(AStream);
  end;
end;

end.
