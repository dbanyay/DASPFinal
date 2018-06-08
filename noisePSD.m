function PSD_Noise = noisePSD(framesFreq,Fs,k)
% noisePSD create sliding window, estimate noise floor


%% Create sliding window for each frame, take Qmin
alpha = 0.6; % smoothing parameter for recursive averaging noise estimation
for i = 1:size(framesFreq,2)  % iterate througs all freq segments
    index = 1;
    cntr = 1;
    while index+k < size(framesFreq,1)  % iterate through frames
       if index == 1
        %Q(cntr,1:k) = framesFreq(index:index+k-1,i);
            P_y(cntr) = 1/k*sum(framesFreq(index:index+k-1,i)); % Bartlett estimate
            psd_n(cntr) = P_y(cntr);  % assume that the first time-frame is noise only
       else
            P_y(cntr) = 1/k*sum(framesFreq(index:index+k-1,i));
            psd_n(cntr) = alpha * psd_n(cntr-1) + (1-alpha) * P_y(cntr);
       end

        index = index + k;
        cntr = cntr +1;
    end
    PSD_Noise(i,:) = psd_n;      
end

end


