function noise_PSD = noisePSD(framesFreq,framesFreqSquared,Fs,k,windowSize,alpha)
% noisePSD create sliding window, estimate noise floor

%% Exponential smoother

framesFreqSmoothed(1,:) = framesFreqSquared(1,:);

for bin = 1:size(framesFreqSquared,2)  % iterate through all bins
    for time = 2:size(framesFreqSquared,1)  % iterate through time     
        framesFreqSmoothed(time,bin) = alpha * framesFreqSmoothed(time-1,bin) + (1-alpha)*framesFreqSquared(time,bin);
    end    
end


%% Create sliding window for each frame, take Qmin

noise_PSD = zeros(size(framesFreqSquared));

for bin = 1:size(framesFreqSmoothed,2)  % iterate through all bins
    for time = 1:size(framesFreqSmoothed,1)-k+1  % iterate through time     

        noise_PSD(time:time+k-1,bin) = min(framesFreqSmoothed(time:time+k-1,bin));        
        
    end    
end


hold on

plot(framesFreqSquared(:,1));

plot(framesFreqSmoothed(:,1));

plot(noise_PSD(:,1));

hold off



end

