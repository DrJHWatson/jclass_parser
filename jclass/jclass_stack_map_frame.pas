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
  case TJStackFrameType(FFrameType) of
    sftLocals1First..sftLocals1Last: LoadVerificetionTypeInfoArray(AStream, FStack, 1);
    sftLocals1Ext:
    begin
      ReadElement(AStream, @FOffsetDelta, etWord);
      LoadVerificetionTypeInfoArray(AStream, FStack, 1);
    end;
    sftChopFirst..sftChopLast, sftFrameExt: ReadElement(AStream, @FOffsetDelta, etWord);
    sftAppendFirst..sftAppendLast:
    begin
      ReadElement(AStream, @FOffsetDelta, etWord);
      LoadVerificetionTypeInfoArray(AStream, FLocals, 1);
    end;
    sftFull:
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
