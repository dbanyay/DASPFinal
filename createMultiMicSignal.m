function [mic1,mic_sigs] = createMultiMicSignal(cleanSpeech, noise, SNR, d, alpha, c, Fs)
%createMultichannelSignal Create multimicrophone signal

P_s = sum((abs(cleanSpeech).^2)./length(cleanSpeech));
P_n = sum((abs(noise).^2)./length(noise));

SNR_o = 10*log10(P_s./P_n); %original SNR
P_n_desired = P_s./(10^(SNR/10));

noise_new = noise.*sqrt(P_n_desired/P_n);

mic1 = cleanSpeech; %source signal

[H_PW, h_IR_PW] = calculate_transfer_function_plane_wave(c, d, alpha, Fs);
[H_PW, h_IR_PW_Noise] = calculate_transfer_function_plane_wave(c, d, 100, Fs);
mic_sigs = fftfilt(h_IR_PW, mic1);
mic_noise = fftfilt(h_IR_PW_Noise, noise_new);

mic_sigs = mic_sigs + mic_noise;

end

