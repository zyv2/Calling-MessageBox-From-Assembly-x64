# Standalone x64 Windows Function Execution Framework

## Project Overview
This repository contains a low-level, educational Proof-of-Concept (PoC) demonstrating how to transition from 32-bit exploit development structures into modern 64-bit Windows architectures. The project features a standalone x64 assembly payload written in Intel-syntax NASM that handles stack management, structures dynamic local strings, and invokes native Windows APIs (`LoadLibraryA` and `MessageBoxA`).

To execute the payload safely, a companion C-based loader is utilized to allocate memory with appropriate execution permissions (`PAGE_EXECUTE_READWRITE`) and transition control directly to the assembly block.

## Development Workflow
Because this project targets specific memory layouts in a controlled lab environment, it utilizes a pre-processing workflow to handle Address Space Layout Randomization (ASLR):
1. **API Pointing:** A helper utility written in C is used prior to compilation to locate the active virtual memory addresses of `LoadLibraryA` and `MessageBoxA`.
2. **Static Definition:** These precise 64-bit hex pointers are defined as constants directly inside the NASM source (`%define`).
3. **Execution Harness:** The compiled standalone shellcode is read into memory and executed natively via the custom C loader harness.

## Technical Concepts Demonstrated
* **Microsoft x64 Calling Convention:** Transitions from the 32-bit stack-heavy argument model to the modern x64 register pipeline, accurately loading function parameters into `RCX`, `RDX`, `R8`, and `R9`.
* **Shadow Space Buffer Management:** Allocates a single, calculated stack frame (`sub rsp, 0x30`) to reserve the mandatory 32-byte scratchpad required by Windows APIs, protecting local string data from corruption during function execution.
* **16-Byte Stack Alignment:** Implements precise hardware-compliant prologue and epilogue boundaries to satisfy CPU optimization requirements and prevent alignment-based hardware faults.
* **On-the-Fly Memory Representation:** Manually splits ASCII string constants into 8-byte immediate data pieces to construct valid local string arguments on the stack frame dynamically.

## Future Roadmap: Portability Upgrade
While this version demonstrates the core mechanics of the x64 stack and calling convention using hardcoded constants, the next phase of this repository will focus on complete payload portability. 


## Disclaimer
This project is created strictly for educational purposes, software portfolio development, and authorized defensive/offensive security research. The author is not responsible for any misuse or unintended execution of this code.
