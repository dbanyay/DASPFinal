function noisePSD(framesFreq,Fs,k)
% noisePSD create sliding window, estimate noise floor


%% Create sliding window for each frame, take Qmin

for i = 1:size(framesFreq,2)  % iterate througs all freq segments

    Q = [];
    index = 1;
    cntr = 1;
    while index+k < size(framesFreq,1)  % iterate through frames
       
        %Q(cntr,1:k) = framesFreq(index:index+k-1,i);
        Qsmoothed(cntr) = 1/k*sum(framesFreq(index:index+k-1,i));  % Bartlett estimate

        index = index + k
        cntr = cntr +1
    end
    
   Qmin(i) = min(Qsmoothed);        
    
end

end


