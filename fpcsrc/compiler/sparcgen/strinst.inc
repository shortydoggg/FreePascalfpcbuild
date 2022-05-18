{******************************************************************************
 *****************************************************************************}
          'none',
          'abcd',
          'add','addcc','addx','addxcc',
          'and','andcc','andn','andncc',
          'jmp',
          'jmpl',
          'call',
          'ba','b','fba','fb',
          'cbccc',
          'flush',
          'ldsb','ldsh','ldstub',
          'ldub','lduh','ld','ldd','ld','ldfsr','ldd','ldc','ldcsr','lddc','ldx','lduw','ldsw',
          'ldsba','ldsha','lduba','lduha','lda','ldda',
          'ldstuba',
          'mulscc',
          'mulx',
          'nop',
          'or','orcc','orn','orncc',
          'rd','rd','rd','rd','rd',
          'restore',
          'ret','retl',
          'save',
          'sdiv','sdivcc','sdivx',
          'smul','smulcc',
          'sethi',
          'sll','srl','sra','sllx','srlx','srax',
          'stb','sth','st','std','st','std','stfsr','stdfq','stx',
          'stc','stdc','stcsr','stdcq',
          'stba','stha','sta','stda',
          'sub','subcc','subx','subxcc',
          'swap','swapa','ticc','taddcc','tsubcc','taddcctv','tsubcctv',
          'ta','t',
          'udiv','udivcc','udivx',
          'umul','umulcc',
          'unimp',
          'wrasr','wry','wrpsr','wrwim','wrtbr',
          'xnor','xnorcc',
          'xor','xorcc',
          {floating-point instructions}
          'fitos','fitod','fitoq',
          'fstoi','fdtoi','fqtoi',
          'fstod','fstoq',
          'fdtos','fdtoq',
          'fqtod','fqtos',
          'fmovs','fnegs','fabss',
          'fsqrts','fsqrtd','fsqrtq',
          'fadds','faddd','faddq',
          'fsubs','fsubd','fsubq',
          'fmuls','fmuld','fmulq',
          'fdmulq','fsmuld',
          'fdivs','fdivd','fdivq',
          'fcmps','fcmpd','fcmpq',
          'fcpop1','cpop2',
          {synthetic instructions}
          'btst','bset','bclr','btog',
          'clr','clrb','clrh',
          'cmp',
          'dec','deccc',
          'inc','inccc',
          'mov','mov','movrz','movrlez','movrlz','movrnz','movrgz','movrgez',
          'neg',
          'not',
          'set',
          'skipz','skipnz',
          'tst',
          { internal instructions }
          'fmovd',
          'fabsd','fabsq',
          'fnegd','fnegq',
          { memory barrier instructions }
          'stbar',
          'membar',

          { SPARC v9 }
          'flushw',
          'cas',
          'casa',
          'casx',
          'casxa'
