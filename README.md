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
You can learn everything about the machine in the source code of QEMU RISC-V VIRT (such as memory mapping addresses).

## Get QEMU Running
Once QEMU RISC-V 64 VIRT is installed, we'll emulate a RISC-V 64 environment
using the following command.
`qemu-system-riscv64 -M virt -smp 4 -m 128M -nographic -serial mon:stdio -bios none -kernel kernel.elf`
We'll explain the parameters a little bit later.
In order to run the code, we need the kernel `kernel.elf` written by us. 😁
**Executable and Linkable Format (ELF)** is a common standard file format for
executable files and the standard binary file format for Unix and Unix-like
systems on x86 processors.

## Compiling Bootloader
In order to compile this RISC-V assembly code into an object file, you need a RISC-V toolchain installed (homebrew available).
- Assembly Source Code (assembler)
    - `boot.S`
- Compilation (assembler > RISC-V 64 machine code)
    - `riscv64-unknown-elf-as boot.S -o boot.o`
- Linker (configuration on how to layout objects and memories so that QEMU can
    execute properly)
    - kernel.lds
- Linking 
    - `riscv64-unknown-elf-ld -T kernel.lds boot.o -o kernel.elf`

## Get QEMU Running
`qemu-system-riscv64 -M virt -smp 4 -m 128M -nographic -serial mon:stdio -bios none -kernel kernel.elf`

### parameters
- cpu architecture (risc-v 64 bit)
- virtual machine / no
- number of cores
- memory (RAM)
- no/yes graphic
- serial interface
- kernel

We set up four cores here.
In `boot.S`, we set all four hardware threads
to start at the same time
`.global _start`
and go wait for interrupts
`_start:
    wfi`
