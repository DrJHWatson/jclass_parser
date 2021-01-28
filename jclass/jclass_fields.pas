unit jclass_fields;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_items,
  jclass_enum,
  jclass_common_abstract,
  fgl;

type
  { TJClassField }

  TJClassField = class(TJClassItem)
  public
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassFields }

  TJClassFields = class(specialize TFPGObjectList<TJClassField>)
  private
    FClassFile: TJClassFileAbstract;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings);
    procedure LoadFromStream(AStream: TStream);
    constructor Create(AClassFile: TJClassFileAbstract);
  end;

implementation

{ TJClassFields }

procedure TJClassFields.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, Count]);
  for i := 0 to Count - 1 do
  begin
    AOutput.Add('%s  %s', [AIndent, FClassFile.FindUtf8Constant(Items[i].NameIndex)]);
    Items[i].BuildDebugInfo(AIndent + '    ', AOutput);
  end;
end;

procedure TJClassFields.LoadFromStream(AStream: TStream);
var
  item: TJClassField;
  itemsCount: UInt16;
  i: integer;
begin
  itemsCount := FClassFile.ReadWord(AStream);
  for i := 0 to itemsCount - 1 do
  begin
    item := TJClassField.Create(FClassFile);
    try
      item.LoadFromStream(AStream);
      Add(item);
    except
      item.Free;
      raise;
    end;
  end;
end;

constructor TJClassFields.Create(AClassFile: TJClassFileAbstract);
begin
  inherited Create();
  FClassFile := AClassFile;
end;

{ TJClassField }

procedure TJClassField.LoadFromStream(AStream: TStream);
begin
  FAccessFlags := ReadWord(AStream);
  FNameIndex := ReadWord(AStream);
  FDescriptorIndex := ReadWord(AStream);
  FAttributes.LoadFromStream(AStream, alFieldInfo);
end;

end.
