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
  CustApp,
  jclass_common_types,
  jclass_common_abstract,
  jclass_interface_list;

type

  { TJClassParser }

  TJClassParser = class(TCustomApplication)
  protected
    procedure DoRun; override;
    procedure ProcessFile(AFile: TFileName);
    procedure PrintJClassInfo(AJClass: TJClassFile);
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
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      AJClass.BuildDebugInfo('', sl);
      for i := 0 to sl.Count - 1 do
        WriteLn(sl[i]);
    finally
      sl.Free;
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
