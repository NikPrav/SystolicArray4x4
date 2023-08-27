# 4x4 Systolic Array Implementation in Verilog

To excecute the program, ensure that you have iverilog installed in your system. Run the following command to automatically generate arrays and compare the results:

`python array_gen.py`

# Architecture and Flow

The system is based on Output-Stationary Implementation of Systolic Array, slightly different from a TPU. It consists of 2 memory banks for input matrices, a memory bank for the output matrix and instructions, along with the central component - a 4x4 array of Processing Elements capable of Fixed-Point 16-bit Matrix Multiplication, with 8 bits fractional. 

# References

* [DSP VLSI Systems, Shao-Yi Chen](http://media.ee.ntu.edu.tw/courses/dspdesign/16F/slide/7_systolic_architecture_design.pdf)
* [Why Systolic Architectures, H T kung](https://www.eecs.harvard.edu/~htk/publication/1982-kung-why-systolic-architecture.pdf)
* [Understanding Matrix Multiplication in a weight-stationary Systolic Architecture](https://www.telesens.co/2018/07/30/systolic-architectures/)
* [Multiplying Matrices Efficiently in a Scalable Systolic Architecture](https://hparch.gatech.edu/papers/bahar_2020_meissa.pdf)