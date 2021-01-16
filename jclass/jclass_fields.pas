unit jclass_fields;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_items,
  jclass_enum;

type
  { TJClassField }

  TJClassField = class(TJClassItem)
  public
    procedure LoadFromStream(AStream: TStream); override;
  end;

implementation

{ TJClassField }

procedure TJClassField.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
begin
  ReadElement(AStream, @FAccessFlags, etWord);
  ReadElement(AStream, @FNameIndex, etWord);
  ReadElement(AStream, @FDescriptorIndex, etWord);
  ReadElement(AStream, @buf, etWord);
  LoadItemAttributes(AStream, buf, alFieldInfo);
end;

end.
