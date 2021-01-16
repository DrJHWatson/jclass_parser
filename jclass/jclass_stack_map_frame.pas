unit jclass_stack_map_frame;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common,
  jclass_types;

type

  { TJClassStackMapFrame }

  TJClassStackMapFrame = class(TJClassLoadable)
  private
    FFrameType: UInt8;
    FOffsetDelta: UInt16;
    FStack: TVerificationTypeInfoArray;
    FLocals: TVerificationTypeInfoArray;
    procedure LoadVerificetionTypeInfoArray(AStream: TStream;
      var ATarget: TVerificationTypeInfoArray; ALength: integer);
  public
    procedure LoadFromStream(AStream: TStream); override;
  end;

implementation

uses
  jclass_enum;

{ TJClassStackMapFrame }

procedure TJClassStackMapFrame.LoadVerificetionTypeInfoArray(AStream: TStream;
  var ATarget: TVerificationTypeInfoArray; ALength: integer);
var
  i: integer;
begin
  SetLength(ATarget, ALength);
  for i := 0 to ALength - 1 do
  begin
    ReadElement(AStream, @ATarget[i].Tag, etByte);
    if ATarget[i].Tag in [7, 8] then
      ReadElement(AStream, @ATarget[i].CPoolIndex, etWord);
  end;
end;

procedure TJClassStackMapFrame.LoadFromStream(AStream: TStream);
var
  buf: UInt16;
begin
  ReadElement(AStream, @FFrameType, etByte);
  case FFrameType of
    64..127: LoadVerificetionTypeInfoArray(AStream, FStack, 1);
    247:
    begin
      ReadElement(AStream, @FOffsetDelta, etWord);
      LoadVerificetionTypeInfoArray(AStream, FStack, 1);
    end;
    248..250, 251: ReadElement(AStream, @FOffsetDelta, etWord);
    252..254:
    begin
      ReadElement(AStream, @FOffsetDelta, etWord);
      LoadVerificetionTypeInfoArray(AStream, FLocals, 1);
    end;
    255:
    begin
      ReadElement(AStream, @FOffsetDelta, etWord);
      ReadElement(AStream, @buf, etWord);
      LoadVerificetionTypeInfoArray(AStream, FLocals, buf);
      ReadElement(AStream, @buf, etWord);
      LoadVerificetionTypeInfoArray(AStream, FStack, buf);
    end;
  end;
end;

end.
