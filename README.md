# OpenCL-Basic-Functions

## Description

The following functions has been generated in order to save hardware resources in the implementation of OpenCL kernels. *ReLU* and *IdxShift* has only a few of hardware resources, so this functions also could be implemented in OpenCL. *IEEE754_Mult* and *IEEE754_AdderSubtract* implement the *(\*, +)* operators in the IEEE-754 standard. Contrasting the generated functions with the *Floating-Point IP Cores User Guide* functions of *ALTFP_MULT* and *ALTFP_ADD_SUB*, my functions has lower hardware resources and a greatest *fmax*. The following tables shows the *Quartus II* reports about hardware utilization and timing analisis.

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
