{
    Copyright (c) 1998-2004 by Jonas Maebe

    This unit calls the optimization procedures to optimize the assembler
    code for sparc

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

unit aoptcpu;

{$i fpcdefs.inc}

interface

uses cpubase, aasmtai, aopt, aoptx86;

type
  TCpuAsmOptimizer = class(TX86AsmOptimizer)
    function PrePeepHoleOptsCpu(var p: tai): boolean; override;
    function PeepHoleOptPass1Cpu(var p: tai): boolean; override;
    function PeepHoleOptPass2Cpu(var p: tai): boolean; override;
    function PostPeepHoleOptsCpu(var p : tai) : boolean; override;
    procedure PostPeepHoleOpts; override;
  end;

implementation

uses
  globals,
  aasmcpu;

    function TCpuAsmOptimizer.PrePeepHoleOptsCpu(var p : tai) : boolean;
      begin
        result := false;
        case p.typ of
          ait_instruction:
            begin
              case taicpu(p).opcode of
                A_SAR,A_SHR:
                  result:=PrePeepholeOptSxx(p);
              end;
            end;
        end;
      end;


    function TCpuAsmOptimizer.PeepHoleOptPass1Cpu(var p: tai): boolean;
      begin
        result:=False;
        case p.typ of
          ait_instruction:
            begin
            case taicpu(p).opcode of
              A_AND:
                Result:=OptPass1AND(p);
              A_MOV:
                Result:=OptPass1MOV(p);
              A_MOVSX,
              A_MOVZX:
                Result:=OptPass1Movx(p);
              A_VMOVAPS,
              A_VMOVAPD,
              A_VMOVUPS,
              A_VMOVUPD:
                result:=OptPass1VMOVAP(p);
              A_MOVAPD,
              A_MOVAPS,
              A_MOVUPD,
              A_MOVUPS:
                result:=OptPass1MOVAP(p);
              A_VDIVSD,
              A_VDIVSS,
              A_VSUBSD,
              A_VSUBSS,
              A_VMULSD,
              A_VMULSS,
              A_VADDSD,
              A_VADDSS,
              A_VANDPD,
              A_VANDPS,
              A_VORPD,
              A_VORPS,
              A_VXORPD,
              A_VXORPS:
                result:=OptPass1VOP(p);
              A_MULSD,
              A_MULSS,
              A_ADDSD,
              A_ADDSS:
                result:=OptPass1OP(p);
              A_VMOVSD,
              A_VMOVSS,
              A_MOVSD,
              A_MOVSS:
                result:=OptPass1MOVXX(p);
              A_LEA:
                result:=OptPass1LEA(p);
              A_SUB:
                result:=OptPass1Sub(p);
              A_SHL,A_SAL:
                result:=OptPass1SHLSAL(p);
              A_SETcc:
                result:=OptPass1SETcc(p);
            end;
          end;
        end;
      end;


    function TCpuAsmOptimizer.PeepHoleOptPass2Cpu(var p : tai) : boolean;
      begin
        Result := False;
        case p.typ of
          ait_instruction:
            begin
              case taicpu(p).opcode of
                A_MOV:
                  Result:=OptPass2MOV(p);
                A_IMUL:
                  Result:=OptPass2Imul(p);
                A_JMP:
                  Result:=OptPass2Jmp(p);
                A_Jcc:
                  Result:=OptPass2Jcc(p);
              end;
            end;
        end;
      end;


    function TCpuAsmOptimizer.PostPeepHoleOptsCpu(var p: tai): boolean;
      begin
        result := false;
        case p.typ of
          ait_instruction:
            begin
              case taicpu(p).opcode of
                A_MOV:
                  Result:=PostPeepholeOptMov(p);
                A_MOVZX:
                  Result:=PostPeepholeOptMovzx(p);
                A_CMP:
                  Result:=PostPeepholeOptCmp(p);
                A_OR,
                A_TEST:
                  Result:=PostPeepholeOptTestOr(p);
                A_XOR:
                  Result:=PostPeepholeOptXor(p);
                A_CALL:
                  Result:=PostPeepholeOptCall(p);
                A_LEA:
                  Result:=PostPeepholeOptLea(p);
              end;
            end;
        end;
      end;


    procedure TCpuAsmOptimizer.PostPeepHoleOpts;
      begin
        inherited;
        OptReferences;
      end;

begin
  casmoptimizer := TCpuAsmOptimizer;
end.

