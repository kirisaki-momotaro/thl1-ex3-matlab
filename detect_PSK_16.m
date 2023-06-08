function [output] =  detect_PSK_16(input)

%input = rot90(input); % Convert input to column vector

bin_conversion_Table = [
    0 0 0 0;
    0 0 0 1;
    0 0 1 0;
    0 0 1 1;
    0 1 0 0;
    0 1 0 1;
    0 1 1 0;
    0 1 1 1;
    1 0 0 0;
    1 0 0 1;
    1 0 1 0;
    1 0 1 1;
    1 1 0 0;
    1 1 0 1;
    1 1 1 0;
    1 1 1 1
];


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

%output = zeros(numel(input) * 4, 1); % Preallocate output vector
output=[];

for i = 1:length(input)
    symbol_in = input(1,i);
    symbol_qn = input(2,i);
    
    angles_in = cos((0:15) * 2 * pi / 16);  % Compute angles for the 16-PSK 
    angles_qn = sin((0:15) * 2 * pi / 16);  % Compute angles for the 16-PSK constellation
    distances = sqrt((symbol_in - angles_in).^2 + (symbol_qn - angles_qn).^2);
    
    [~, index] = min(distances) ; % Find the index of the nearest neighbor
    
    gray_bin=bin_conversion_Table(index,:);   
    [~, dec_symbol] = ismember(gray_bin, gray_conversion_Table, 'rows');    
    bin=bin_conversion_Table(dec_symbol,:);    
    output = [output bin];
    
    
end




end

