function frames = windowing(input, windowSize, overlap)
%createFrames Creates time windows from the input
%   taking input, windowsize and overlap into consideration

windowfunc = hann(windowSize)';

delay = overlap*(windowSize+1);

curWindow = 1;
cntr = 1;

while curWindow + windowSize <= length(input)
    
    frames(cntr, :) = windowfunc.*input(curWindow:curWindow+windowSize-1);
    curWindow = cntr*delay;
    cntr = cntr+1;
end

end

