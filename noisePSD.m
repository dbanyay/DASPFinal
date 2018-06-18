function noise_PSD = noisePSD(framesFreqSmoothed,k)
%% Create sliding window for each frame, take Qmin


for bin = 1:size(framesFreqSmoothed,2)  % iterate through all bins
    for time = 1:size(framesFreqSmoothed,1)-k+1  % iterate through time     

        noise_PSD(time:time+k-1,bin) = min(framesFreqSmoothed(time:time+k-1,bin));        
        
    end    
end



end

