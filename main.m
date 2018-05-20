close all


%% Read audio files
[clean1, Fs] = audioread('samples\clean_speech.wav');

clean2 = audioread('samples\clean_speech_2.wav');

babblenoise = audioread('samples\babble_noise.wav');

nonstatnoise = audioread('samples\aritificial_nonstat_noise.wav');

speechshapednoise = audioread('samples\Speech_shaped_noise.wav');