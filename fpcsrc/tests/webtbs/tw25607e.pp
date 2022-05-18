program E05;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}
{$APPTYPE CONSOLE}

type
  T0 = class
    procedure Foo;
  end;

  TA = class(T0)
    procedure Foo(A: Integer = 0); overload; virtual;
  end;

  TB = class(TA)
    procedure Foo(A: Integer); overload; override;
  end;

  TClassB = class of TB;

var
  t0called,
  tacalled,
  tbcalled: boolean;

procedure T0.Foo();
begin
  WriteLn('T0.Foo');
  t0called:=true;
end;

procedure TA.Foo(A: Integer = 0);
begin
  WriteLn('TA.Foo');
  tacalled:=true;
end;

procedure TB.Foo(A: Integer);
begin
  WriteLn('TB.Foo');
  tbcalled:=true;
end;

var
  B: TB;
  ClassB: TClassB;
begin
  B := TB.Create;
  B.Foo; // call TB.Foo because of VMT rules
  B.Free;
  if t0called then
    halt(1);
  if tacalled then
    halt(2);
  if not tbcalled then
    halt(3);
end.