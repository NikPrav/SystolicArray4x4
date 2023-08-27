import numpy as np

A = np.random.randint(1,5, size=(8,4))
B = np.random.randint(1,5, size=(8,4))
O1 = np.matmul(A[:4,:],B[:4,:])
O2 = np.matmul(A[4:,:],B[4:,:])
O = np.append(O1,O2)
print(A)
print(B)
print(O)
A = A.flatten()
B = B.flatten()
O = O.flatten()

I = 4;

with open("dataA.txt",'w') as fp:
    for i in range(A.shape[0]):
        fp.write(str(bin(A[i]))[2:] + "\n")
    for i in range(256 - A.shape[0]):
        fp.write("0\n")

with open("dataB.txt",'w') as fp:
    for i in range(B.shape[0]):
        fp.write(str(bin(B[i]))[2:] + "\n")
    for i in range(256 - B.shape[0]):
        fp.write("0\n")

with open("dataO.txt",'w') as fp:
    for i in range(O.shape[0]):
        fp.write(str(bin(O[i]))[2:] + "\n")
    for i in range(256 - O.shape[0]):
        fp.write("0\n")

with open("dataI.txt",'w') as fp:
    fp.write(str(str(bin(I))[2:] + "\n"))
    fp.write(str(str(bin(I))[2:] + "\n"))
    for i in range(254):
        fp.write("0\n")