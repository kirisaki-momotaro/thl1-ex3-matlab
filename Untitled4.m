clear all;
close all;

N=100; %number of symbols
input = (sign(randn(4*N, 1)) + 1)/2; 



input=rot90(input);
input(1:4)
gray_conversion_Table = [
    0 0 0 0;
    0 0 0 1;
    0 0 1 1;
    0 0 1 0;
    0 1 1 0;
    0 1 1 1;
    0 1 0 1;
    0 1 0 0;
    1 1 0 0;
    1 1 0 1;
    1 1 1 1;
    1 1 1 0;
    1 0 1 0;
    1 0 1 1;
    1 0 0 1;
    1 0 0 0
];

bin_symbols = reshape(input, 4, []).'; 
for i=1:length(input)/4
    bin_symbol=bin_symbols(i,:)
    dec_symbol=bi2de(bin_symbol,'left-msb')
    gray_bin_symbol = gray_conversion_Table(dec_symbol +1, :) % Convert binary to decimal and lookup corresponding Gray code
    bin_symbols(i,:)=gray_bin_symbol;
    gray_dec_symbol=bi2de(gray_bin_symbol,'left-msb')
    
    num=(2*pi*gray_dec_symbol)/16
    
    output(1,i)=cos(num);
    output(2,i)=sin(num);
    output(1,i)
    output(2,i)
end 
bin_symbols(1,:);
output(1,1);
output(2,1);