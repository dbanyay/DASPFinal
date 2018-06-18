function smoothed_framesFreq = reduce_variance(framesFreqSquared, alpha)

smoothed_framesFreq(1,:) = framesFreqSquared(1,:);

for frame_index = 2:size(framesFreqSquared,1)
    smoothed_framesFreq(frame_index,:) = alpha.*smoothed_framesFreq(frame_index-1,:) + (1-alpha).*framesFreqSquared(frame_index,:);
end

        