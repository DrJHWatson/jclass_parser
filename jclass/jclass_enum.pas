unit jclass_enum;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

type
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
    ctDynamic = 17,
    ctInvokeDynamic = 18,
    ctModule = 19,
    ctPackage = 20
    );

  TJAttributeLocation = (
    alClassFile,
    alFieldInfo,
    alMethodInfo,
    alCode
    );

  TJStackFrameType = (
    sftSameFirst = 0,
    sftSameLast = 63,
    sftLocals1First = 64,
    sftLocals1Last = 127,
    sftLocals1Ext = 247,
    sftChopFirst = 248,
    sftChopLast = 250,
    sftFrameExt = 251,
    sftAppendFirst = 252,
    sftAppendLast = 254,
    sftFull = 255
    );

  TJClassAccessFlag = (
    cafPublic = $0001,
    cafPrivate = $0002,
    cafProtected = $0004,
    cafStatic = $0008,
    cafFinal = $0010,
    cafSuper = $0020,
    cafInterface = $0200,
    cafAbstract = $0400,
    cafSynthetic = $1000,
    cafAnnotation = $2000,
    cafEnum = $4000,
    cafModule = $8000
    );

  TJClassFieldAccessFlag = (
    fafPublic = $0001,
    fafPrivate = $0002,
    fafProtected = $0004,
    fafStatic = $0008,
    fafFinal = $0010,
    fafVolatile = $0040,
    fafTransient = $0080,
    fafSynthetic = $1000,
    fafEnum = $4000
    );

  TJClassMethodAccessFlag = (
    mafPublic = $0001,
    mafPrivate = $0002,
    mafProtected = $0004,
    mafStatic = $0008,
    mafFinal = $0010,
    mafSynchronized = $0020,
    mafBridge = $0040,
    mafVarArgs = $0080,
    mafNative = $0100,
    mafAbstract = $0400,
    mafStrict = $0800,
    mafSynthetic = $1000
    );

function ClassAccessFlagsToString(AAccessFlags: UInt16): string;

implementation

const
  TJClassAccessFlagNames: array of string = (
    'Public',
    'Private',
    'Protected',
    'Static',
    'Final',
    'Super',
    'Interface',
    'Abstract',
    'Synthetic',
    'Annotation',
    'Enum',
    'Module'
    );
  TJClassAccessFlagValues: array of TJClassAccessFlag = (
    cafPublic,
    cafPrivate,
    cafProtected,
    cafStatic,
    cafFinal,
    cafSuper,
    cafInterface,
    cafAbstract,
    cafSynthetic,
    cafAnnotation,
    cafEnum,
    cafModule
    );

function ClassAccessFlagsToString(AAccessFlags: UInt16): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High(TJClassAccessFlagValues) do
    if Ord(TJClassAccessFlagValues[i]) and AAccessFlags > 0 then
      Result := Result + ' ' + TJClassAccessFlagNames[i];
  Result := trim(Result);
end;

end.
