unit jclass_items;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common,
  jclass_attributes,
  jclass_enum,
  jclass_constants,
  jclass_common_abstract;

type

  { TJClassItem }

  TJClassItem = class(TJClassLoadable)
  protected
    FAccessFlags: UInt16;
    FNameIndex: UInt16;
    FDescriptorIndex: UInt16;
    FAttributes: TJClassAttributes;
    FClassFile: TJClassFileAbstract;
  public
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
    property AccessFlags: UInt16 read FAccessFlags;
    property NameIndex: UInt16 read FNameIndex;
    property DescriptorIndex: UInt16 read FDescriptorIndex;
    property Attributes: TJClassAttributes read FAttributes;
    constructor Create(AClassFile: TJClassFileAbstract);
    destructor Destroy; override;
  end;

implementation

{ TJClassItem }

procedure TJClassItem.BuildDebugInfo(AIndent: string; AOutput: TStrings);
begin
  AOutput.Add('%sName: %s', [AIndent, FClassFile.FindUtf8Constant(FNameIndex)]);
  AOutput.Add('%sFlags: %.8x', [AIndent, FAccessFlags]);
  AOutput.Add('%sDescriptor %s', [AIndent, FClassFile.FindUtf8Constant(FDescriptorIndex)]);
  AOutput.Add('%sAttributes', [AIndent]);
  FAttributes.BuildDebugInfo(AIndent + '  ', AOutput);
end;

constructor TJClassItem.Create(AClassFile: TJClassFileAbstract);
begin
  FClassFile := AClassFile;
  FAttributes := TJClassAttributes.Create(AClassFile);
end;

destructor TJClassItem.Destroy;
begin
  FAttributes.Free;
  inherited Destroy;
end;

end.
