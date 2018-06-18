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
% input = mixed1b;
input = mixed1c;
%input = ones(size(babbles));
inputSize = size(input);

framesTime_n  =windowing(babbles, windowSize, overlap);
framesTime_c = windowing(clean1s, windowSize,overlap);
framesTime = windowing(input,windowSize,overlap);


%% Apply transform
framesFreq = fft(framesTime')';  % transpose needed because we have rows with the frames, fft applies for columns
framesFreq_c = fft(framesTime_c')';
framesFreq_n = fft(framesTime_n')';

framesFreqSquared = (abs(framesFreq).^2);
alpha = 0.85;
smoothed_framesFreq = reduce_variance(framesFreqSquared, alpha);
%% Noise PSD estimator

k = 80;  % slide window size
PSD_Noise = noisePSD(smoothed_framesFreq,Fs,k);

t = [1:321]./windowSize*Fs;
figure;
plot(sqrt(PSD_Noise(:,250)),'r');
hold on
plot(sqrt(smoothed_framesFreq(:,250)));
% plot(abs(framesFreq(:,100)),'b');
plot(abs(framesFreq(:,250)),'g');
hold off

%% Speech PSD estimator 
P_yy = framesFreqSquared;
P_nn = PSD_Noise;
Hwiener = max((P_yy - P_nn)./P_yy,0.2);
PSD_Speech = (Hwiener.*abs(framesFreq)).*exp(complex(0,angle(framesFreq)));
% figure;
% plot(abs(sqrt(PSD_Speech(:,1))));
% hold on
% plot(abs(sqrt(framesFreqSquared(:,1))));
% hold off

figure;
plot(abs(PSD_Speech(:,50)),'r');
hold on
plot(abs(framesFreq_c(:,50)),'b');
plot(abs(framesFreq(:,50)), 'g');
hold off

% framesSpeech = sqrt(PSD_Speech).*windowSize;
framesSpeech = PSD_Speech;

figure;
subplot(2,1,1)
plot(abs(framesFreq(:,1)));
subplot(2,1,2)
plot(abs(framesSpeech(:,1)));

% Hwiener = (framesFreq(200,:)-sqrt(PSD_Noise(5,:)))./framesFreq(200,:);
% figure;
% plot(abs(Hwiener));
% figure;
% plot(abs(Hwiener.*framesFreq(200,:)));
% figure;
% plot(abs(framesFreq(200,:)));
%% Gain function

%% Apply gain

framesProcessedFreq = applyGain(framesSpeech);
framesProcessedFreq_o = applyGain(framesFreq);


%% Inverse transform

framesProcessedTime = ifft(framesProcessedFreq','symmetric')';
framesProcessedTime_o = ifft(framesProcessedFreq_o')';

%% Overlap add

output = overlapAdd(framesProcessedTime,windowSize, overlap, inputSize);

figure;
% plot(input)
% hold on
% plot(output)
% hold off
subplot(211)
plot(input);
title('Input')
ylim([-0.5 0.5])
subplot(212)
plot(output);
title('Output')
ylim([-0.5 0.5])
