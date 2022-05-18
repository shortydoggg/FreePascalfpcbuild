{
    Copyright (C) 1998-2000 by Florian Klaempfl

    This unit handles the temporary variables stuff for sparc64

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************
}
{
  This unit handles the temporary variables stuff for i8086.
}
unit tgcpu;

{$i fpcdefs.inc}

  interface

    uses
      tgobj,globtype,aasmdata,cgutils,symtype;

    type
      ttgsparc64 = class(ttgobj)
        procedure temp_to_ref(p: ptemprecord; out ref: treference); override;
      end;

implementation

uses
  cpubase;

procedure ttgsparc64.temp_to_ref(p: ptemprecord; out ref: treference);
  begin
    inherited;
    inc(ref.offset,STACK_BIAS);
  end;

begin
  tgobjclass:=ttgsparc64;
end.
