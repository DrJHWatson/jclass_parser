unit jclass_common_abstract;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  jclass_common_types,
  jclass_constants,
  jclass_common;

type
  TJClassFileAbstract = class(TJClassLoadable)
  public
    function FindConstant(AIndex: TConstIndex): TJClassConstant; virtual; abstract;
    function FindConstantSafe(AIndex: TConstIndex; AClass: TJClassConstantClass): TJClassConstant;
      virtual; abstract;
    function FindUtf8Constant(AIndex: TConstIndex): string; virtual; abstract;
  end;

implementation

end.
