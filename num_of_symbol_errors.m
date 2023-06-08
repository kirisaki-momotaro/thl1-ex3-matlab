function [output] = num_of_symbol_errors (arr1,arr2)   
    output = 0;
    for i = 1:length(arr1)*2        
        if abs(arr1(i) - arr2(i)) >= 0.05
            output = output + 1;
        end
    end
end