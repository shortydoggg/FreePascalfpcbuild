{ %skiptarget=aix }

{ this kills one of the make-processes when executed during a testsuite
  run on AIX/ppc64 }

{ Source provided for Free Pascal Bug Report 2494 }
{ Submitted by "Alan Mead" on  2003-05-17 }
{ e-mail: cubrewer@yahoo.com }
uses
  erroru;

{$ifdef CPU16}
  const
    StartSize = 16*1024;
    MaxSize = $10000;
{$else}
  const
    StartSize = 1024*1024;
    MaxSize =  2000000000{$ifdef CPU64}*2000000000{$endif CPU64};
{$endif}


type
  matrix_element = array[1..1] of byte;
  big_matrix = array[1..1000000,1..610] of matrix_element;

  longarray = array[0..0] of real;

{var
  a : big_matrix;}

var p:pointer;
  l : ^longarray;
  size, storage : ptruint;
  i,j:longint;
  done:boolean;
  mem : sizeuint;
begin
  ReturnNilIfGrowHeapFails:=true;
  domem(mem);
  done := false;
  size := StartSize;
  repeat
    size := size+(size div 10);
    storage := size * sizeof(real);
    if storage>MaxSize then
      storage:=MaxSize;
    writeln('size=',size,' (storage=',storage,')');
    getmem(l,storage);
    if (l=nil) then
      begin
        done := true;
        writeln('getmem() failed');
      end
    else
      begin
        writeln('getmem() was successful');
//        freemem(l,storage);
      end;
  until (done);
  domem(mem);
end.
