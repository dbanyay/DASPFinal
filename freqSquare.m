function framesFreqSquared = freqSquare(framesFreq, windowSize)
%freqSquare squares magnitudes in freq frames and divides it with L

for i = 1:size(framesFreq,1)
    
    framesFreqSquared(i,:) = 1/windowSize.*framesFreq(i,:).^2;

end

end

