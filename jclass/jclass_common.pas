unit jclass_common;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_enum;

type

  { TJClassLoadable }

  TJClassLoadable = class(TObject)
  protected
    procedure ReadElement(ASource: TStream; ATarget: Pointer; AType: TJElementType);
  public
    procedure LoadFromStream(AStream: TStream); virtual; abstract;
  end;

  { TJClassConstant }

  TJClassConstant = class(TJClassLoadable)
  protected
    function GetDescription: string; virtual;
  public
    property Description: string read GetDescription;
  end;

  TJClassConstantClass = class of TJClassConstant;

implementation

{ TJClassConstant }

function TJClassConstant.GetDescription: string;
begin
  Result := ClassName;
end;

{ TJClassLoadable }

procedure TJClassLoadable.ReadElement(ASource: TStream; ATarget: Pointer; AType: TJElementType);
var
  buffer: array[0..3] of byte;
  target: PByte;
begin
  target := PByte(ATarget);
  ASource.Read(buffer[0], Ord(AType));
  case AType of
    etByte: target[0] := buffer[0];
    etWord:
    begin
      target[0] := buffer[1];
      target[1] := buffer[0];
    end;
    etDWord:
    begin
      target[0] := buffer[3];
      target[1] := buffer[2];
      target[2] := buffer[1];
      target[3] := buffer[0];
    end;
  end;
end;

end.
