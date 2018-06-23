function W = delayAndSum(freq1,alpha, Fs,c,d)
%delayAndSum 

num_of_sensors = 2;
freq_length = size(freq1,2);

W = zeros(num_of_sensors, freq_length); % H is a frequency dependent M X N matrix
for m = 1:num_of_sensors % for each sensor
    for freq_idx = 1:freq_length % for each angular frequency
        F_c = freq_idx*Fs/freq_length;
        angularfreq = 2*pi*F_c;
        shift = (angularfreq*d./c)*sin(deg2rad(alpha));
        W(m,freq_idx) = exp(-1i * (m-1) * shift);
    end
end
W = W./num_of_sensors; %the weight vector / the delay and sum beamformer


end

