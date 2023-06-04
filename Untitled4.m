clear all;

close all;
bitStream = [1 0 1 1 0 1 0 0 1 1 0 0 1 0 1 0]; % Example bit stream

% Reshape the bit stream into a matrix with 4 symbols per row
symbolMatrix = reshape(bitStream, 4, []).';

% Display the symbol matrix
disp('Symbol Matrix:');
disp(symbolMatrix);
symbolMatrix(1,:)
symbolMatrix(2,:)
symbolMatrix(:,3)
symbolMatrix(:,4)