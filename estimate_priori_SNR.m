function [pri_SNR, pos_SNR] = estimate_priori_SNR(noisySpeech, cleanSpeech, PSD_noise, alpha)
%noisySpeech is the squared value of the amplitude | |^2
%cleanSpeech is the squared value of the amplitude | |^2
%a typical value for alpha is 0.98
pos_SNR = noisySpeech./PSD_noise;

pri_SNR(1,:) = (1-alpha).*max(pos_SNR(1,:)-1,0);
for i = 2:size(noisySpeech,1)
    pri_SNR(i,:) = alpha*(4/pi).*(cleanSpeech(i-1,:)./PSD_noise(i,:)) + (1-alpha).*max(pos_SNR(i,:)-1,0);
end

pri_SNR = max(pri_SNR, 0.0126);

end