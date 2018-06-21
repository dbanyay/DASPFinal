function smoothed_framesFreq = reduce_variance(framesFreqSquared, alpha)

if size(alpha,1) == 1
    smoothed_framesFreq(1,:) = (1-alpha).*framesFreqSquared(1,:);

    for frame_index = 2:size(framesFreqSquared,1)
        smoothed_framesFreq(frame_index,:) = alpha.*smoothed_framesFreq(frame_index-1,:) + (1-alpha).*framesFreqSquared(frame_index,:);
    end
    
else
    
    smoothed_framesFreq(1,:) = (1 - alpha(1,:)).*framesFreqSquared(1,:);
    for frame_index = 2:size(framesFreqSquared,1)
            smoothed_framesFreq(frame_index,:) = alpha(frame_index,:).*smoothed_framesFreq(frame_index-1,:)...
                 + (1 - alpha(frame_index,:)).*framesFreqSquared(frame_index,:);
    end
end
    

        