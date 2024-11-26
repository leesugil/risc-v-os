.option norvc

.section .text.init
.global _start

_start:
	csrr t0, mhartid
	bnez t0, _wait
	j _write_uart
	wfi

_write_uart:
	li t1, 0x61
	li t2, 0x10000000
	sb t1, (t2)

_wait:
	wfi
