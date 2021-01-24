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
    procedure BuildDebugInfo(AIndent: string; AOutput: TStrings); override;
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
    ATarget[i].Tag := ReadByte(AStream);
    if ATarget[i].Tag in [7, 8] then
      ATarget[i].CPoolIndex := ReadWord(AStream);
  end;
end;

procedure TJClassStackMapFrame.BuildDebugInfo(AIndent: string; AOutput: TStrings
  );
begin
  AOutput.Add('not supported (TJClassStackMapFrame)');
end;

procedure TJClassStackMapFrame.LoadFromStream(AStream: TStream);
begin
  FFrameType := ReadByte(AStream);
  case TJStackFrameType(FFrameType) of
    sftLocals1First..sftLocals1Last: LoadVerificetionTypeInfoArray(AStream, FStack, 1);
    sftLocals1Ext:
    begin
      FOffsetDelta := ReadWord(AStream);
      LoadVerificetionTypeInfoArray(AStream, FStack, 1);
    end;
    sftChopFirst..sftChopLast, sftFrameExt: FOffsetDelta := ReadWord(AStream);
    sftAppendFirst..sftAppendLast:
    begin
      FOffsetDelta := ReadWord(AStream);
      LoadVerificetionTypeInfoArray(AStream, FLocals, 1);
    end;
    sftFull:
    begin
      FOffsetDelta := ReadWord(AStream);
      LoadVerificetionTypeInfoArray(AStream, FLocals, ReadWord(AStream));
      LoadVerificetionTypeInfoArray(AStream, FStack, ReadWord(AStream));
    end;
  end;
end;

end.
