close all
clear all


%% Read audio files

[Fs,clean1s,clean2s,babbles,nonstats,shapeds,mixed1a,mixed1b,mixed1c] = readAudioFiles();

%% Framing

windowSize = 321; % in samples, has to be odd, ~20ms

overlap = 0.5; % for hanning window 50% is appropriate

%input = babbles;
%input = clean1s;
% input = mixed1a;
input = mixed1b;
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
alpha = 0.85;
%a time-averaged magnitude spectrum to reduce the error variance
smoothed_framesFreq = reduce_variance(framesFreqSquared, alpha);

k = 80;  % sliding window D size, empirically set to 96
PSD_Noise = noisePSD(smoothed_framesFreq,k);
%implementing a time-varying and frequency-depended smoothing parameter for
%noisy speech: for constructing Bias Compensation Matrix
alpha_matrix = estimate_alpha(smoothed_framesFreq, PSD_Noise, framesFreqSquared);
%bias compensation
Bmin = estimate_Bmin(smoothed_framesFreq, PSD_Noise, k, alpha_matrix);
PSD_Noise = PSD_Noise.*Bmin;

t = [1:321]./windowSize*Fs;
figure;
plot(sqrt(PSD_Noise(:,250)),'r');
hold on
plot(sqrt(smoothed_framesFreq(:,250)));
plot(abs(framesFreq(:,250)),'g');
hold off

%% Speech PSD estimator
P_yy = framesFreqSquared; %mayb be estimated through the periodogram or a smoothed version
P_nn = PSD_Noise;
b = 1.5; %the amount of substraction
H = max((P_yy - b.*P_nn)./P_yy,0);
PSD_Speech = (H.*framesFreqSquared);


figure;
plot(sqrt(PSD_Speech(:,50)),'r');
hold on
plot(abs(framesFreq_c(:,50)),'b');
plot(abs(framesFreq(:,50)), 'g');
hold off





%% apply gain function
[pri_SNR, pos_SNR] = estimate_priori_SNR(framesFreqSquared, PSD_Speech, PSD_Noise, 0.98);
u = (pri_SNR./(1+pri_SNR)).*pos_SNR;
com1 = sqrt(pi.*u)./(2.*pos_SNR);
com2 = exp(-u./2);
com3 = (1+u).*besseli(0,u./2) + u.*besseli(1,u./2); %modified bessel function of first kind
Hstsa = com1.*com2.*com3;
%wiener gain function
Hwiener = pri_SNR./(pri_SNR+1);

framesSpeech_1  =(Hstsa.*abs(framesFreq)).*exp(complex(0,angle(framesFreq)));
framesSpeech_2  =(Hwiener.*abs(framesFreq)).*exp(complex(0,angle(framesFreq)));


%% Inverse transform

framesProcessedTime_o = ifft(framesFreq')';
framesProcessedTime_1 = ifft(framesSpeech_1','symmetric')';
framesProcessedTime_2 = ifft(framesSpeech_2','symmetric')';

%% Overlap add

input = overlapAdd(framesProcessedTime_o,windowSize, overlap, inputSize);
output_1 = overlapAdd(framesProcessedTime_1,windowSize, overlap, inputSize);
output_2 = overlapAdd(framesProcessedTime_2,windowSize, overlap, inputSize);

figure;
% plot(input)
% hold on
% plot(output)
% hold off
subplot(311)
plot(input);
title('Input')
ylim([-0.5 0.5])
subplot(312)
plot(output_1);
title('Output')
ylim([-0.5 0.5])
subplot(313)
plot(output_2);
title('Output')
ylim([-0.5 0.5])
