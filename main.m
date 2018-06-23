close all
clear all


%% Read audio files

[Fs,clean1s,clean2s,babblenoise,nonstatnoise,speechshapednoise,mixed1a,mixed1b,mixed1c] = readAudioFiles();

%% Framing

windowSize = 321; % in samples, has to be odd, ~20ms

overlap = 0.5; % for hanning window 50% is appropriate

%input = babbles;
%input = clean1s;
input = mixed1a;
% input = mixed1b;
% input = mixed1c;
%input = ones(size(babbles));
inputSize = size(input);

framesTime_c = windowing(clean1s, windowSize,overlap);
%spectrogram(input,blackman(1024),512,256,Fs,'yaxis');
framesTime = windowing(input,windowSize,overlap);


%% Apply transform
framesFreq = fft(framesTime')';  % transpose needed because we have rows with the frames, fft applies for columns
framesFreq_c = fft(framesTime_c')';

%% Noise PSD estimator
framesFreqSquared = (abs(framesFreq).^2); % | |^2

% ----------------------- Reduce Variance -------------------------------%
alpha = 0.85;
%a time-averaged magnitude spectrum to reduce the error variance
smoothed_framesFreq = reduce_variance(framesFreqSquared, alpha);

% ----------------------- Estimate noise PSD as the minimum within each
% sliding window --------------------------------------------------------%
k = 80;  % sliding window D size, empirically set to 80
PSD_Noise = noisePSD(smoothed_framesFreq,k);

%implementing a time-varying and frequency-depended smoothing parameter for
%noisy speech
alpha_matrix = estimate_alpha(smoothed_framesFreq, PSD_Noise, framesFreqSquared);

% ------------------------ bias compensation ----------------------------%
Bmin = estimate_Bmin(smoothed_framesFreq, PSD_Noise, k, alpha_matrix);
PSD_Noise = PSD_Noise.*Bmin;

t = [1:321]./windowSize*Fs;
% ------------------------ Plot estimation at frequency bin 250 ---------%
figure;
plot(sqrt(PSD_Noise(:,250)),'r');
hold on
plot(sqrt(smoothed_framesFreq(:,250)));
plot(abs(framesFreq(:,250)),'g');
hold off
title('Power Spectral Density, frequency bin = 250')
xlabel('time frame')
ylabel('PSD')
legend('Estimated Noise PSD','Smoothed Noisy Sppech PSD','Original Noisy Speech PSD')

%% Speech PSD estimator
P_yy = framesFreqSquared; %mayb be estimated through the periodogram or a smoothed version
P_nn = PSD_Noise;
b = 1.5; %the amount of substraction
% -------------------------- Wiener Filter -------------- %
H = max((P_yy - b.*P_nn)./P_yy,0);
PSD_Speech = (H.*framesFreqSquared);


%% apply gain function
[pri_SNR, pos_SNR] = estimate_priori_SNR(framesFreqSquared, PSD_Speech, PSD_Noise, 0.98);

% ----------------------- MMSE Short-time Spectral Amplitude Gain Function ----%
u = (pri_SNR./(1+pri_SNR)).*pos_SNR;
com1 = sqrt(pi.*u)./(2.*pos_SNR);
com2 = exp(-u./2);
com3 = (1+u).*besseli(0,u./2) + u.*besseli(1,u./2); %modified bessel function of first kind
Hstsa = com1.*com2.*com3;

% ------------------------ Wiener Gain Function -------------------------%
Hwiener = pri_SNR./(pri_SNR+1);

% ------------------------ apply both gain functions to noisy speech ----%
framesSpeech_1  =(Hstsa.*abs(framesFreq)).*exp(complex(0,angle(framesFreq)));
framesSpeech_2  =(Hwiener.*abs(framesFreq)).*exp(complex(0,angle(framesFreq)));


%% Inverse transform

framesProcessedTime_1 = ifft(framesSpeech_1','symmetric')';
framesProcessedTime_2 = ifft(framesSpeech_2','symmetric')';
% framesProcessedTime_3 = ifft(framesSpeech_3','symmetric')';

%% Overlap add

output_1 = overlapAdd(framesProcessedTime_1,windowSize, overlap, inputSize);
output_2 = overlapAdd(framesProcessedTime_2,windowSize, overlap, inputSize);
%output_3 = overlapAdd(framesProcessedTime_3,windowSize, overlap, inputSize);

figure;
% plot(input)
% hold on
% plot(output)
% hold off
subplot(211)
plot(output_1);
title('Output with Hstsa')
ylim([-0.5 0.5])
subplot(212)
plot(output_2);
title('Output with Hwiener')
ylim([-0.5 0.5])
% subplot(313)
% plot(output_3);
% title('LSA')
% ylim([-0.5 0.5])
figure;
subplot(311)
spectrogram(input,1024,512,[],Fs,'yaxis')
title('Spectrogram of noisy input signal')
subplot(312)
spectrogram(output_1,1024,512,[],Fs,'yaxis')
title('Spectrogram of filtered signal using STSA')
subplot(313)
spectrogram(output_2,1024,512,[],Fs,'yaxis')
title('Spectrogram of filtered signal using Wiener gain')








%% Multi microphone system

% ------------- generate desired signal -------------------------------%
% ------------- with desired angle alpha = 40 degrees -----------------%

% --------------parameters for dual-channel speech enhancement -------%
c = 340; % sound of the speed, in m/s
alpha = 40; % beam angle in degree, as desired direction
d = 0.045; % distance of the 2 mics, in m
SNRmulti = 1; 
% the generated desired signal, denoted by mic_sigs, is mixed with
% speech shaped noise with the same coming angle as alpha
[mic1,mic_sigs] = createMultiMicSignal(clean1s, speechshapednoise, SNRmulti, d, alpha, c, Fs);

inputSize2 = size(mic1);
mic_sigs = mic_sigs';
framesTime_mic1 = windowing(mic_sigs(1,:), windowSize,overlap);
framesTime_mic2 = windowing(mic_sigs(2,:),windowSize,overlap);
framesFreq_mic1 = fft(framesTime_mic1')'; 
framesFreq_mic2 = fft(framesTime_mic2')';

% -------------- used the desired signal to construct filter W ---------%
W = delayAndSum(framesFreq_mic1,alpha,Fs,c,d);

% -------------- apply the beamformer filter to the desired signal -----%
sk = W(1,:).*framesFreq_mic1 + W(2,:).*framesFreq_mic2;
%sk = delayAndSum(framesFreq_mic1, framesFreq_mic2, alpha, c, d)
Sk_t = ifft(sk','symmetric')';
output_ds = overlapAdd(Sk_t,windowSize, overlap, inputSize2);

% --------------- generate signals with coming angle beta -------------%
beta = 180;
% the generated undesired signal, denoted by mic_sigs2, is mixed with
% speech shaped noise with the same coming angle as beta
[mic2,mic_sigs2] = createMultiMicSignal(clean1s, speechshapednoise, SNRmulti, d, beta, c, Fs);
mic_sigs2 = mic_sigs2';
framesTime_mic1_2 = windowing(mic_sigs2(1,:), windowSize,overlap);
framesTime_mic2_2 = windowing(mic_sigs2(2,:),windowSize,overlap);

framesFreq_mic1_2 = fft(framesTime_mic1_2')'; 
framesFreq_mic2_2 = fft(framesTime_mic2_2')';

% --------------- apply previously constructed beamformer filter to the new
% generated signal ----------------------------------------------------%
sk_new = W(1,:).*framesFreq_mic1_2 + W(2,:).*framesFreq_mic2_2;
Sk_t_new = ifft(sk_new','symmetric')';
output_ds_new = overlapAdd(Sk_t_new,windowSize, overlap, inputSize2);



figure;
subplot(311)
plot(mic_sigs(1,:));
title('Input')
ylim([-0.5 0.5])
subplot(312)
plot(output_ds)
title('Output, incoming angle = 40 degrees')
ylim([-0.5 0.5])
subplot(313)
plot(output_ds_new)
title('Output, incoming angle = 180 degrees')
ylim([-0.5 0.5])

figure;
subplot(311)
spectrogram(mic_sigs(2,:),1024,512,[],Fs,'yaxis')
title('Spectrogram of noisy input signal')
subplot(312)
spectrogram(output_ds,1024,512,[],Fs,'yaxis')
title('Spectrogram of filtered signal using Delay and sum, incoming angle = 40')
subplot(313)
spectrogram(output_ds_new,1024,512,[],Fs,'yaxis')
title('Spectrogram of filtered signal using Delay and sum, incoming angle = 180')

