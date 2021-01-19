program jcparser;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  jclass_types,
  jclass_stack_map_frame,
  jclass_methods,
  jclass_items,
  jclass_file,
  jclass_fields,
  jclass_enum,
  jclass_common,
  jclass_attributes_abstract,
  jclass_attributes,
  jclass_annotations,
  jclass_constants,
  jclass_attributes_implementation,
  CustApp;

type

  { TJClassParser }

  TJClassParser = class(TCustomApplication)
  protected
    procedure DoRun; override;
    procedure ProcessFile(AFile: TFileName);
    procedure PrintJClassInfo(AJClass: TJClassFile);
    procedure PrintMethod(AJClass: TJClassFile; AMethod: TJClassMethod);
  public
    constructor Create(TheOwner: TComponent); override;
    procedure WriteHelp; virtual;
  end;

  { TJClassParser }

  procedure TJClassParser.DoRun;
  var
    ErrorMsg: string;
  begin
    // quick check parameters
    ErrorMsg := CheckOptions('hc', 'help class');
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Terminate;
      Exit;
    end;

    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;

    if HasOption('c', 'class') then
    begin
      ProcessFile(GetOptionValue('c', 'class'));
      Terminate;
      Exit;
    end;

    // stop program loop
    Terminate;
  end;

  procedure TJClassParser.ProcessFile(AFile: TFileName);
  var
    jclass: TJClassFile;
    fs: TFileStream;
  begin
    if not FileExists(AFile) then
      raise Exception.CreateFmt('File "%s" not found', [AFile]);
    jclass := TJClassFile.Create;
    try
      fs := TFileStream.Create(AFile, fmOpenRead);
      try
        jclass.LoadFromStream(fs);
      finally
        fs.Free;
      end;
      PrintJClassInfo(jclass);
    finally
      jclass.Free;
    end;
  end;

  procedure TJClassParser.PrintJClassInfo(AJClass: TJClassFile);
  var
    i: integer;
  begin
    with AJClass do
    begin
      WriteLn(Format('version: %d,%d', [MajorVersion, MinorVersion]));
      WriteLn(Format('access flags: %s', [AccessFlags]));
      WriteLn(Format('this class: %s', [GetStringConstant(ThisClass.NameIndex)]));
      WriteLn(Format('super class: %s', [GetStringConstant(SuperClass.NameIndex)]));
      WriteLn(Format('interfaces count: %d', [InterfacesCount]));
      for i := 0 to InterfacesCount - 1 do
        WriteLn(Format('  %s', [GetStringConstant(Interfaces[i].NameIndex)]));
      WriteLn(Format('fields count: %d', [FieldsCount]));
      for i := 0 to FieldsCount - 1 do
        WriteLn(Format('  %s', [GetStringConstant(Fields[i].NameIndex)]));
      WriteLn(Format('methods count: %d', [MethodsCount]));
      for i := 0 to MethodsCount - 1 do
        PrintMethod(AJClass, AJClass.Methods[i]);

      WriteLn(Format('attributes count: %d', [AttributesCount]));
      for i := 0 to AttributesCount - 1 do
      begin
        WriteLn(Format('  %s', [Attributes[i].GetName]));
        WriteLn(Format('    %s', [Attributes[i].AsString]));
      end;
      WriteLn(Format('constant slots count: %d', [ConstantsCount]));
      for i := 0 to ConstantsCount - 1 do
        WriteLn(Format('  %.4d %s', [i + 1, ConstantPool[i].Description]));
    end;
  end;

  procedure TJClassParser.PrintMethod(AJClass: TJClassFile; AMethod: TJClassMethod);
  var
    i: integer;
  begin
    WriteLn(Format('  %s', [AJClass.GetStringConstant(AMethod.NameIndex)]));
    for i := 0 to AMethod.AttributesCount - 1 do
    begin
      WriteLn(Format('    %s', [AMethod.Attributes[i].GetName]));
      WriteLn(AMethod.Attributes[i].AsString);
    end;
  end;

  constructor TJClassParser.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  procedure TJClassParser.WriteHelp;
  begin
    writeln('Usage: ', ExeName, ' -h');
    writeln('Usage: ', ExeName, ' -c AnyClassFileName.class');
  end;

var
  Application: TJClassParser;
begin
  Application := TJClassParser.Create(nil);
  Application.Title := 'JClassParser';
  Application.Run;
  Application.Free;
end.
