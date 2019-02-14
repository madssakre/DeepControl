

					DeepControl

						v 1.0

				      19-02-2019
				      
				      
				     Mads Vinding

INTRODUCTION

By designing a high number of pulse inputs, e.g., desired magnetization profiles, and then computing the pulses that best achieve the desired magnetization, we have shown that these informations can be used to train a neural network by deep learning, such that the network mimics the pulse computation tool, and when presented to a similar input, outputs a pulse very close to what the computation tool would output.

We call this DeepControl and it adheres to the convention of using optimal control theory or similar optimization strategies to compute and optimize a large number of controls, in this case, RF pulse controls, for MRI.

The method is described in Ref. [1]. We have used two target methods, where the first is described in Ref. [2], and the second in Ref. [3]. Both are part of "blOCh" which can be found at Ref. [4].

REMARKS

The nature of this method is vast training libraries of thousands and thousands RF pulses and their associated inputs used to calculate the pulses. These libraries are extensive in size, and today not something one would typically generate on commodity hardware (although it is not impossible). The networks, as we have developed in MATLAB, also occupy a decent amount of space.

Hence, this repository currently only support scripts and example data that can be used to reproduce the method. The users will have to, by own hand, setup the large scale optimizations on their own computer framework, and will also have to design the input by own hand. The example data files can be used to check how exactly the setup for the proposed method should be, in case it is followed completely. The example scripts contain the essence of how everything was run on our system(s).



REFERENCES

1. Vinding MS, Skyum B, Sangill R, Lund TE. Ultra-fast (milliseconds), multi-dimensional RF pulse design with deep learning, MRM 2019 (accepted) or arXiv:1811.02273v3

2. Vinding MS, Guérin B, Vosegaard T, Nielsen NC. Local SAR, global SAR, and power-constrained large-flip-angle pulses with optimal control and virtual observation points. Magn. Reson. Med. 2017;77:374–384 doi: 10.1002/mrm.26086.

3. Hansen PC. Regularization Tools version 4.0 for Matlab 7.3. Numerical Algorithms 2007;46:189–194 doi: 10.1007/s11075-007-9136-9.

4. https://github.com/madssakre/blOCh.



