BITS 64

%define ldLib 0x7ffcc06c2cd0
%define MsgBox 0x7ffcbf9ecac0

global _start

section .text

_start:

; Prologue
	push rbp
	mov rbp, rsp
	sub rsp, 0x30
; End Prologue

; Loading User32.dll
	mov rax, "ll"
	mov QWORD [rsp+0x28], rax
	mov rax, "User32.d"
	mov QWORD [rsp+0x20], rax
	lea rcx, [rsp+0x20]
	mov rax, ldLib
	call rax ; user32.dll is loaded
; End of Loading User32.dll

; Calling MassageBoxA()
	mov rax, "HELLO fr"
	mov QWORD [rsp+0x20], rax
	mov rax, "om ASM"
	mov QWORD [rsp+0x28], rax
	mov rax, "Test"
	mov QWORD [rsp+0x30] , rax

	xor rcx, rcx
	lea rdx, [rsp+0x20]
	lea r8, [rsp+0x30]
	mov r9, 0x00000002
	mov rax, MsgBox
	call rax
; End of Calling MassageBox()

; Eipoluge
	add rsp, 0x30
	pop rbp
	ret
; Eipoluge
