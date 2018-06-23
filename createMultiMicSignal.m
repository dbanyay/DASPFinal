function [mic1,mic_sigs] = createMultiMicSignal(cleanSpeech, noise, SNR, d, alpha, c, Fs)
%createMultichannelSignal Create multimicrophone signal

noise1 = noise(1:length(cleanSpeech));
noise2 = noise(length(cleanSpeech):2*length(cleanSpeech)-1);

P_s = sum((abs(cleanSpeech).^2)./length(cleanSpeech));
P_n = sum((abs(noise1).^2)./length(noise1));

SNR_o = 10*log10(P_s./P_n); %original SNR
P_n_desired = P_s./(10^(SNR/10));

noise_new1 = noise1.*sqrt(P_n_desired/P_n);
noise_new2 = noise2.*sqrt(P_n_desired/P_n);

mic1 = cleanSpeech; %source signal
beta = alpha; %incoming angle for the noise signal
[H_PW, h_IR_PW] = calculate_transfer_function_plane_wave(c, d, alpha, Fs);
[H_PW, h_IR_PW_Noise] = calculate_transfer_function_plane_wave(c, d, beta, Fs); 
mic_sigs = fftfilt(h_IR_PW, mic1);
mic_noise2 = fftfilt(h_IR_PW_Noise, noise_new2);
mic_noise = [noise_new1 mic_noise2(:,2)];

mic_sigs = mic_sigs + mic_noise;

end

