# Calling-MessageBox-From-Assembly-x64

## Overview
This repository contains a low-level, educational Proof-of-Concept (PoC) demonstrating a robust structural layout for invoking native Windows APIs and DLL functions under the Microsoft x64 Calling Convention. 

The project features a completely standalone, self-contained x64 assembly payload. To handle Address Space Layout Randomization (ASLR) during development, a custom C-based address resolver utility was used to locate the active memory addresses of target system APIs (`LoadLibraryA` and `MessageBoxA`). These resolved addresses were then hardcoded directly into the raw assembly stub, allowing the payload to execute independently without requiring an external wrapper or loader to pass it parameters at runtime.


## Disclaimer
This project is created strictly for educational purposes, software engineering portfolio development, and authorized security research. The author is not responsible for any misuse or damage caused by this software.
