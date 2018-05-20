function frames = windowing(input, windowSize, overlap)
%createFrames Creates time windows from the input
%   taking input, windowsize and overlap into consideration

windowfunc = hann(windowSize)';

delay = floor(overlap*windowSize);

numFrames = floor(length(input)/windowSize/overlap);

frames = zeros(numFrames, windowSize);

curWindow = 1;
cntr = 1;

while cntr <= numFrames
    
    frames(cntr, :) = windowfunc.*input(curWindow:curWindow+windowSize-1);
    curWindow = curWindow + delay;
    cntr = cntr+1;
    
end
end

