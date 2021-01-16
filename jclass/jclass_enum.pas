unit jclass_enum;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

type
  TJElementType = (
    etByte = 1,
    etWord = 2,
    etDWord = 4
    );

  TJConstantType = (
    ctUtf8 = 1,
    ctInteger = 3,
    ctFloat = 4,
    ctLong = 5,
    ctDouble = 6,
    ctClass = 7,
    ctString = 8,
    ctFieldref = 9,
    ctMethodref = 10,
    ctInterfaceMethodref = 11,
    ctNameAndType = 12,
    ctMethodHandle = 15,
    ctMethodType = 16,
    ctInvokeDynamic = 18
    );

  TJAttributeLocation = (
    alClassFile,
    alFieldInfo,
    alMethodInfo,
    alCode
    );

  TJAccessFlag = (
    afPublic = $0001,
    afFinal = $0010,
    afSuper = $0020,
    afInterface = $0200,
    afAbstract = $0400,
    afSynthetic = $1000,
    afAnnotation = $2000,
    afEnum = $4000
    );

function AccessFlagsToString(AAccessFlags: UInt16): string;

implementation

const
  TJAccessFlagNames: array[0..7] of string = (
    'Public',
    'Final',
    'Super',
    'Interface',
    'Abstract',
    'Synthetic',
    'Annotation',
    'Enum'
    );
  TJAccessFlagValues: array[0..7] of TJAccessFlag = (
    afPublic,
    afFinal,
    afSuper,
    afInterface,
    afAbstract,
    afSynthetic,
    afAnnotation,
    afEnum
    );

function AccessFlagsToString(AAccessFlags: UInt16): string;
var
  i: Integer;
begin
  for i:=0 to 7 do
    if Ord(TJAccessFlagValues[i]) and AAccessFlags > 0 then
      Result := Result + ' ' + TJAccessFlagNames[i];
  Result := trim(Result);
end;

end.
