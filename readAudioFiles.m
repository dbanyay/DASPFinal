function [Fs,clean1s,clean2s,babblenoise,nonstatnoise,speechshapednoise,mixed1a,mixed1b,mixed1c] = readAudioFiles()
%readAudioFiles Read audio files, create shorter versions

[clean1, Fs] = audioread('samples\clean_speech.wav');

clean2 = audioread('samples\clean_speech_2.wav');

babblenoise = audioread('samples\babble_noise.wav');

nonstatnoise = audioread('samples\aritificial_nonstat_noise.wav');

speechshapednoise = audioread('samples\Speech_shaped_noise.wav');


% subplot(511)
% plot(clean1);
% subplot(512)
% plot(clean2);
% subplot(513)
% plot(babblenoise);
% subplot(514)
% plot(nonstatnoise);
% subplot(515)
% plot(speechshapednoise);


%% Create shorter versions for faster processing

clean1s = clean1(1:5*Fs)'; % 5 seconds
clean2s = clean2(1:5*Fs)'; % 5 seconds
babbles = babblenoise(1:5*Fs)';
nonstats = nonstatnoise(1:5*Fs)';
shapeds = speechshapednoise(1:5*Fs)';


timeaxis = 1:5*Fs;
timeaxis = timeaxis./Fs;

% subplot(511)
% plot(timeaxis,clean1s);
% title('Clean 1  short')
% subplot(512)
% plot(timeaxis,clean2s);
% title('Clean 2  short')
% subplot(513)
% plot(timeaxis,babbles);
% title('Babble  short')
% subplot(514)
% plot(timeaxis,nonstats);
% title('Artificial non static noise short')
% subplot(515)
% plot(timeaxis,shapeds);
% title('Speech shaped noise short')

%% Create mixed signals

SNR = 0;
mixed1a = create_NoisySpeech(clean1s, nonstats, SNR); %non-stationary noise
mixed1b = create_NoisySpeech(clean1s, shapeds, SNR); %speech shaped noise
%Speech Shaped Noise (SSN) is defined as a random noise that has the same long-term spectrum as a given speech signal.
mixed1c = create_NoisySpeech(clean1s, babbles, SNR);


end

