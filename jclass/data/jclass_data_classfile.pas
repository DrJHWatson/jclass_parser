unit jclass_data_classfile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, jclass_common_types;

type
  TJClassFileData = record
    Magic: UInt32;
    MinorVersion: UInt16;
    MajorVersion: UInt16;
    ConstantPool: TList;
    AccessFlags: UInt16;
    ThisClass: TConstIndex;
    SuperClass: TConstIndex;
    Interfaces: array of TConstIndex;
    Fields: TList;
    Methods: TList;
    Attributes: TList;
  end;

implementation

end.

