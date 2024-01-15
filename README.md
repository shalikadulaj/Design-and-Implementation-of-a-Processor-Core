
## 1 Introduction

The project involves the design and implementation of a processor core. This processor core is based on a specified processor architecture. The project aims to create a functional and efficient processor core that can execute instructions as per the defined architecture. The project design is focused on creating a 16-bit processor core, implementing its architecture using SystemVerilog, and generating a synthesized register-level model. Verification tasks involved simulating the core to ensure it correctly executed instructions according to the architecture's specifications. Gate- level implementation is used to optimize the design for area, speed, and power through logic synthesis. SystemVerilog is the primary hardware description language used for modeling the processor core. It is used to describe the behavior and structure of the core's components.




![1702487518514](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/155032a8-7767-4dd4-9af1-e71077aec618)

Figure 1. A block diagram of the processor core design (From mycpu_project_specification_202 3 )



Based on the student number, the design requirements are set (clock period and XXL instruction). According to my student number (2305411), the clock period is 11 ns. And the XXL instruction is

R0 = R0 + (R1 * R2). [Multiply-Accumulate].


## 2. Design of the control part of the mycpu CPU

### 2.1. Instruction decoder implementation

The implementation of the Control Unit (CU) in the myCPU involves creating a finite-state machine that controls the instruction fetch-and-execute cycle and decodes control signals for various components. The CU is responsible for managing the processor's state transitions and instruction decoding. It is designed to support a range of instructions, including special cases like the HALT (HAL) instruction and more complex instructions. The implementation is divided into several key steps, starting with the establishment of the basic state machine and gradually expanding to include instruction decoding logic, error handling, and support for specific instructions. The goal of the CU implementation is to ensure proper control of the processor's operation and the execution of instructions by the specified architecture.

![15 01 2024_02 48 36_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/397f44bf-c4d4-40d6-af1c-a7bdd349d896)

Figure 2. ASM Diagram (From mycpu_project_specification_202 3 )


### 2.2. Implementation of the XXL special instruction

The XXL instruction is the "Multiply-Accumulate" operation (R0 = R0 + (R1*R2)). It updates the value in a register by adding the result of multiplying two other registers. The implementation involves transferring data between registers, performing multiplication, adding the result, and storing it back. This operation can be performed in multiple stages. The state machine implements the control algorithm represented by the algorithmic state machine, as shown in the chart below.


![15 01 2024_02 49 21_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/27ed0015-5161-43f8-87b5-ed745b725e0a)


Figure 3. ASM diagram for the XXL instruction.

The instruction decoding logic are defined in the table below. This is implemented in the combinational logic process decoder in the RTL code. Don't-care values are shown as X.

Table 1. State Table of XXL Instruction

![15 01 2024_02 49 50_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/1e45ccfa-d86a-4801-9f62-252b481588b9)


Verification Plan
The verification plan checks if the processor behaves correctly when it changes from one state to another. It uses clock signals to control the timing and compares the expected results to the actual results, reporting any discrepancies as errors. This verification process has five stages. The first one is a reset test. This test verifies that after a reset, all registers and components are in a well-defined state. The state after reset is confirmed by using concurrent assertions, which are conditions that must hold true after the reset operation. In the second test, verify the response of the system when provided with instruction words for every opcode except HAL, XXL, and illegal and random operands. Then opcode test with HAL opcode. It confirms the behavior of the system when it receives the HAL opcode. In an opcode test with an illegal opcode, check how the system responds to an illegal opcode. The inputs are set to an illegal opcode, and the system's outputs are compared to expected values. The state machine's behavior during the execution of an illegal opcode is confirmed using concurrent
assertions. Finally, opcode Test with XXL opcode (Multiply-Accumulate). In this test, verify the operation of the system that performs a multiply-accumulate operation: R0 = R0 + (R1 * R2). Inputs are configured with the XXL opcode. The expected output is calculated based on the operation R0 = R0 + (R1 * R2), and the system's response is compared to the expected result.


## 3. mycpu verification

### 3.1. RTL code check results

According to the autocheck results, there were some issues with the RTL code. These errors relate to case statements, potential arithmetic overflow, unreachable code, and stuck-at faults in registers or latches.

![15 01 2024_02 50 31_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/9092c490-ddec-4bd0-af8f-ed9a497c2cdb)


Figure 4. Autocheck Results.

CASE_DEFAULT (Default Case Item Followed): This error arises when a case statement includes a default item. To resolve this need, ensure that the default or other item is used as intended without creating sensitization issues. ARITH_OVERFLOW_VAL (Arithmetic Overflow of a Value): This error happens when RHS
subexpressions exceed the range of the LHS variable. To solve this, we need arithmetic expressions to prevent values from overflowing the target variable's range. BLOCK_UNREACHABLE (Block of Code is Unreachable): This error indicates the code blocks that cannot be reached during program execution. To solve this, we need to eliminate unreachable sections. REG_STUCK_AT (Register/latch has a Stuck-at Fault): This error indicates registers or latches with one or more bits stuck at a constant value, which can lead to unexpected behavior. To solve this issue, we need to find the root cause (such as improper initialization or data flow).


### 3.2. The results of the functional verification

#### 3.2.1. fir.asm Simulation


![15 01 2024_02 50 55_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/3856bd3c-23f0-471a-804c-ed07c433a3fa)





A "fir.asm simulation" refers to the process of running and testing an assembly language program called "fir.asm" within a simulation environment. This program implements a 5-tap Finite Impulse Response (FIR) filter, a common signal processing algorithm. During the simulation, input data is processed using predefined coefficients, and the simulation results are observed to confirm that the FIR filter operates correctly. The simulation transcript displays expected results from the I/O, as above. The simulation results prove that the program is functioning successfully on the mycpu.


#### 3.2.2. xxl_test.asm Simulation


![15 01 2024_02 51 26_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/228ce3a4-5d4b-4eff-b627-bfc7ac61411f)




In the xxl_test.asm simulation, convert the xxl_test.asm file into the machine code file machincode.inc and run the RTL simulation of the xxl_test.asm. In this simulation, the R0 register is loaded with 1, the R1 register is loaded with 2, and the R2 register is loaded with 3. At first, R1*R2 results move to R15. Then the result of R0+R15 moved to the R0 register.
```
R15= R1*R2=2*3=6
R0=R0+R15=1+6=7
```
At the end of the simulation, R0 holds the value according to the equation “R0=R0+(R1*R2)”. It proves that the functionality of the system is successful.


## 4. Implementation of the mycpu design

### 4.1. Area results

Table 3. Area Results



![15 01 2024_02 51 58_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/d7938e0d-cd92-49ba-98ee-02bd91c18a11)




In the case of cost-optimized and performance-optimized versions, there are notable differences in the results. While the total cell area and combinational area are increased in the performance-optimized scenario, the sequential area remains constant due to the same number of flip-flops in both versions.
The total cell area is the overall physical area occupied by all the standard cells and logic elements in the design. NAND2 Equivalent Area is expressed in terms of equivalent NAND2 gates, providing a simplified measure of the design's complexity. The Combinational Area is dedicated to combinational logic, where no flip-flops are present. Sequential Area is allocated to sequential logic, which includes flip-flops or memory elements for storing data. The reason for this difference lies in the design trade-offs made during optimization. In the performance-optimized version, greater emphasis is placed on achieving higher performance,
which often involves adding more combinatorial logic to improve speed. This results in a larger total cell area and combinational area. However, the sequential area, determined by the number of flip-flops, remains the same in both versions because the flip-flop count is not a primary target for optimization in the performance-optimized scenario. Therefore, the area differences reflect the specific design goals and trade-offs between cost optimization and performance improvement.


### 4.2. Timing results

Table 4. Timing results



![15 01 2024_02 52 17_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/d2b4e1e2-34dd-4f8b-bbd6-02de93a79290)



In comparing the timing results of the cost-optimized and performance-optimized versions, the performance-optimized scenario involved reducing the clock period until the critical slack reached zero. The clock period is the duration between consecutive clock pulses. It determines the time available for processing each instruction or operation within a single clock cycle. The critical path represents the longest path through the combinational logic in the design. The critical path delay is the time it takes for signals to traverse this longest path. Critical path slack is the amount of time available on the critical path before violating the required setup time. When it reaches 0, it means that the design is operating at the maximum clock frequency it can support without violating timing constraints. The critical path route is the longest path that signals follow in a digital circuit, from their starting point to their destination. It includes the physical routing on the chip, such as wires and interconnections. This path is crucial for determining the maximum achievable clock frequency and ensuring signals meet timing constraints. In the performance-optimized scenario, the clock period was aggressively reduced to reach a critical slack of 0. This required optimizing the design for higher performance, which often involves deeper pipelines, more complex logic, or other techniques that shorten the critical path and allow for a faster clock. In contrast, the cost-optimized version may prioritize area and power efficiency over maximum clock speed, resulting in a longer clock period.


### 4.3. Power results

Table 5. Efficacy results

![15 01 2024_02 52 41_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/50964bc6-ba60-4d84-a641-080a0e1f71af)




The efficiency results of cost-optimized and performance-optimized processor designs exhibit a notable difference. In standard cases, reducing the clock cycle increases both area and power consumption. The more frequent switching of transistors in the design results in higher dynamic power. Shorter clock cycles demand quicker task completion. It leads to an aggressive use of computational resources and the use of additional components to be active simultaneously. It also further increases power consumption. However, in this specific design, power consumption decreases as the clock period is reduced. This may happen without implementing specific power-saving techniques, raising concerns about the accuracy of verification, simulation models, and unintentional optimizations introduced by the tools or the design itself. This indicates the need for a review of the design, tools, and verification procedures to ensure reliable and accurate results, as it is uncommon for power consumption to decrease with a shorter clock period without deliberate power-saving measures.


### 4.4. Gate-level verification results

![15 01 2024_02 53 06_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/a0f05542-330c-4967-8358-a9b85d8d4083)



The results of the equivalence check conducted based on Formality's reports indicate that the RTL design and the gate-level implementation produce identical logical behavior. This signifies that the gate-level implementation accurately reflects the functionality of the RTL design. These results ensure the design's correctness and alignment with the desired logical behavior

## Attachments

### A1. Questa Autocheck Summary Report

(reports/mycpu.rtl.qautocheck_report.txt, AutoCheck Verify Summary section only)


### A2. fir.asm simulation results

![15 01 2024_02 54 12_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/80865781-161c-4626-9145-952176b9e59b)



![15 01 2024_02 54 43_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/7b108802-3f05-41e6-92bd-798ed7d39f5b)


### A3. Synthesis area report

(reports/mycpu.gatelevel.area.txt)

C ost Optimized Area Report
****************************************Report : area

Design : mycpuVersion: T-2022.03 (^) - SP5- 1
Date : Mon Nov 6 12:05:03 2023**************************************** (^)
(^) Library(s) Used: (^)
(^) saed32hvt_tt1p05v25c (File: /research/cas/public/DT2_2023/lib/logic_lib/saed32hvt_tt1p05v25c.db)
(^) Number of ports: 68 (^)
Number of nets: Number of cells: 1644 (^1839)
Number of combinational cells: 1464Number of sequential cells: 180 (^)
Number of macros/black boxes: 0Number of buf/inv: 118 (^)
Number of references: 39
(^) Combinational area: 3756. (^)
Buf/Inv area: 165.701890Noncombinational area: 1280. (^)
Macro/Black Box area: 0.000000Net Interconnect area: 1467. (^)
(^) Total cell area: 5037. (^)
Total area: 6504.
(^) Area of detected synthetic parts (^)
-------------------------------- No DW parts to report!
(^) Estimated area of ungrouped synthetic parts (^)
------------------------------------------- Estimated Perc. of (^)
Module Implem. Count Area cell area------------------- ------- ----- ---------- --------- (^)
DP_OP_72J1_123_8816 str 1 75.4692 1.5%DP_OP_74J1_122_8819 str 1 1434.6427 28.5% (^)
DP_OP_81J1_126_2880 str 1 142.4994 2.8%------------------- ------- ----- ---------- --------- (^)
DP_OP Subtotal: 3 1652.6112 32.8%Total: 3 1652.6112 32.8% (^)
(^) Subtotal of datapath(DP_OP) cell area: 1652.6112 32.8% (estimated) (^)
Total synthetic cell area: 1652.6112 32.8% (estimated)
(^)
Performance Optimized Area Report
****************************************Report : area
Design : mycpuVersion: T-2022.03 (^) - SP5- 1
Date : Mon Nov 6 13:43:35 2023**************************************** (^)
(^) Library(s) Used: (^)


saed32hvt_tt1p05v25c (File: /research/cas/public/DT2_2023/lib/logic_lib/saed32hvt_tt1p05v25c.db)

(^) Number of ports: 68 (^)
Number of nets: 2886Number of cells: 2690 (^)
Number of combinational cells: 2510Number of sequential cells: 180 (^)
Number of macros/black boxes: 0Number of buf/inv: 321 (^)
Number of references: 52
(^) Combinational area: 5759. (^)
Buf/Inv area: 461.017220Noncombinational area: 1280. (^)
Macro/Black Box area: 0.000000Net Interconnect area: 1499. (^)
(^) Total cell area: 7040. (^)
Total area: 8539.
(^) Area of detected (^) synthetic parts
-------------------------------- No DW parts to report!
(^) Estimated area of ungrouped synthetic parts (^)
------------------------------------------- Estimated Perc. of (^)
Module Implem. Count Area cell area------------------- ------- ----- ---------- --------- (^)
DP_OP_72_131_8816 str 1 322.3025 4.6%DP_OP_74J1_122_8819 str 1 2410.2252 34.2% (^)
DP_OP_81J1_126_2880 str 1 401.6191 5.7%------------------- ------- ----- ---------- --------- (^)
DP_OP Subtotal: 3 3134.1467 44.5%Total: 3 3134.1467 44.5% (^)
(^) Subtotal of datapath(DP_OP) cell area: 3134.1467 44.5% (estimated) (^)
Total synthetic cell area: 3134.1467 44.5% (estimated)


### A4. Synthesis Timing Report

(reports/mycpu.gatelevel.timing.txt)

C ost Optimized Timing Report

(^) ****************************************
Report : timing - path full (^)
- -delay maxmax_paths 1 (^)
Design : mycpuVersion: T-2022.03 (^) - SP5- 1
Date : Mon Nov 6 12:05:03 2023**************************************** (^)
(^) Operating Conditions: tt1p05v25c Library: saed32hvt_tt1p05v25c (^)
Wire Load Model Mode: enclosed
(^) Startpoint: IR/ir_r_reg[10]
(^) Endpoint: PC/pc_r_reg[15](rising edge-triggered flip - flop clocked by clk)
(^) Path Group: clk(rising edge - triggered flip-flop clocked by clk)
Path Type: max
(^) Des/Clust/Port Wire Load Model Library
------------------------------------------------mycpu 8000 saed32hvt_tt1p05v25c (^)
(^) Point Incr Path
--------------------------------------------------------------------------clock clk (rise edge) 0.00 0.00
clock network delay (ideal) 0.00 0.00IR/ir_r_reg[10]/CLK (DFFARX1_HVT) 0.00 0.00 r (^)
IR/ir_r_reg[10]/QN (DFFARX1_HVT) 0.13 0.13 rU785/Y (AND3X1_HVT) 0.12 0.25 r (^)
U845/Y (AND2X1_HVT) 0.09 0.34 rU846/Y (NAND4X0_HVT) 0.12 0.45 f (^)
U848/Y (AND3X1_HVT) 0.12 0.58 fU851/Y (NAND2X0_HVT) 0.07 0.65 r (^)
U852/Y (AO221X1_HVT) 0.12 0.76 rU861/Y (OA21X1_HVT) 0.12 0.88 r (^)
U885/Y (NAND2X0_HVT) 0.11 0.99 fU886/Y (AND3X1_HVT) 0.16 1.16 f (^)
U912/Y (AOI22X1_HVT) 0.15 1.30 rU915/Y (NAND3X0_HVT) 0.07 1.37 f (^)
U920/Y (OR2X1_HVT) 0.13 1.50 fU753/Y (INVX0_HVT) 0.10 1.60 r (^)
U944/Y (AO22X1_HVT) 0.13 1.72 rU1420/Y (NAND2X0_HVT) 0.22 1.94 f (^)
U1422/Y (OAI22X1_HVT) 0.16 2.10 rU1423/Y (AO221X1_HVT) 0.09 2.19 r (^)
U1424/Y (NAND2X0_HVT) 0.10 2.29 fU1425/Y (OAI21X1_HVT) 0.13 2.43 r (^)
intadd_0/U29/CO (FADDX1_HVT) 0.15 2.58 rintadd_0/U28/CO (FADDX1_HVT) 0.14 2.72 r (^)
intadd_0/U27/CO (FADDX1_HVT) 0.14 2.86 rintadd_0/U26/CO (FADDX1_HVT) 0.14 3.00 r (^)
intadd_0/U25/CO (FADDX1_HVT) 0.14 3.14 rintadd_0/U24/CO (FADDX1_HVT) 0.14 3.28 r (^)
intadd_0/U23/CO (FADDX1_HVT) 0.14 3.42 rintadd_0/U22/CO (FADDX1_HVT) 0.14 3.56 r (^)
intadd_0/U21/CO (FADDX1_HVT) 0.14 3.70 rintadd_0/U20/CO (FADDX1_HVT) 0.14 3.83 r (^)
intadd_0/U19/CO (FADDX1_HVT) 0.14 3.97 rintadd_0/U18/CO (FADDX1_HVT) 0.14 4.11 r (^)
intadd_0/U17/CO (FADDX1_HVT) 0.14 4.25 rintadd_0/U16/CO (FADDX1_HVT) 0.14 4.39 r (^)


intadd_0/U15/CO (FADDX1_HVT) 0.14 4.53 rintadd_0/U14/CO (FADDX1_HVT) 0.14 4.67 r (^)
intadd_0/U13/CO (FADDX1_HVT) 0.14 4.81 rintadd_0/U12/CO (FADDX1_HVT) 0.14 4.95 r (^)
intadd_0/U11/CO (FADDX1_HVT) 0.14 5.09 rintadd_0/U10/CO (FADDX1_HVT) 0.14 5.23 r (^)
intadd_0/U9/CO (FADDX1_HVT) 0.14 5.37 rintadd_0/U8/CO (FADDX1_HVT) 0.14 5.51 r (^)
intadd_0/U7/CO (FADDX1_HVT) 0.14 5.65 rintadd_0/U6/CO (FADDX1_HVT) 0.14 5.79 r (^)
intadd_0/U5/CO (FADDX1_HVT) 0.14 5.93 rintadd_0/U4/CO (FADDX1_HVT) 0.14 6.07 r (^)
intadd_0/U3/CO (FADDX1_HVT) 0.14 6.21 rintadd_0/U2/S (FADDX1_HVT) 0.19 6.40 f (^)
U1187/Y (NOR4X0_HVT) 0.12 6.52 rU1191/Y (NAND4X0_HVT) 0.08 6.60 f (^)
U1192/Y (NAND2X0_HVT) 0.06 6.66 rU1193/Y (NAND2X0_HVT) 0.20 6.85 f (^)
U1280/Y (NAND2X0_HVT) 0.11 6.96 rU1281/Y (AO221X1_HVT) 0.16 7.12 r (^)
U1282/Y (NAND2X0_HVT) 0.06 7.19 fU1285/Y (NAND4X0_HVT) 0.05 7.24 r (^)
U1286/Y (AO21X1_HVT) 0.07 7.31 rU1289/Y (OR2X1_HVT) 0.08 7.38 r (^)
U1290/Y (OR3X1_HVT) 0.08 7.46 rU1370/Y (NOR4X0_HVT) 0.11 7.57 f (^)
U1371/Y (NAND3X0_HVT) 0.04 7.61 rU1372/Y (NAND3X0_HVT) 0.08 7.70 f (^)
U1375/Y (NAND4X0_HVT) 0.06 7.76 rU1376/Y (NAND2X0_HVT) 0.06 7.82 f (^)
U780/Y (AND2X1_HVT) 0.08 7.89 fU741/Y (INVX0_HVT) 0.04 7.94 r (^)
U1475/Y (AND2X1_HVT) 0.07 8.01 rU1548/Y (AO21X1_HVT) 0.06 8.07 r (^)
DP_OP_72J1_123_8816/U17/C1 (HADDX1_HVT) 0.10 8.17 rDP_OP_72J1_123_8816/U16/CO (FADDX1_HVT) 0.13 8.31 r (^)
DP_OP_72J1_123_8816/U15/CO (FADDX1_HVT) 0.14 8.45 rDP_OP_72J1_123_8816/U14/CO (FADDX1_HVT) 0.14 8.59 r (^)
DP_OP_72J1_123_8816/U13/CO (FADDX1_HVT) 0.14 8.72 rDP_OP_72J1_123_8816/U12/CO (FADDX1_HVT) 0.14 8.86 r (^)
DP_OP_72J1_123_8816/U11/CO (FADDX1_HVT) 0.14 9.00 rDP_OP_72J1_123_8816/U10/CO (FADDX1_HVT) 0.14 9.14 r (^)
DP_OP_72J1_123_8816/U9/CO (FADDX1_HVT) 0.14 9.28 rDP_OP_72J1_123_8816/U8/CO (FADDX1_HVT) 0.14 9.42 r (^)
DP_OP_72J1_123_8816/U7/CO (FADDX1_HVT) 0.14 9.56 rDP_OP_72J1_123_8816/U6/CO (FADDX1_HVT) 0.14 9.70 r (^)
DP_OP_72J1_123_8816/U5/CO (FADDX1_HVT) 0.14 9.84 rDP_OP_72J1_123_8816/U4/CO (FADDX1_HVT) 0.14 9.98 r (^)
DP_OP_72J1_123_8816/U3/CO (FADDX1_HVT) 0.13 10.11 rU1478/Y (XOR2X1_HVT) 0.13 10.25 f (^)
U1479/Y (NAND2X0_HVT) 0.04 10.29 rU1484/Y (NAND3X0_HVT) 0.08 10.37 f (^)
PC/pc_r_reg[15]/D (DFFARX1_HVT) 0.01 10.38 fdata arrival time 10.38
(^) clock clk (rise edge) 11.00 11.00
clock network delay (ideal) 0.00 11.00PC/pc_r_reg[15]/CLK (DFFARX1_HVT) 0.00 11.00 r (^)
library setup time data required time 10.93-0.07 10.93 (^)
--------------------------------------------------------------------------data required time 10.93
data arrival time ---------------------------------------------------------------------------10.38 (^)
slack (MET) 0.55
Performance Optimized Timing Report
****************************************Report : timing
- -path fulldelay max (^)
(^) Design : mycpu-max_paths 1
Version: T-2022.03-SP5- 1


Date : Mon Nov 6 13:43:35 2023**************************************** (^)
(^) Operating Conditions: tt1p05v25c Library: saed32hvt_tt1p05v25c (^)
Wire Load Model Mode: enclosed
(^) Startpoint: IR/ir_r_reg[10]
(^) Endpoint: PC/pc_r_reg[10](rising edge-triggered flip - flop clocked by clk)
(^) Path Group: clk(rising edge - triggered flip-flop clocked by clk)
Path Type: max
(^) Des/Clust/Port Wire Load Model Library
------------------------------------------------mycpu 8000 saed32hvt_tt1p05v25c (^)
(^) Point Incr Path
-----------------------------------------------------------clock clk (rise edge) 0.00 0.00
clock network delay (ideal) 0.00 0.00IR/ir_r_reg[10]/CLK (DFFASX1_HVT) 0.00 0.00 r (^)
IR/ir_r_reg[10]/QN (DFFASX1_HVT) 0.17 0.17 rU1425/Y (OR2X1_HVT) 0.10 0.28 r (^)
U1787/Y (NAND4X0_HVT) 0.09 0.37 fU1108/Y (OR2X1_HVT) 0.10 0.47 f (^)
U1107/Y (NAND4X0_HVT) 0.05 0.52 rU1581/Y (AO21X1_HVT) 0.12 0.64 r (^)
U1672/Y (NAND2X0_HVT) 0.09 0.73 fU1906/Y (NAND2X0_HVT) 0.07 0.80 r (^)
U1131/Y (INVX0_HVT) 0.05 0.85 fU844/Y (AND2X1_HVT) 0.07 0.92 f (^)
U784/Y (NBUFFX2_HVT) 0.07 0.98 fU1907/Y (NAND2X0_HVT) 0.05 1.03 r (^)
U1914/Y (NAND4X0_HVT) 0.08 1.12 fU934/Y (OR2X4_HVT) 0.14 1.25 f (^)
U2142/Y (XOR2X1_HVT) 0.18 1.44 rU1433/Y (NAND2X0_HVT) 0.09 1.53 f (^)
U1199/Y (OAI22X1_HVT) 0.12 1.65 rU2236/S (FADDX1_HVT) 0.21 1.86 f (^)
U907/Y (XNOR3X2_HVT) 0.25 2.11 rU872/CO (FADDX1_HVT) 0.19 2.30 r (^)
U986/Y (OR2X1_HVT) 0.09 2.39 rU868/Y (XOR2X2_HVT) 0.13 2.52 f (^)
U721/Y (OR2X1_HVT) 0.07 2.59 fU1603/Y (AND2X1_HVT) 0.06 2.64 f (^)
U2293/Y (NAND2X0_HVT) 0.04 2.68 rU2294/Y (OR2X1_HVT) 0.06 2.75 r (^)
U2297/Y (NAND2X0_HVT) 0.05 2.80 fU1677/Y (AOI21X1_HVT) 0.10 2.90 r (^)
U908/Y (OR2X2_HVT) 0.09 2.99 rU969/Y (AND3X1_HVT) 0.12 3.10 r (^)
U802/Y (AND2X1_HVT) 0.08 3.18 rU801/Y (AND3X1_HVT) 0.08 3.26 r (^)
U1548/Y (NAND4X0_HVT) 0.08 3.34 fU2655/Y (OAI22X1_HVT) 0.12 3.46 r (^)
U1479/Y (OA21X1_HVT) 0.11 3.57 rU1466/Y (NAND2X0_HVT) 0.07 3.64 f (^)
U1452/Y (AND2X1_HVT) 0.07 3.70 fU1451/Y (NAND2X0_HVT) 0.05 3.76 r (^)
U1453/Y (OA21X1_HVT) 0.10 3.86 rU1454/Y (OA21X1_HVT) 0.09 3.96 r (^)
U1118/Y (OAI21X2_HVT) 0.14 4.10 fU1149/Y (AO21X1_HVT) 0.10 4.20 f (^)
U1148/Y (XOR2X1_HVT) 0.12 4.32 rU2679/Y (AO21X1_HVT) 0.10 4.41 r (^)
PC/pc_r_reg[10]/D (DFFARX1_HVT) 0.01 4.43 rdata arrival time 4.43
(^) clock clk (rise edge) 4.50 4.50
clock network delay (ideal) 0.00 4.50PC/pc_r_reg[10]/CLK (DFFARX1_HVT) 0.00 4.50 r (^)
library setup time data required time 4.43-0.07 4.43 (^)


-----------------------------------------------------------data required time 4.43

data arrival time ------------------------------------------------------------4.43 (^)
slack (MET) 0.00


### A5. Power consumption report

(reports/mycpu.gatelevel.power.txt)

(^)
C ost Optimized Power Consumption Report
****************************************Report : power
(^) Design : mycpu-analysis_effort low
Version: TDate : Mon Nov 6 12:05:03 2023-2022.03-SP5- (^1)
****************************************
(^) Library(s) Used: (^)
(^) saed32hvt_tt1p05v25c (File: /research/cas/public/DT2_2023/lib/logic_lib/saed32hvt_tt1p05v25c.db)
(^) Operating Conditions: tt1p05v25c Library: saed32hvt_tt1p05v25c (^)
Wire Load Model Mode: enclosed
(^) Design Wire Load Model Library (^)
------------------------------------------------mycpu 8000 saed32hvt_tt1p05v25c (^)
(^) Global Operating Voltage = 1.05 (^)
Power Voltage Units = 1V-specific unit information :
Capacitance Units = 1.000000ffTime Units = 1ns
Dynamic Power Units = 1uW (derived from V,C,T units)Leakage Power Units = 1pW
(^) Attributes (^)
----------i - Including register clock pin internal power (^)
(^) Cell Internal Power = 158.9729 uW (88%)
Net Switching Power = 22.3651 uW (12%)---------
Total Dynamic Power = 181.3381 uW (100%)
(^) Cell Leakage Power = 16.3367 uW (^)
(^) Internal Switching Leakage Total
Power Group Power Power Power Power ( % ) Attrs-------------------------------------------------------------------------------------------------- (^)
io_pad 0.0000 0.0000 0.0000 0.0000 ( 0.00%)memory 0.0000 0.0000 0.0000 0.0000 ( 0.00%) (^)
black_box 0.0000 0.0000 0.0000 0.0000 ( 0.00%)clock_network 110.7178 0.0000 0.0000 110.7178 ( 56.01%) i (^)
register 2.8499 1.0772 6.4733e+06 10.4005 ( 5.26%)sequential 0.0000 0.0000 0.0000 0.0000 ( 0.00%) (^)
combinational 45.4052 21.2879 9.8633e+06 76.5564 ( 38.73%)-------------------------------------------------------------------------------------------------- (^)
Total 158.9729 uW 22.3651 uW 1.6337e+07 pW 197.6747 uW


Performance Optimized Power Consumption Report
****************************************Report : power

(^) Design : mycpu-analysis_effort low
Version: TDate : Mon Nov 6 13:43:36 2023-2022.03-SP5- (^1)
****************************************
(^) Library(s) Used: (^)
(^) saed32hvt_tt1p05v25c (File: /research/cas/public/DT2_2023/lib/logic_lib/saed32hvt_tt1p05v25c.db)
(^) Operating Conditions: tt1p05v25c Library: saed32hvt_tt1p05v25c (^)
Wire Load Model Mode: enclosed
(^) Design Wire Load Model Library (^)
------------------------------------------------mycpu 8000 saed32hvt_tt1p05v25c (^)
(^) Global Operating Voltage = 1.05 (^)
Power Voltage Units = 1V-specific unit information :
Capacitance Units = 1.000000ffTime Units = 1ns
Dynamic Power Units = 1uW (derived from V,C,T units)Leakage Power Units = 1pW
(^) Attributes (^)
----------i - Including register clock pin internal power (^)
(^) Cell Internal Power = 132.3817 uW (92%)
Net Switching Power = 11.9805 uW (8%)---------
Total Dynamic Power = 144.3622 uW (100%)
(^) Cell Leakage Power = 21.9451 uW (^)
(^) Internal Switching Leakage Total
Power Group Power Power Power Power ( % ) Attrs-------------------------------------------------------------------------------------------------- (^)
io_pad 0.0000 0.0000 0.0000 0.0000 ( 0.00%)memory 0.0000 0.0000 0.0000 0.0000 ( 0.00%) (^)
black_box 0.0000 0.0000 0.0000 0.0000 ( 0.00%)clock_network 111.2006 0.0000 0.0000 111.2006 ( 66.86%) i (^)
register 3.6496 1.0675 6.4956e+06 11.2127 ( 6.74%)sequential 0.0000 0.0000 0.0000 0.0000 ( 0.00%) (^)
combinational 17.5314 10.9130 1.5449e+07 43.8939 ( 26.39%)-------------------------------------------------------------------------------------------------- (^)
Total 132.3817 uW 11.9805 uW 2.1945e+07 pW 166.3072 uW


### A6. Logic equivalence check report

(reports/mycpu.gatelevel.lec_status.txt)

(^) **************************************************
Report : status
(^) Reference : r:/WORK/mycpu (^)
Implementation : i:/WORK/mycpuVersion : U-2022.12
Date : Mon Nov 6 13:55:31 2023************************************************** (^)
(^) ***************************** Synopsys Auto Setup Summary ****************************** (^)
(^) !!! Synopsys Auto Setup Mode was enabled. !!! (^)
!!! Verification results are valid assuming the following setup constraints: !!!
(^) ### RTL (^) Interpretation Setup
set hdlin_ignore_parallel_case falseset hdlin_ignore_full_case false
set hdlin_error_on_mismatch_message falseset hdlin_ignore_embedded_configuration true (^)
(^) ### Undriven Signal Handling Setup (^)
set verification_set_undriven_signals synthesis
(^) ### Test Logic Setup (^)
set verification_verify_directly_undriven_output falseFor details see report_dont_verify_points and report_constants (^)
(^) For further details on Synopsys Auto Setup Mode: Type man synopsys_auto_setup (^)
****************************************************************************************
(^) ********************************* Verification Results ********************************* (^)
Verification SUCCEEDED ATTENTION: synopsys_auto_setup mode was enabled. (^)
(^) ----------------------------------------------------------See Synopsys Auto Setup Summary for details. (^)
Reference design: r:/WORK/mycpuImplementation design: i:/WORK/mycpu (^)
214 Passing compare points---------------------------------------------------------------------------------------- (^)
Matched Compare Points BBPin Loop BBNet Cut Port DFF LAT TOTAL---------------------------------------------------------------------------------------- (^)
Passing (equivalent) 0 0 0 0 34 180 0 214


