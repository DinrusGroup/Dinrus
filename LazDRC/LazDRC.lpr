program LazDRC;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { TLazDRC }

  TLazDRC = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TLazDRC }

procedure TLazDRC.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }

  // stop program loop
  Terminate;
end;

constructor TLazDRC.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TLazDRC.Destroy;
begin
  inherited Destroy;
end;

procedure TLazDRC.WriteHelp;
begin
  { add your help code here }
  writeln('Использование: ', ExeName, ' -h');
end;

var
  Application: TLazDRC;
begin
  Application:=TLazDRC.Create(nil);
  Application.Title:='TLazDRC ';
  Application.Run;
  Application.WriteHelp;
  Application.Free;
end.

