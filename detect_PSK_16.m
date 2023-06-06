function [output] =  detect_PSK_16(input)

input = rot90(input); % Convert input to column vector

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
    symbol_in = input(i,1);
    symbol_qn = input(i,2);
    
    angles_in = cos((0:15) * 2 * pi / 16);  % Compute angles for the 16-PSK 
    angles_qn = sin((0:15) * 2 * pi / 16);  % Compute angles for the 16-PSK constellation
    distances = sqrt((symbol_in - angles_in).^2 + (symbol_qn - angles_qn).^2);     
    [~, index] = min(distances);  % Find the index of the nearest neighbor

    gray_bin_symbol = gray_conversion_Table(index,:);
    output = [output gray_bin_symbol];
end




end

