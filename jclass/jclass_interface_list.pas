unit jclass_interface_list;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_constants,
  jclass_common_abstract,
  jclass_common,
  jclass_common_types;

type

  { TJClassInterfaces }

  TJClassInterfaces = class(TJClassLoadable)
  private
    FClassFile: TJClassFileAbstract;
    FInterfacesData: TConstIndexArray;
    function GetItems(AIndex: UInt16): TJClassClassConstant;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    procedure LoadFromStream(AStream: TStream); override;
    property Items[AIndex: UInt16]: TJClassClassConstant read GetItems; default;
    function Count: UInt16;
    constructor Create(AClassFile: TJClassFileAbstract);
  end;

implementation

{ TJClassInterfaces }

function TJClassInterfaces.GetItems(AIndex: UInt16): TJClassClassConstant;
begin
  Result := FClassFile.FindConstantSafe(FInterfacesData[AIndex], TJClassClassConstant) as
    TJClassClassConstant;
end;

procedure TJClassInterfaces.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, Length(FInterfacesData)]);
  for i := 0 to High(FInterfacesData) do
    AOutput.Add('%s  %s', [AIndent, FClassFile.FindUtf8Constant(Items[i].NameIndex)]);
end;

procedure TJClassInterfaces.LoadFromStream(AStream: TStream);
var
  i: integer;
begin
  SetLength(FInterfacesData, ReadWord(AStream));
  for i := 0 to High(FInterfacesData) do
    FInterfacesData[i] := ReadWord(AStream);
end;

function TJClassInterfaces.Count: UInt16;
begin
  Result := Length(FInterfacesData);
end;

constructor TJClassInterfaces.Create(AClassFile: TJClassFileAbstract);
begin
  FClassFile := AClassFile;
end;

end.
