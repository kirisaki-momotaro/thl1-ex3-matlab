function [ output ] = bits_to_PSK_16( input )

input=rot90(input);

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
    bin_symbol=bin_symbols(i,:);
    dec_symbol=bi2de(bin_symbol,'left-msb');
    gray_bin_symbol = gray_conversion_Table(dec_symbol +1, :); % Convert binary to decimal and lookup corresponding Gray code
    bin_symbols(i,:)=gray_bin_symbol;
end 
output = reshape(bin_symbols.', [], 1);


end

