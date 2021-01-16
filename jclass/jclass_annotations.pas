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
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

implementation

uses
  jclass_enum;

{ TJClassTypeAnnotation }

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
  buf: UInt16;
  i: integer;
begin
  ReadElement(AStream, @FTargetType, etByte);
  case FTargetType of
    0, 1: ReadElement(AStream, @FTypeParameterTarget, etByte);
    $10: ReadElement(AStream, @FSupertypeTarget, etWord);
    $11, $12:
    begin
      ReadElement(AStream, @FTypeParameterBoundTarget.TypeParameterIndex, etByte);
      ReadElement(AStream, @FTypeParameterBoundTarget.BoundIndex, etByte);
    end;
    $16: ReadElement(AStream, @FMethodFormalParameterTarget, etByte);
    $17: ReadElement(AStream, @FThrowsTarget, etWord);
    $40, $41:
    begin
      ReadElement(AStream, @buf, etWord);
      for i := 0 to buf - 1 do
      begin
        ReadElement(AStream, @FLocalvarTarget[i].StartPC, etWord);
        ReadElement(AStream, @FLocalvarTarget[i].Length, etWord);
        ReadElement(AStream, @FLocalvarTarget[i].Index, etWord);
      end;
    end;
    $42: ReadElement(AStream, @FCatchTarget, etWord);
    $43, $44, $45, $46: ReadElement(AStream, @FOffsetTarget, etWord);
    $47, $48, $49, $4A, $4B:
    begin
      ReadElement(AStream, @FTypeArgumentTarget.Offset, etWord);
      ReadElement(AStream, @FTypeArgumentTarget.TypeArguementIndex, etByte);
    end;
  end;
end;

{ TJClassAnnotation }

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
  buf: UInt16;
  i: integer;
begin
  ReadElement(AStream, @FTypeIndex, etWord);
  ReadElement(AStream, @buf, etWord);
  SetLength(FElementValuePairs, buf);
  for i := 0 to buf - 1 do
  begin
    ReadElement(AStream, @FElementValuePairs[i].ElementNameIndex, etWord);
    FElementValuePairs[i].ElementValue := TJClassElementValue.Create;
    FElementValuePairs[i].ElementValue.LoadFromStream(AStream);
  end;
end;

{ TJClassElementValue }

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
  ReadElement(AStream, @FTag, etByte);
  case char(FTag) of
    'e':
    begin
      ReadElement(AStream, @FFirstIndex, etWord);
      ReadElement(AStream, @FSecondIndex, etWord);
    end;
    '@':
    begin
      FAnnotation := TJClassAnnotation.Create;
      FAnnotation.LoadFromStream(AStream);
    end;
    '[':
    begin
      ReadElement(AStream, @buf, etWord);
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
      ReadElement(AStream, @FFirstIndex, etWord);
  end;
end;

end.
