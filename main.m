close all
clear all


%% Read audio files

[Fs,clean1s,clean2s,babbles,nonstats,shapeds] = readAudioFiles();

%% Framing

%windowSize = 321; % in samples, has to be odd, ~20ms
windowSize = 321;

overlap = 0.5; % for hanning window 50% is appropriate

%input = babbles;
input = clean1s;
%input = ones(size(babbles));
inputSize = size(input);

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

output = overlapAdd(framesProcessedTime,windowSize, overlap, inputSize);

subplot(211)
plot(input);
title('Input')
subplot(212)
plot(output);
title('Output')
