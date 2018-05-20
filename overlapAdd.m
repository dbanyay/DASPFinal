function output = overlapAdd(input, windowSize, overlap)
%overlapAdd creates a vector from frames with adding the overlapping
%windows together


output = zeros(1,size(input,1)*size(input,2)*overlap);  % choose the final length

output(1:windowSize) = input(1,:); % copy the first frame

curWindow = ceil(overlap*windowSize);
delay = floor(overlap*windowSize);
cntr = 1;

while cntr <= size(input,1)
    output(curWindow:curWindow+windowSize-1) = output(curWindow:curWindow+windowSize-1) + input(cntr, :);
    curWindow = curWindow+delay;
    cntr = cntr+1;
end

end

