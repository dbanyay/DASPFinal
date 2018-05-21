function output = overlapAdd(input, windowSize, overlap, inputSize)
%overlapAdd creates a vector from frames with adding the overlapping
%windows together


output = zeros(inputSize);  % make output same length as original input

output(1:windowSize) = input(1,:); % copy the first frame

delay = overlap*(windowSize+1);
curWindow = delay;
cntr = 1;

while cntr <= size(input,1)
    output(curWindow:curWindow+windowSize-1) = output(curWindow:curWindow+windowSize-1) + input(cntr, :);
    curWindow = cntr*delay;
    cntr = cntr+1;
end

end

