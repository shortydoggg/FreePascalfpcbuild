{ %CPU=i386 }
PROGRAM Test;
{$asmmode intel }
var
  DoIt : boolean;
 
BEGIN
 DoIt:=false;
 if Doit then
    asm
      mov ax,[0]
    end;
  WriteLn('This test works');
END.
