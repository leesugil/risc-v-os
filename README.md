# risc-v-os
Learning to build an OS on RISC-V
(currently following Sarah Jamie Lewis)

## Documents
- The RISC-V Instruction Set Manual Volume I: Unprivileged ISA
- The RISC-V Instruction Set Manual Volume II: Privileged Architecture

base instruction set

AEE
SEE
HEE

privilege levels
0|00|U
1|01|S
2|10|Reserved 
3|11|M

registers
- mhartid
- mstatus
- misa
- mie
- mtvec

## Hardware (Machine)
qemu riscv virt
You can learn everything about the machine in the source code of QEMU
RISC-V VIRT (such as memory mapping addresses).

### Get QEMU Running
qemu-system-riscv64 -M virt -smp 4 -m 128M -nographic -serial mon:stdio -bios none -kernel kernel.elf
**Eexecutable and Linkable Format (ELF)** is a common standard file format for
executable files and the standard binary file format for Unix and Unix-like
systems on x86 processors.

####parameters
- cpu architecture (risc-v 64 bit)
- virtual machine / no
- number of cores
- memory (RAM)
- no/yes graphic
- serial interface
- kernel (that we're going to build)

## Linker Script
kernel.lds
**ld** is the linker of object files in Unix-like systems that is used at the
last step of compilation.
A linker script explicitly control over the link process.

## Assembler Source Code
root.S

