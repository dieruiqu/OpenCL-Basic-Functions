# OpenCL-Basic-Functions

## Description

The following functions has been generated in order to save hardware resources in the implementation of OpenCL kernels. *ReLU* and *IdxShift* has only a few of hardware resources, so this functions also could be implemented in OpenCL. *IEEE754_Mult* and *IEEE754_AdderSubtract* implement the *(\*, +)* operators in the IEEE-754 standard without rounding mode set. Contrasting the generated functions with the *Floating-Point IP Cores User Guide* functions of *ALTFP_MULT* and *ALTFP_ADD_SUB*, my functions has lower hardware resources and a greatest *fmax*. The following tables shows the *Quartus II* reports about hardware utilization and timing analisis.

#### Hardware utilization resources report

|*Module*             | *ALM's* |*DSPs*|*Memory bit blocks*|*Registers*|
|:--------------------|:-------:|:----:|:-----------------:|:---------:|
|IdxShifter           |   16    |   0  |         0         |    64     |
|ReLU                 |   17    |   0  |         0         |    62     |
|IEEE754_Mult         |   33    |   1  |         0         |    64     |
|IEEE754_AdderSubtract|   265   |   1  |         0         |    62     |

#### Timing analisis report

|*Module*| *f<sub>min</sub> (MHz)* |*f<sub>max</sub> (MHz)*| *Latency*  |
|:--------------------|:------:|:-------:|:--:|
|IdxShifter           | 580.05 | 851.79  | 2  |
|ReLU                 | 580.05 | 848.9   | 2  |
|IEEE754_Mult         | 580.05 | 850.34  | 2  |
|IEEE754_AdderSubtract| 580.05 | 851.79  | 2  |

## Files

The following folders and his files compose the *Verilog* functions:
- IdxShifter

  - *IdxShifter.v*: module to multiply by 2 in fixed point. Implemented it via left shift.
  
- ReLU 

  - *ReLU.v*: module to implement the ReLU function.

- IEEE754_Mult

  - *IEEE754_Mult.v*: module to implement the IEEE-754 multiplication.
 
- IEEE754_AdderSubtract

  - *ROM_shift.v*: Asynchronus ROM to perform the right shifts via fixed point multiplication.
  - *ROM_shift_init.txt*: Initial values from the ROM.
  - *IEEE754_AdderSubtract*: module to implement the IEEE-754 adder-subtraction.

## Simulations
The following pictures shows the simulation of the *IEEE754_Mult* and *IEEE754_AdderSubtract*. Note that how no rounding mode is set, the error between the original operator and the implented it somes times is not zero but closer to zero. For small values, as it happens in neural networks, the error is innapreciable, so this implemented functions work's well for neural networks purposes in fp32.

