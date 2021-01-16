unit jclass_methods;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_items,
  jclass_enum;

type
  { TJClassMethod }

  TJClassMethod = class(TJClassItem)
  public
    procedure LoadFromStream(AStream: TStream); override;
  end;

implementation

{ TJClassMethod }

procedure TJClassMethod.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
begin
  ReadElement(AStream, @FAccessFlags, etWord);
  ReadElement(AStream, @FNameIndex, etWord);
  ReadElement(AStream, @FDescriptorIndex, etWord);
  ReadElement(AStream, @buf, etWord);
  LoadItemAttributes(AStream, buf, alMethodInfo);
end;

end.
