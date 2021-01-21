unit jclass_data_classfile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, jclass_common_types;

type
  TJClassFileData = record
    FMagic: UInt32;
    FMinorVersion: UInt16;
    FMajorVersion: UInt16;
    FConstantPool: TList;
    FAccessFlags: UInt16;
    FThisClass: TConstIndex;
    FSuperClass: TConstIndex;
    FInterfaces: array of TConstIndex;
    FFields: TList;
    FMethods: TList;
    FAttributes: TList;
  end;

implementation

end.

