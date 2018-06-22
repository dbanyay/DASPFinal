function [mic1,mic2,t] = createMultiMicSignal(cleanSpeech, noise, SNR, d, alpha, c, Fs)
%createMultichannelSignal Create multimicrophone signal

P_s = sum((abs(cleanSpeech).^2)./length(cleanSpeech));
P_n = sum((abs(noise).^2)./length(noise));

SNR_o = 10*log10(P_s./P_n); %original SNR
P_n_desired = P_s./(10^(SNR/10));


noise1 = noise(1:length(cleanSpeech)/2);
noise2 = noise(length(cleanSpeech)/2:length(cleanSpeech)-1);

cleanSpeech1 = cleanSpeech(1:length(cleanSpeech)/2);

t = abs(round(cos(alpha)*d/c*Fs));

cleanSpeech2 = zeros(1,length(cleanSpeech1));
cleanSpeech2(t:length(cleanSpeech1)) = cleanSpeech1(1:length(cleanSpeech1)-t+1);  % add delay


noise1_new = noise1.*sqrt(P_n_desired/P_n);
noise2_new = noise2.*sqrt(P_n_desired/P_n);


mic1 = cleanSpeech1 + noise1_new;
mic2 = cleanSpeech2 + noise2_new;


end

