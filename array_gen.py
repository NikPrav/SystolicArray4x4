"""
Author: Nikhil Praveen ((nikhil.pravin@gmail.com))
array_gen.py (c) 2023
Organisation: Indian Institute of Technology, Hyderabad
Desc: Script to generate array and compare results
Modified:  2023-08-27
"""


import numpy as np
import os

# Generating number of instructions
# Keeping it between 1 and 5
i = np.random.randint(1,5)

MEM_SIZE = 256

print(f"Number of instructions:{i}")

# Generating Instructions
# Keeping array sizes between 4 and 16
instr = np.random.randint(4,16,i)
O = [];
A = [];
B = [];

# Generating Matrices
for ins in instr:
    A1 = np.random.randint(1,5, size=(4,ins))
    B1 = np.random.randint(1,5, size=(ins,4))
    O1 = np.matmul(A1,B1)
    A.extend(A1.flatten().tolist())
    B.extend(B1.flatten().tolist())
    O.extend(O1.flatten().tolist())



# A = np.random.randint(1,5, size=(8,4))
# B = np.random.randint(1,5, size=(8,4))
# O1 = np.matmul(A[:4,:],B[:4,:])
# O2 = np.matmul(A[4:,:],B[4:,:])
# O = np.append(O1,O2)
# print(A)
# print(B)
# print(O)
# A = A.flatten()
# B = B.flatten()
# O = O.flatten()

# I = 4;

with open("dataA.txt",'w') as fp:
    for i in range(len(A)):
        fp.write(str(bin(A[i]))[2:] + "\n")
    for i in range(MEM_SIZE - len(A)):
        fp.write("0\n")

with open("dataB.txt",'w') as fp:
    for i in range(len(B)):
        fp.write(str(bin(B[i]))[2:] + "\n")
    for i in range(MEM_SIZE - len(B)):
        fp.write("0\n")

with open("dataO.txt",'w') as fp:
    for i in range(len(O)):
        fp.write(str(bin(O[i]))[2:] + "\n")
    for i in range(MEM_SIZE - len(O)):
        fp.write("0\n")

with open("dataI.txt",'w') as fp:
    # fp.write(str(str(bin(I))[2:] + "\n"))
    # fp.write(str(str(bin(I))[2:] + "\n"))
    for i in range(instr.shape[0]):
        fp.write(str(bin(instr[i]))[2:] + "\n")
    for i in range(MEM_SIZE - instr.shape[0]):
        fp.write("0\n")

# Running verilog code
code = "iverilog -o top_module tb_CU.v CU.v mem_array.v mem_output.v mem.v PE.v && vvp top_module"
os.system(code)

ar = []
# Compare arrays
with open("dataO_sim.txt",'r') as fp:
    lines = fp.readlines()
    
    for line in lines:
        if(line.strip()[0] == '0'):
            ar.append(int(line,2))
    
O = np.array(O)
ar = np.array(ar[:O.shape[0]])

if (np.array_equal(O,ar)):
    print("Arrays match up")
else:
    print("Issue")