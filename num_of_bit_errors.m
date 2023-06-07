function [ output ] = num_of_bit_errors( arr1,arr2 )
output = sum(arr1 ~= arr2);
end

