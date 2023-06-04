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

output = zeros(numel(input) * 4, 1); % Preallocate output vector

for i = 1:length(input)
    symbol = input(i,1);
    angles = cos((0:15) * 2 * pi / 16);  % Compute angles for the 16-PSK constellation
    distances = abs(angles - symbol);  % Compute distances to each constellation point
    [~, index] = min(distances)  % Find the index of the nearest neighbor

    gray_bin_symbol = gray_conversion_Table(index);
    output1((i - 1) * 4 + 1:i * 4) = gray_bin_symbol;
end
for i = 1:length(input)
    symbol = input(i,2);
    angles = sin((0:15) * 2 * pi / 16);  % Compute angles for the 16-PSK constellation
    distances = abs(angles - symbol);  % Compute distances to each constellation point
    [~, index] = min(distances)  % Find the index of the nearest neighbor

    gray_bin_symbol = gray_conversion_Table(index);
    output2((i - 1) * 4 + 1:i * 4) = gray_bin_symbol;
end

output = [output1 output2] % Transpose output to row vector

output = output(1:4:end);

end

