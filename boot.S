.option norvc

.section .text.init
.global _start

_start:
	csrr t0, mhartid
	bnez t0, _wait
	call _setup_uart
	call _write_uart
	wfi

_setup_uart:
	# Disable Interrupts on the UART
	li t1, 0x10000001
	sb x0, 0(t1)
	# Write out to the UART Line Control Register at UART+3
	li t1, 0x10000003
	li t2, 0x03 # Set the output to 8 buts
	sb t2, 0(t1)
	ret

_write_uart:
	li t1, 0x10000000
	li t2, 0x41
	sb t2, 0(t1)

_wait:
	wfi
