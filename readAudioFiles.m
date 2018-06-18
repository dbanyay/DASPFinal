function [Fs,clean1s,clean2s,babbles_new,nonstats,shapeds,mixed1a,mixed1b,mixed1c] = readAudioFiles()
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

%power of signal
P_s = sum((abs(clean1s).^2)./length(clean1s));
P_n = sum((abs(babbles).^2)./length(babbles));
SNR_o = 10*log10(P_s./P_n);
SNR = 1;
P_n_desired = P_s./(10^(SNR/10));
babbles_new = babbles.*sqrt(P_n_desired/P_n);
P_n_new = sum((abs(babbles_new).^2)./length(babbles_new));
mixed1a = clean1s + nonstats;
mixed1b = clean1s + shapeds;
mixed1c = clean1s + babbles_new;

end

