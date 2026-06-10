
Why use assembly ?

we can use assembly to bypass and evade detection of user-land EDR

this is a POC


## boilerplate

```c
BITS 64

%define ldLib 0x7ffcc06c2cd0
%define MsgBox 0x7ffcbf9ecac0

global _start

section .text

_start:

; stack management
; Prologue
        push rbp
        mov rbp, rsp
        sub rsp, 0x30
; End Prologue

; ---------------------- our shellcode here --------------------------


; CLEAN the stack 
; Eipoluge
        add rsp, 0x30
        pop rbp
        ret
; Eipoluge

```

## Load User32.dll

how can we load the User32.dll?

using the kernal32.dll function call `LoadLibrary`

but how can we determine the address of `LoadLibrary`

in this POC I will cheat by resolving my `LoadLibrary` address that will work only in my machine but later we will use the `TEB` structure to resolve the addresses dynamically without hardcoding.

"resolver.c"
```c
#include <windows.h>
#include <stdio.h>
int main(){

    LPSTR DLL = "Kernel32.dll";

    LPSTR Func = "LoadLibraryA";

  

    LPVOID address = GetProcAddress(LoadLibraryA(DLL), Func);

    printf("0x%p", address);

    return 0;

}

```

shellcode_part1.asm
```c


; Loading User32.dll
	; building the string to be "User32.dll"
        mov rax, "ll"
        mov QWORD [rsp+0x28], rax
        mov rax, "User32.d"
        mov QWORD [rsp+0x20], rax
    ; calling convetion of x64 first parameter in rcx
        lea rcx, [rsp+0x20]
	; calling the LoadLibrary
        mov rax, ldLib
        call rax ; user32.dll is loaded
; End of Loading User32.dll

```


## Call MessageBoxA

This is what we will use to populate the correct registers with correct values
```c
int MessageBox( [in, optional] HWND hWnd, [in, optional] LPCTSTR lpText, [in, optional] LPCTSTR lpCaption, [in] UINT uType );
```

```c

; Calling MassageBoxA()
	; building the message string bigger then 8 bytes make sure to null terminate
        mov rax, "HELLO fr"
        mov QWORD [rsp+0x20], rax
        mov rax, "om ASM"
        mov QWORD [rsp+0x28], rax
    ; building the title string
        mov rax, "Test"
        mov QWORD [rsp+0x30] , rax
	; calling convetion 
	; HWND into rcx
        xor rcx, rcx
    ; lpText address of our message into rdx
        lea rdx, [rsp+0x20]
    ; lpCaption address of our title into r8
        lea r8, [rsp+0x30]
    ; uType type of the window into r9 I chose a random one
        mov r9, 0x00000002
    ; Call the hardcoded address of MessageBoxA
        mov rax, MsgBox
        call rax
; End of Calling MassageBox()
```


## Load Our Shellcode into Process


My simple loader
```c

#include <Windows.h>

#include <stdio.h>

  

int main (){

  

    BYTE *shellcode = "\x55\x48\x89\xe5\x48\x83\xec\x30\xb8\x6c\x6c\x00\x00\x48\x89\x44\x24\x28\x48\xb8\x55\x73\x65\x72\x33\x32\x2e\x64\x48\x89\x44\x24\x20\x48\x8d\x4c\x24\x20\x48\xb8\xd0\x2c\x6c\xc0\xfc\x7f\x00\x00\xff\xd0\x48\xb8\x48\x45\x4c\x4c\x4f\x20\x66\x72\x48\x89\x44\x24\x20\x48\xb8\x6f\x6d\x20\x41\x53\x4d\x00\x00\x48\x89\x44\x24\x28\xb8\x54\x65\x73\x74\x48\x89\x44\x24\x30\x48\x31\xc9\x48\x8d\x54\x24\x20\x4c\x8d\x44\x24\x30\x41\xb9\x02\x00\x00\x00\x48\xb8\xc0\xca\x9e\xbf\xfc\x7f\x00\x00\xff\xd0\x48\x83\xc4\x30\x5d\xc3";

  

    int size = 128;

    LPVOID execMem = VirtualAlloc(0, strlen(shellcode), MEM_COMMIT, PAGE_EXECUTE_READWRITE);


    memcpy(execMem, shellcode, size);

  

    int(* loader)();

    loader = (int(*)())execMem;

    loader();
	printf("Returned from the shellcode\n");
    return 0;

}


```


## Testing 


This is our shellcode under the debugger
![](../pics/Pasted%20image%2020260610141424.png)
as we can see the hardcoded address for our functions are recognized correctly 

And we get the MsgBox!!!
![](../pics/Pasted%20image%2020260610141543.png)

Exited with no errors
![](../pics/Pasted%20image%2020260610141819.png)
