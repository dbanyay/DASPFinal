close all
clear all


%% Read audio files

[Fs,clean1s,clean2s,babbles,nonstats,shapeds] = readAudioFiles();

%% Framing

windowSize = 33; % in samples, has to be odd

overlap = 0.5; % for hanning window 50% is appropriate

input = babbles;
%input = ones(size(babbles));

framesTime = windowing(input,windowSize,overlap);

%% Apply transform
framesFreq = fft(framesTime);


%% Gain function



%% Noise PSD estimator



%% Speech PSD estimator


%% Apply gain

framesProcessedFreq = applyGain(framesFreq);


%% Inverse transform

framesProcessedTime = ifft(framesProcessedFreq);

%% Overlap add

output = overlapAdd(framesProcessedTime,windowSize, overlap);

subplot(211)
plot(input);
title('Input')
subplot(212)
plot(output);
title('Output')
