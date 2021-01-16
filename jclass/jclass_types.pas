unit jclass_types;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common;

type
  TLocalVariableTableRecord = record
    StartPC: UInt16;
    Length: UInt16;
    NameIndex: UInt16;
    DescriptorIndex: UInt16;
    Index: UInt16;
  end;

  TJClassCodeException = record
    StartPC: UInt16;
    EndPC: UInt16;
    HandlerPC: UInt16;
    CatchType: UInt16;
  end;

  TJClassInnerClass = record
    InnerClassInfoIndex: UInt16;
    OuterClassInfoIndex: UInt16;
    InnerNameIndex: UInt16;
    InnerClassAccessFlags: UInt16;
  end;

  TJClassTypePath = record
    TypePathKind: UInt8;
    TypeArgumentIndex: UInt8;
  end;

  TJClassTypeParameterTarget = UInt8;
  TJClassSupertypeTarget = UInt16;

  TJClassTypeParameterBoundTarget = record
    TypeParameterIndex: UInt8;
    BoundIndex: UInt8;
  end;

  TJClassMethodFormalParameterTarget = UInt8;

  TJClassThrowsTarget = UInt16;

  TJClassLocalVar = record
    StartPC: UInt16;
    Length: UInt16;
    Index: UInt16;
  end;

  TJClassLocalvarTarget = array of TJClassLocalVar;
  TJClassCatchTarget = UInt16;
  TJClassOffsetTarget = UInt16;

  TJClassTypeArgumentTarget = record
    Offset: UInt16;
    TypeArguementIndex: UInt8;
  end;

  TJClassBootstrapMethods = record
    BootstrapMethodRef: UInt16;
    BootstrapArguments: array of UInt16;
  end;

  TJClassMethodParameter = record
    NameIndex: UInt16;
    AccessFlags: UInt16;
  end;

  TJClassLineNumberEntry = record
    StartPC: UInt16;
    LineNumber: UInt16;
  end;

  TVerificationTypeInfo = record
    Tag: UInt8;
    case boolean of
      True: (
        CPoolIndex: UInt16;
      );
      False: (
        Offset: UInt16;
      );
  end;

  TVerificationTypeInfoArray = array of TVerificationTypeInfo;

  TJClassConstantSearch = function(AIndex: integer;
    AConstantClass: TJClassConstantClass): TJClassConstant of object;

implementation

end.
