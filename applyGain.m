function output = applyGain(input)
%applyGain Apply gain for frequency windows matrix

gain = ones(1,size(input,2));

output = zeros(size(input));

for i = 1:size(input,1)
    
    output(i,:) = input(i,:).*gain;
    
end


end

