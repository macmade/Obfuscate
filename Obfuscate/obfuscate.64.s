/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2015 Jean-David Gadina - www-xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

push    rax                         /* Save RAX, as we're going to use it */
push    rcx                         /* Save RCX, as we're going to use it */
push    rdx                         /* Save RDX, as we're going to use it */
mov     rcx,        rsp             /* Save the original stack pointer (RSP) in RCX */
mov     rsp,        rbp             /* Move the base pointer (RBP) to the stack pointer (RSP), resetting the current stack frame */
pop     rbp                         /* Save the original base pointer in RBP */
pop     rax                         /* Save the original return address in RAX */
lea     rdx,        [ rip + 97 ]    /* Address of the local "0:" label, using 64-bit RIP relative addressing */
push    rdx                         /* Store it as the new return address */
push    rdx                         /* Again, so the stack keeps its original alignment (required on OS X ABI) */

ret                                 /* Return from procedure */
                                    /* This will fool most disassemblers, as they will stop disassembly here, seeing a return */
                                    /* But as the return address is now the address of the "0:" label, we'll simply jump there, resuming the current procedure */

push    rbp                         /* As we previously faked a return, creates a stack frame so it will seem logical to the disassembler */
mov     rbp,        rsp             /* This code will obviously never been executed */
xor     rax,        rax             /* Zero RAX (why not...) */
cmp     rax,        rax             /* Compares RAX to RAX, so we can jump to the valid portion of the code (next is just random junk) */

                                    /* The following instructions will never been executed */
                                    /* They just create local jumps that the disassembler will try to follow, fooling it quite a lot */
je      j0                          /* Dead code - Jump to J0 if zero */
cmp     rax,        rdi             /* Dead Code - Compares RAX to RDI (faking a 1st function argument - SysV AMD64) */
je      j1                          /* Dead code - Jump to J1 if zero */
add     rax,        0xCAFE          /* Dead Code - Add some magical number (I need some coffee indeed) */
cmp     rax,        rsi             /* Dead Code - Compares RAX to RSI (faking a 2nd function argument - SysV AMD64) */
je      j2                          /* Dead code - Jump to J2 if zero */
cmp     rax,        rdx             /* Dead Code - Compares RAX to RDX (faking a 3rd function argument - SysV AMD64) */
je      j3                          /* Dead code - Jump to J3 if zero */
cmp     rax,        rcx             /* Dead Code - Compares RAX to RCX (faking a 4th function argument - SysV AMD64) */
je      j4                          /* Dead code - Jump to J4 if zero */
jmp     24[ rip ]                   /* Dead Code - Jump to a random location */

j0:
    jmp     16[ rip ]               /* Dead Code - Jump to a random location */
    
j1:
    jmp     48[ rip ]               /* Dead Code - Jump to a random location */
        
j2:
    jmp     64[ rip ]               /* Dead Code - Jump to a random location */
        
j3:
    jmp     128[ rip ]              /* Dead Code - Jump to a random location */
        
j4:
    jmp     256[ rip ]              /* Dead Code - Jump to a random location */

0:                                  /* Previous return will jump here - This is valid code that will be executed */

pop     rdx                         /* Pop the additional push required for the stack alignment */
push    rax                         /* Push back the original return address, so we'll return where we're supposed to return originally */
push    rbp                         /* Push back the original base pointer */
mov     rbp,        rsp             /* Restore the current base pointer */
mov     rsp,        rcx             /* Restore the current stack pointer */
pop     rdx                         /* Restore RDX */
pop     rcx                         /* Restore RCX */
pop     rax                         /* Restore RAX */


push    rax                         /* Save RAX, as we're going to use it */
xor     rax,        rax             /* Zero RAX */
jz      done                        /* Test if zero - obviously, as we just did it, so we can jump to the valid portion of the code (next is just random junk) */

                                    /* Adds an incomplete instruction, in order to fool the disassembler a bit more */
.byte   0x89                        /* 0x89 is the opcode for "mov" (r/m16/32/64 r16/32/64) */
.byte   0x84                        /* 0x84 (1000 0100) is MOD-REG-R/M for a four byte displacement following SIB with RAX (000) as destination register */
.byte   0xD9                        /* 0xD9 (1101 1001) is SIB for 8 as scale, RBX as index (011) and RCX as base (001) */
                                    /* Four displacement bytes are ommited, so the instruction is incomplete, fooling the disassembler which will try to interpret the bytes follwing this instruction */
                                    /* Complete instruction would translate to "mov rax, [ rcx + rbx * 8 + displacement ]" */

done:                               /* Previous jump will end here - This is valid code that will be executed */
    
    pop     rax                     /* Restore RAX */
