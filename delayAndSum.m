% function Sk = delayAndSum(freq1,freq2, alpha, c, d)
function W = delayAndSum(freq1,alpha, Fs,c,d)
%delayAndSum 

% for j = 1:size(freq1,2)
%     
%     
%     omega_vect = (freq2(:,j).*2*pi); % convert to radians
%     delay = omega_vect.*d.*sin(deg2rad(alpha))./c;
%     
%     freq2_delayed(:,j) = freq2(:,j).*exp(-1i.*delay);
%     
%     Sk(:,j) = (freq1(:,j)+freq2_delayed(:,j))./2;
% 
% 
% end    
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

