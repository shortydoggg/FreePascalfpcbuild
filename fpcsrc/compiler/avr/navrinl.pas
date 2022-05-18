{
    Copyright (c) 1998-2017 by Florian Klaempfl

    Generates AVR inline nodes

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
unit navrinl;

{$i fpcdefs.inc}

  interface

    uses
      node,ninl,ncginl;

    type
      tavrinlinenode = class(tcginlinenode)
        function pass_typecheck_cpu:tnode;override;
        function first_cpu : tnode;override;
        procedure pass_generate_code_cpu;override;
      end;

  implementation

    uses
      compinnr,
      aasmdata,
      aasmcpu,
      symdef,
      cgbase,
      cpubase;

    function tavrinlinenode.pass_typecheck_cpu : tnode;
      begin
        Result:=nil;
        case inlinenumber of
          in_avr_nop,
          in_avr_sleep,
          in_avr_sei,
          in_avr_wdr,
          in_avr_cli:
            begin
              CheckParameters(0);
              resultdef:=voidtype;
            end;
          else
            Result:=inherited pass_typecheck_cpu;
        end;
      end;


    function tavrinlinenode.first_cpu : tnode;
      begin
        Result:=nil;
        case inlinenumber of
          in_avr_nop,
          in_avr_sleep,
          in_avr_sei,
          in_avr_wdr,
          in_avr_cli:
            begin
              expectloc:=LOC_VOID;
              resultdef:=voidtype;
            end;
          else
            Result:=inherited first_cpu;
        end;
      end;


    procedure tavrinlinenode.pass_generate_code_cpu;
      begin
        case inlinenumber of
          in_avr_nop:
            current_asmdata.CurrAsmList.concat(taicpu.op_none(A_NOP));
          in_avr_sleep:
            current_asmdata.CurrAsmList.concat(taicpu.op_none(A_SLEEP));
          in_avr_sei:
            current_asmdata.CurrAsmList.concat(taicpu.op_none(A_SEI));
          in_avr_wdr:
            current_asmdata.CurrAsmList.concat(taicpu.op_none(A_WDR));
          in_avr_cli:
            current_asmdata.CurrAsmList.concat(taicpu.op_none(A_CLI));
          else
            inherited pass_generate_code_cpu;
        end;
      end;

begin
  cinlinenode:=tavrinlinenode;
end.
