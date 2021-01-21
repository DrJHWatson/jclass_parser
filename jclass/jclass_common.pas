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
    function ReadByte(ASource: TStream): UInt8;
    function ReadWord(ASource: TStream): UInt16;
    function ReadDWord(ASource: TStream): UInt32;
  public
    procedure LoadFromStream(AStream: TStream); virtual; abstract;
  end;

implementation

{ TJClassLoadable }

function TJClassLoadable.ReadByte(ASource: TStream): UInt8;
begin
  Result := ASource.ReadByte;
end;

function TJClassLoadable.ReadWord(ASource: TStream): UInt16;
var
  buf: UInt16;
  bufArray: array[0..1] of UInt8 absolute buf;
  resultArray: array[0..1] of UInt8 absolute Result;
begin
  buf := ASource.ReadWord;
  resultArray[0] := bufArray[1];
  resultArray[1] := bufArray[0];
end;

function TJClassLoadable.ReadDWord(ASource: TStream): UInt32;
var
  buf: UInt32;
  bufArray: array[0..3] of UInt8 absolute buf;
  resultArray: array[0..3] of UInt8 absolute Result;
begin
  buf := ASource.ReadDWord;
  resultArray[0] := bufArray[3];
  resultArray[1] := bufArray[2];
  resultArray[2] := bufArray[1];
  resultArray[3] := bufArray[0];
end;

end.
