
# Introduction

The project involves the design and implementation of a processor core. This processor core is based on a specified processor architecture. The project aims to create a functional and efficient processor core that can execute instructions as per the defined architecture. The project design is focused on creating a 16-bit processor core, implementing its architecture using SystemVerilog, and generating a synthesized register-level model. Verification tasks involved simulating the core to ensure it correctly executed instructions according to the architecture's specifications. Gate- level implementation is used to optimize the design for area, speed, and power through logic synthesis. SystemVerilog is the primary hardware description language used for modeling the processor core. It is used to describe the behavior and structure of the core's components.




![1702487518514](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/155032a8-7767-4dd4-9af1-e71077aec618)

Figure 1. A block diagram of the processor core design (From mycpu_project_specification_202 3 )



Based on the student number, the design requirements are set (clock period and XXL instruction). According to my student number (2305411), the clock period is 11 ns. And the XXL instruction is

R0 = R0 + (R1 * R2). [Multiply-Accumulate].


# Design of the control part of the mycpu CPU

## 2.1. Instruction decoder implementation

The implementation of the Control Unit (CU) in the myCPU involves creating a finite-state machine that controls the instruction fetch-and-execute cycle and decodes control signals for various components. The CU is responsible for managing the processor's state transitions and instruction decoding. It is designed to support a range of instructions, including special cases like the HALT (HAL) instruction and more complex instructions. The implementation is divided into several key steps, starting with the establishment of the basic state machine and gradually expanding to include instruction decoding logic, error handling, and support for specific instructions. The goal of the CU implementation is to ensure proper control of the processor's operation and the execution of instructions by the specified architecture.

![15 01 2024_02 48 36_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/397f44bf-c4d4-40d6-af1c-a7bdd349d896)

Figure 2. ASM Diagram (From mycpu_project_specification_202 3 )


## 2.2. Implementation of the XXL special instruction

The XXL instruction is the "Multiply-Accumulate" operation (R0 = R0 + (R1*R2)). It updates the value in a register by adding the result of multiplying two other registers. The implementation involves transferring data between registers, performing multiplication, adding the result, and storing it back. This operation can be performed in multiple stages. The state machine implements the control algorithm represented by the algorithmic state machine, as shown in the chart below.


![15 01 2024_02 49 21_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/27ed0015-5161-43f8-87b5-ed745b725e0a)


Figure 3. ASM diagram for the XXL instruction.

The instruction decoding logic are defined in the table below. This is implemented in the combinational logic process decoder in the RTL code. Don't-care values are shown as X.

Table 1. State Table of XXL Instruction

![15 01 2024_02 49 50_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/1e45ccfa-d86a-4801-9f62-252b481588b9)


Verification Plan
The verification plan checks if the processor behaves correctly when it changes from one state to another. It uses clock signals to control the timing and compares the expected results to the actual results, reporting any discrepancies as errors. This verification process has five stages. The first one is a reset test. This test verifies that after a reset, all registers and components are in a well-defined state. The state after reset is confirmed by using concurrent assertions, which are conditions that must hold true after the reset operation. In the second test, verify the response of the system when provided with instruction words for every opcode except HAL, XXL, and illegal and random operands. Then opcode test with HAL opcode. It confirms the behavior of the system when it receives the HAL opcode. In an opcode test with an illegal opcode, check how the system responds to an illegal opcode. The inputs are set to an illegal opcode, and the system's outputs are compared to expected values. The state machine's behavior during the execution of an illegal opcode is confirmed using concurrent
assertions. Finally, opcode Test with XXL opcode (Multiply-Accumulate). In this test, verify the operation of the system that performs a multiply-accumulate operation: R0 = R0 + (R1 * R2). Inputs are configured with the XXL opcode. The expected output is calculated based on the operation R0 = R0 + (R1 * R2), and the system's response is compared to the expected result.


# mycpu verification

## 3.1. RTL code check results

According to the autocheck results, there were some issues with the RTL code. These errors relate to case statements, potential arithmetic overflow, unreachable code, and stuck-at faults in registers or latches.

![15 01 2024_02 50 31_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/9092c490-ddec-4bd0-af8f-ed9a497c2cdb)


Figure 4. Autocheck Results.

CASE_DEFAULT (Default Case Item Followed): This error arises when a case statement includes a default item. To resolve this need, ensure that the default or other item is used as intended without creating sensitization issues. ARITH_OVERFLOW_VAL (Arithmetic Overflow of a Value): This error happens when RHS
subexpressions exceed the range of the LHS variable. To solve this, we need arithmetic expressions to prevent values from overflowing the target variable's range. BLOCK_UNREACHABLE (Block of Code is Unreachable): This error indicates the code blocks that cannot be reached during program execution. To solve this, we need to eliminate unreachable sections. REG_STUCK_AT (Register/latch has a Stuck-at Fault): This error indicates registers or latches with one or more bits stuck at a constant value, which can lead to unexpected behavior. To solve this issue, we need to find the root cause (such as improper initialization or data flow).


## 3.2. The results of the functional verification

### 3.2.1. fir.asm Simulation


![15 01 2024_02 50 55_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/3856bd3c-23f0-471a-804c-ed07c433a3fa)





A "fir.asm simulation" refers to the process of running and testing an assembly language program called "fir.asm" within a simulation environment. This program implements a 5-tap Finite Impulse Response (FIR) filter, a common signal processing algorithm. During the simulation, input data is processed using predefined coefficients, and the simulation results are observed to confirm that the FIR filter operates correctly. The simulation transcript displays expected results from the I/O, as above. The simulation results prove that the program is functioning successfully on the mycpu.


### 3.2.2. xxl_test.asm Simulation


![15 01 2024_02 51 26_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/228ce3a4-5d4b-4eff-b627-bfc7ac61411f)




In the xxl_test.asm simulation, convert the xxl_test.asm file into the machine code file machincode.inc and run the RTL simulation of the xxl_test.asm. In this simulation, the R0 register is loaded with 1, the R1 register is loaded with 2, and the R2 register is loaded with 3. At first, R1*R2 results move to R15. Then the result of R0+R15 moved to the R0 register.
```
R15= R1*R2=2*3=6
R0=R0+R15=1+6=7
```
At the end of the simulation, R0 holds the value according to the equation “R0=R0+(R1*R2)”. It proves that the functionality of the system is successful.


#  Implementation of the mycpu design

## 4.1. Area results

Table 3. Area Results



![15 01 2024_02 51 58_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/d7938e0d-cd92-49ba-98ee-02bd91c18a11)




In the case of cost-optimized and performance-optimized versions, there are notable differences in the results. While the total cell area and combinational area are increased in the performance-optimized scenario, the sequential area remains constant due to the same number of flip-flops in both versions.
The total cell area is the overall physical area occupied by all the standard cells and logic elements in the design. NAND2 Equivalent Area is expressed in terms of equivalent NAND2 gates, providing a simplified measure of the design's complexity. The Combinational Area is dedicated to combinational logic, where no flip-flops are present. Sequential Area is allocated to sequential logic, which includes flip-flops or memory elements for storing data. The reason for this difference lies in the design trade-offs made during optimization. In the performance-optimized version, greater emphasis is placed on achieving higher performance,
which often involves adding more combinatorial logic to improve speed. This results in a larger total cell area and combinational area. However, the sequential area, determined by the number of flip-flops, remains the same in both versions because the flip-flop count is not a primary target for optimization in the performance-optimized scenario. Therefore, the area differences reflect the specific design goals and trade-offs between cost optimization and performance improvement.


## 4.2. Timing results

Table 4. Timing results



![15 01 2024_02 52 17_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/d2b4e1e2-34dd-4f8b-bbd6-02de93a79290)



In comparing the timing results of the cost-optimized and performance-optimized versions, the performance-optimized scenario involved reducing the clock period until the critical slack reached zero. The clock period is the duration between consecutive clock pulses. It determines the time available for processing each instruction or operation within a single clock cycle. The critical path represents the longest path through the combinational logic in the design. The critical path delay is the time it takes for signals to traverse this longest path. Critical path slack is the amount of time available on the critical path before violating the required setup time. When it reaches 0, it means that the design is operating at the maximum clock frequency it can support without violating timing constraints. The critical path route is the longest path that signals follow in a digital circuit, from their starting point to their destination. It includes the physical routing on the chip, such as wires and interconnections. This path is crucial for determining the maximum achievable clock frequency and ensuring signals meet timing constraints. In the performance-optimized scenario, the clock period was aggressively reduced to reach a critical slack of 0. This required optimizing the design for higher performance, which often involves deeper pipelines, more complex logic, or other techniques that shorten the critical path and allow for a faster clock. In contrast, the cost-optimized version may prioritize area and power efficiency over maximum clock speed, resulting in a longer clock period.


## 4.3. Power results

Table 5. Efficacy results

![15 01 2024_02 52 41_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/50964bc6-ba60-4d84-a641-080a0e1f71af)




The efficiency results of cost-optimized and performance-optimized processor designs exhibit a notable difference. In standard cases, reducing the clock cycle increases both area and power consumption. The more frequent switching of transistors in the design results in higher dynamic power. Shorter clock cycles demand quicker task completion. It leads to an aggressive use of computational resources and the use of additional components to be active simultaneously. It also further increases power consumption. However, in this specific design, power consumption decreases as the clock period is reduced. This may happen without implementing specific power-saving techniques, raising concerns about the accuracy of verification, simulation models, and unintentional optimizations introduced by the tools or the design itself. This indicates the need for a review of the design, tools, and verification procedures to ensure reliable and accurate results, as it is uncommon for power consumption to decrease with a shorter clock period without deliberate power-saving measures.


## 4.4. Gate-level verification results

![15 01 2024_02 53 06_REC](https://github.com/shalikadulaj/Design-and-Implementation-of-a-Processor-Core/assets/58818511/a0f05542-330c-4967-8358-a9b85d8d4083)



The results of the equivalence check conducted based on Formality's reports indicate that the RTL design and the gate-level implementation produce identical logical behavior. This signifies that the gate-level implementation accurately reflects the functionality of the RTL design. These results ensure the design's correctness and alignment with the desired logical behavior

