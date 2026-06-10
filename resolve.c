#include <windows.h>
#include <stdio.h>

int main(){

    LPSTR DLL = "Kernel32.dll";
    LPSTR Func = "LoadLibraryA";

    LPVOID address = GetProcAddress(LoadLibraryA(DLL), Func);
    printf("0x%p", address);
    return 0;

}