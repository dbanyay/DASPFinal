function [H_PW, h_IR_PW] = calculate_transfer_function_plane_wave(c0, d, directionPW, Fs)

x_c = [0,1];
num_freq_bins = 321*495;
NumberOfSensors = length(x_c);
% TRANSFER FUNCTION H
H_PW = zeros(num_freq_bins, NumberOfSensors); % H is a frequency dependent M X N matrix
for m = 1:NumberOfSensors % for each sensor
    for freq_idx = 1:num_freq_bins % for each angular frequency
        F_c = freq_idx*Fs/num_freq_bins;
        angularfreq = 2*pi*F_c;
        k_scalar = angularfreq*d./c0;
        k_vect = -k_scalar*sin(deg2rad(directionPW));
        %exp_modellingdelay = exp(-1i*angularfreq*((N_fft/2 - 1)/fs));
        H_PW(freq_idx,m) = exp(1i*dot(k_vect,x_c(m))); %*exp_modellingdelay
    end
end
h_IR_PW = ifft(H_PW, 'symmetric'); % Impulse response matrix

end