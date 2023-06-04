clear all
close all




%A2 16-PSK
N=100; %number of symbols
bit_seq = (sign(randn(4*N, 1)) + 1)/2; 
bit_seq(1:4)
X = bits_to_PSK_16(bit_seq); %random symbols

X(1:4)













