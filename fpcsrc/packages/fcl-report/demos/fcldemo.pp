program fcldemo;

uses
  udapp, regreports, fpreportbarcode;

Var
  Application : TReportDemoApplication;

begin
  Application:=TReportDemoApplication.Create(Nil);
  Application.Initialize;
  Application.Run;
  Application.Free;
end.
