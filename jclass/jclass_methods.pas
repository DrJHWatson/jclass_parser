unit jclass_methods;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_items,
  jclass_enum,
  fgl,
  jclass_common_abstract;

type
  { TJClassMethod }

  TJClassMethod = class(TJClassItem)
  public
    procedure LoadFromStream(AStream: TStream); override;
  end;

  { TJClassMethods }

  TJClassMethods = class(specialize TFPGObjectList<TJClassMethod>)
  private
    FClassFile: TJClassFileAbstract;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings);
    procedure LoadFromStream(AStream: TStream);
    constructor Create(AClassFile: TJClassFileAbstract);
  end;

implementation

{ TJClassMethods }

procedure TJClassMethods.BuildDebugInfo(AIndent: string; AOutput: TStrings);
var
  i: Integer;
begin
  AOutput.Add('%sCount: %d', [AIndent, Count]);
  for i := 0 to Count - 1 do
  begin
    AOutput.Add('%s  %s', [AIndent, FClassFile.FindUtf8Constant(Items[i].NameIndex)]);
    Items[i].BuildDebugInfo(AIndent + '    ', AOutput);
  end;
end;

procedure TJClassMethods.LoadFromStream(AStream: TStream);
var
  item: TJClassMethod;
  itemsCount: UInt16;
  i: integer;
begin
  itemsCount := FClassFile.ReadWord(AStream);
  for i := 0 to itemsCount - 1 do
  begin
    item := TJClassMethod.Create(FClassFile);
    try
      item.LoadFromStream(AStream);
      Add(item);
    except
      item.Free;
      raise;
    end;
  end;
end;

constructor TJClassMethods.Create(AClassFile: TJClassFileAbstract);
begin
  inherited Create();
  FClassFile := AClassFile;
end;

{ TJClassMethod }

procedure TJClassMethod.LoadFromStream(AStream: TStream);
begin
  FAccessFlags := ReadWord(AStream);
  FNameIndex := ReadWord(AStream);
  FDescriptorIndex := ReadWord(AStream);
  FAttributes.LoadFromStream(AStream, alMethodInfo);
end;

end.
