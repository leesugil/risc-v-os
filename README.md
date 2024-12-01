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
    - `kernel.lds`
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

### Boot with no instructions

We set up four cores here.
In `boot.S`, we set all four hardware threads (t0, t1, t2, t3)
to start at the same time
`.global _start`
and go wait for interrupts
```
_start:
    wfi
```

### Controlling threads (cores? harts?)

Since we set `.global _start`, all four hardware threads go to `_start`.
It's like `for each, run _start`.
For each thread, we can read out their Hart ID from the system registers.
And by requirement, every RISC-V system must contain a unique thread with Hart
ID 0.
So we can put a simple `if` condition to write a single-core instruction like
`read hartid. if 0, do this. otherwise, wfi.`

Read one of the system registers
Hart ID Register `mhartid`
contains the integer ID of the hardware thread running the code.

CSR Read Asseembly Instruction
Control and Status Register (CSR)
to read the mhartid register and store it in the temporary register (`t0`):
`scrr t0, mhartid`
Branch on Not Equal to Zero
`bnez t0, _wait`
If the mhartid stored in `t0` is not 0, go to the `_wait` section.
```
_wait
    wfi
```
Otherwise, let's print something.
```
j _write_uart
wfi
```
where the `_write_uart` section is declared to be
```
_write_uart:
    li t1, 0x41 # in variable t1, store 0x41 which is `A` in ASCII
    li t2, 0x10000000   # in variable t2, store the UART address used in
    QEMU emulation
    sb t1, (t2) # store the value in t1 to the memory address t2.
```
This is the minimum viable product to get something out of our bootloader.


