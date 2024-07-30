**IMPLEMENTATION OF A DIGITAL MLP**

The model is adopted from the paper:
1. Minhao Yang, _A 1μW voice activity detector using analog feature extraction and digital deep neural network_, ISSCC2018


**PROGRAM FLOW EXPLAINATION**

1.	Wait 85ms so DMEM are loaded. Here model ~10 cycles, but in real design, 42500 cycles of 500kHz
![image](https://github.com/user-attachments/assets/ad7ed595-faf5-49b4-947b-7062ae2fe9d5)

 
2.	Memory
-	WMEM [4605:0] access pattern: from 0 to 4605,
-	DMEM [1007:0]	 access pattern:	block-of-16 9-bit data, in the cycle of 0 3 6, 1 4 0, 2 5 1, 3 6 2, 4 0 3, 5 1 4, 6 2 5

3.	First layer
-	Read DMEM for d9, Read WMEM for w
-	After each ~60 cycles, we complete the convolution for 1 neuron. Set rf_wen to 1 to write to 84-bit RF, set g_reg_rst to 0 to reset the gated register for new convolution of next neuron.
-	Repeat previous step for 48 times
![image](https://github.com/user-attachments/assets/2bcabc29-300a-4f71-a069-27b91738a9c3)
 
4.	Second layer
-	Read RF from 0 to 59 for d1
-	Repeat step 2 and 3 of first layer, but numbers are 48 and 24

5.	Third layer
-	Read RF from 60 to 83 for d1
-	Repeat step 2 and 3 of first layer, but numbers are 24 and 11

6.	Output layer
-	Read RF from 0 to 10 for d1
-	First half, add to gated register. Second half, subtract from gated register. Note that value at rf_addr = 0 and wmem_addr = 4594 was used for 2 times, but one with lo2 = 0 and one with lo2 =1, thus they will cancel each other. 
![image](https://github.com/user-attachments/assets/b6db8eb5-215e-47b3-a0f5-dacd8538b889)

7.	Classification

8.	Wait for 10ms for the next classification. Repeat step 1 to 6.
![image](https://github.com/user-attachments/assets/c664b3fb-a928-488a-9aec-9266312d7c58)


