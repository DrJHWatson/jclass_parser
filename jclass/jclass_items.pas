unit jclass_items;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common,
  jclass_types,
  jclass_attributes,
  jclass_enum,
  jclass_constants;

type

  { TJClassItem }

  TJClassItem = class(TJClassLoadable)
  private
    function GetAttributesCount: integer;
  protected
    FAccessFlags: UInt16;
    FNameIndex: UInt16;
    FDescriptorIndex: UInt16;
    FAttributes: TList;
    FConstantSearch: TJClassConstantSearch;
    function GetAttributes(AIndex: UInt16): TJClassAttribute;
    procedure LoadItemAttributes(ASource: TStream; ACount: UInt16; ALocation: TJAttributeLocation);
  public
    property AccessFlags: UInt16 read FAccessFlags;
    property NameIndex: UInt16 read FNameIndex;
    property DescriptorIndex: UInt16 read FDescriptorIndex;
    property AttributesCount: integer read GetAttributesCount;
    property Attributes[AIndex: UInt16]: TJClassAttribute read GetAttributes;
    constructor Create(AConstantSearch: TJClassConstantSearch);
  end;

implementation

{ TJClassItem }

procedure TJClassItem.LoadItemAttributes(ASource: TStream; ACount: UInt16;
  ALocation: TJAttributeLocation);
var
  attribute: TJClassAttribute;
  attrNameIndex: UInt16;
  attributeName: string;
  i: integer;
begin
  for i := 0 to ACount - 1 do
  begin
    ReadElement(ASource, @attrNameIndex, etWord);
    attributeName := TJClassUtf8Constant(FConstantSearch(attrNameIndex,
      TJClassUtf8Constant)).AsString;
    attribute := FindAttributeClass(attributeName, ALocation).Create(FConstantSearch);
    try
      attribute.LoadFromStream(ASource);
      FAttributes.Add(attribute);
    except
      attribute.Free;
      raise;
    end;
  end;
end;

function TJClassItem.GetAttributesCount: integer;
begin
  Result := FAttributes.Count;
end;

function TJClassItem.GetAttributes(AIndex: UInt16): TJClassAttribute;
begin
  Result := TJClassAttribute(FAttributes[AIndex]);
end;

constructor TJClassItem.Create(AConstantSearch: TJClassConstantSearch);
begin
  FConstantSearch := AConstantSearch;
  FAttributes := TList.Create;
end;

end.
