clear all
close all




%A2 16-PSK
N=100; %number of symbols
bit_seq = (sign(randn(4*N, 1)) + 1)/2; 
bit_seq(1:4)
X = bits_to_PSK_16(bit_seq); %random symbols

X

uniqueValues = unique(X); % Get unique values
numUniqueValues = numel(uniqueValues); % Count the number of unique values

disp('Unique Values:');
disp(uniqueValues);
disp('Number of Unique Values:');
disp(numUniqueValues);











