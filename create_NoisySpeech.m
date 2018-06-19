function mixed = create_NoisySpeech(cleanSpeech, noise, SNR)

%Power of signal
P_s = sum((abs(cleanSpeech).^2)./length(cleanSpeech));
P_n = sum((abs(noise).^2)./length(noise));

SNR_o = 10*log10(P_s./P_n); %original SNR
P_n_desired = P_s./(10^(SNR/10));

noise_new = noise.*sqrt(P_n_desired/P_n);

mixed = cleanSpeech + noise_new;

end