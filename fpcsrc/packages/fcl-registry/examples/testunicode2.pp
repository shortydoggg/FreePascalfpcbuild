program testunicode2;

{ Unicode test program, using unicode strings }

{$mode objfpc}{$H+}
{$codepage utf8}
{$IFNDEF UNIX}
{$APPTYPE CONSOLE}
{$ENDIF}
uses
{$ifdef unix}
  cwstring,
{$endif}
  sysutils, classes, registry;

Var
  EditKey : Unicodestring = 'ASCII;这是一个测试';
  labeledEditName : Unicodestring = 'ASCII;പേര് ഇതാണ്ASCII;这是一个测试';
  labeledEditValue : Unicodestring = 'これは値です;ASCII';
  labelkeycaption : UnicodeString = 'HKCU\Software\zzz_test\';
  reg: TRegistry;
  Results : TStrings;



function TestKey (const AKey: UnicodeString): boolean;
begin
  Result:=false;
  try
    reg.CloseKey;
    if reg.KeyExists(AKey) then
      reg.DeleteKey(AKey);
    if reg.KeyExists(AKey) then
    begin
      Results.Add('TestKey-01 failed: DeleteKey(%s);',[AKey]);
      exit;
    end;
    if not reg.OpenKey(AKey,true) then
    begin
      Results.Add('TestKey-02 failed: OpenKey(%s,true)',[AKey]);
      exit;
    end;
    reg.CloseKey;
    if not reg.KeyExists(AKey) then
    begin
      Results.Add('TestKey-03 failed: OpenKey(%s,true)',[AKey]);
      exit;
    end;
    reg.DeleteKey(AKey);
    if not reg.CreateKey(AKey) then
    begin
      Results.Add('TestKey-04 failed: CreateKey(%s)',[AKey]);
      exit;
    end;
    if not reg.KeyExists(AKey) then
    begin
      Results.Add('TestKey-05 failed: CreateKey(%s,true)',[AKey]);
      exit;
    end;
    if not reg.OpenKeyReadOnly(AKey) then
    begin
      Results.Add('TestKey-06 failed: OpenKeyReadOnly(%s)',[AKey]);
      exit;
    end;
    reg.CloseKey;
    if not reg.OpenKey(AKey,false) then
    begin
      Results.Add('TestKey-07 failed: OpenKey(%s,false)',[AKey]);
      exit;
    end;

    Results.Add('TestKey           passed: %s',[AKey]);

  except
    on e:Exception do
      Results.Add('TestKey-08 failed: %s; %s;',[AKey,e.Message]);
  end;

  Result:=true;

end;

procedure TestValue (const AName, AValue: Unicodestring);
var
  wrong,s: unicodestring;
begin
  try
    wrong:=AName+'_wrong';
    if reg.ValueExists(wrong) then
      reg.DeleteValue(wrong);
    if reg.ValueExists(wrong) then
    begin
      Results.Add('TestValue-01 failed: DeleteValue(%s)',[wrong]);
      exit;
    end;
    reg.WriteString(wrong,AValue);
    s:=reg.ReadString(wrong);
    if s<>AValue then
    begin
      Results.Add('TestValue-02 failed: WriteString(%s,%s)',[wrong,AValue]);
      exit;
    end;

    if reg.ValueExists(AName) then
      reg.DeleteValue(AName);
    if reg.ValueExists(AName) then
    begin
      Results.Add('TestValue-03 failed: DeleteValue(%s)',[AName]);
      exit;
    end;

    reg.RenameValue(wrong,AName);
    s:=reg.ReadString(AName);
    if s<>AValue then
    begin
      Results.Add('TestValue-04 failed: RenameValue(%s,%s)',[wrong,AName]);
      exit;
    end;

    Results.Add('TestValue         passed: %s; %s;',[AName,AValue]);

  except
    on e:Exception do
      Results.Add('TestValue-08 failed: %s; %s; %s;',[AName,AValue,e.Message]);
  end;
end;

procedure TestGetKeyNames (const AKey, AExpected: Unicodestring);
var
  sl: TStringList;
begin
  sl:=TStringList.Create;
  sl.Delimiter:=';';
  reg.CloseKey;
  try
    if not reg.OpenKeyReadOnly(AKey) then
    begin
      Results.Add('TestGetKeyNames-01 failed: Key "%s";',[AKey]);
      exit;
    end;
    reg.GetKeyNames(sl);
    if Utf8Decode(sl.DelimitedText)=AExpected then
      Results.Add('TestGetKeyNames   passed: Key: "%s"; Expected: "%s";',[AKey,AExpected])
    else
      Results.Add('TestGetKeyNames-02 failed: Key: "%s"; got: "%s"; expected: "%s";',
                           [AKey,sl.DelimitedText,AExpected]);
  except
    on e:Exception do
      Results.Add('TestGetKeyNames-03 failed exception: Key: "%s"; Got: "%s"; Expected: "%s"; Exception: "%s";',
                           [AKey,sl.DelimitedText,AExpected,e.Message]);
  end;
  sl.Free;
end;

procedure TestGetValueNames (const AKey, AExpected: Unicodestring);
var
  sl: TStringList;
begin
  sl:=TStringList.Create;
  sl.Delimiter:=';';
  try
    reg.GetValueNames(sl);
    if Utf8Decode(sl.DelimitedText)=AExpected then
      Results.Add('TestGetValueNames passed: Key: "%s"; Expected "%s";',[AKey,AExpected])
    else
      Results.Add('TestGetValueNames-01 failed: Key "%s"; Got: "%s"; Expected: "%s";',
                           [AKey,sl.DelimitedText,AExpected]);
  except
    on e:Exception do
      Results.Add('TestGetValueNames-02 failed exception: Key: "%s"; Got: "%s"; expected: "%s"; exception: "%s";',
                           [AKey,sl.DelimitedText,AExpected,e.Message]);
  end;
  sl.Free;
end;

procedure Test;
var
  sKey:        Unicodestring;
  slKeys,
  slNames,
  slValues:    TStringList;
  sValueNames,
  s:           Unicodestring;
  k,n,v:       integer;
  l:           longint;
begin
  sKey:=LabelKeyCaption;
  l:=pos('\',LabelKeyCaption);
  if l>0 then
    delete(sKey,1,l);
  if sKey[Length(sKey)]='\' then
    SetLength(sKey,Length(sKey)-1);

  slKeys:=TStringList.Create;
  slKeys.Delimiter:=';';
  slKeys.DelimitedText:=Utf8Encode(EditKey);

  slNames:=TStringList.Create;
  slNames.Delimiter:=';';
  slNames.DelimitedText:=Utf8Encode(LabeledEditName);

  slValues:=TStringList.Create;
  slValues.Delimiter:=';';
  slValues.DelimitedText:=Utf8Encode(LabeledEditValue);
  
  for k:=0 to slKeys.Count-1 do
    if TestKey(sKey+'\'+Utf8Decode(slKeys[k])) then
    begin
      sValueNames:='';
      for n:=0 to slNames.Count-1 do
        for v:=0 to slValues.Count-1 do
        begin
          s:=UnicodeFormat('%d%d%d_%s',[k,n,v,Utf8Decode(slNames[n])]);
          if sValueNames='' then
            sValueNames:=s
          else
            sValueNames:=sValueNames+Utf8Decode(slNames.Delimiter)+s;
          TestValue(s,Utf8Decode(slValues[v]));
        end;
      TestGetValueNames(reg.CurrentPath,sValueNames);
    end;

  TestGetKeyNames(sKey,Utf8Decode(slKeys.DelimitedText));

  reg.CloseKey;

  slKeys.Free;
  slNames.Free;
  slValues.Free;
end;

Procedure WN;
Var
  F : Text;


begin
  Assign(F,'names.txt');
  Rewrite(F);
  Writeln(F,EditKey);
  Writeln(F,labeledEditName);
  Writeln(F,LabeledEditValue);
  Writeln(F,LabelKeyCaption);
  Close(F);
end;

begin
  defaultsystemcodepage:=CP_UTF8;
  if (ParamStr(1)='-s') then
    WN;
  reg:=TRegistry.Create;
  reg.lazywrite:=false;
  Results:=TStringList.Create;
  Test;
  Reg.Free;
  if (ParamStr(1)='-s') then
    Results.SaveToFile('result.txt');
  Writeln(Results.Text);
  Results.Free;
  {$IFDEF WINDOWS}Readln;{$ENDIF}
end.

