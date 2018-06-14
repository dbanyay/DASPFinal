close all
clear all


%% Read audio files

[Fs,clean1s,clean2s,babbles,nonstats,shapeds,mixed1a,mixed1b] = readAudioFiles();

%% Framing

windowSize = 321; % in samples, has to be odd, ~20ms

overlap = 0.5; % for hanning window 50% is appropriate

%input = babbles;
%input = clean1s;
%input = mixed1a;
input = mixed1b;
%input = ones(size(babbles));
inputSize = size(input);

%spectrogram(input,blackman(1024),512,256,Fs,'yaxis');

framesTime = windowing(input,windowSize,overlap);


%% Apply transform
framesFreq = fft(framesTime')';  % transpose needed because we have rows with the frames, fft applies for columns


%% Noise PSD estimator

framesFreqSquared = freqSquare(framesFreq,windowSize);

k = 25;  % slide window size
alpha = 0.85; % alpha for exponential smoother

noise_PSD = noisePSD(framesFreq,framesFreqSquared,Fs,k,windowSize,alpha);


%% Speech PSD estimator

%% Gain function



%% Apply gain

framesProcessedFreq = applyGain(smoothedFramesFreq);


%% Inverse transform

framesProcessedTime = ifft(framesProcessedFreq')';

%% Overlap add

output = overlapAdd(framesProcessedTime,windowSize, overlap, inputSize);

subplot(211)
plot(input);
title('Input')
subplot(212)
plot(output);
title('Output')
