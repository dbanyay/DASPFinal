function alpha_matrix = estimate_alpha(PSD_noisy, PSD_noise, framesFreqSquared)
%PSD_noisy is the smoothed periodogram of the noisy speech, which is
%denoted by the variable smoothed_framesFreq in the code of main.m
[frame,freq] = size(PSD_noisy);

alpha_opt(1,:) = 0.5.*ones(1,freq); %original alpha matrix
alpha_c(1,:) = 0.5.*ones(1,freq); %the comparison

average_over_freq_noisyPSD = mean(PSD_noisy,2);
average_over_freq_noisyP = mean(framesFreqSquared,2);

for time = 2:frame
        alpha_opt(time,:) = 1./(1 + ( PSD_noisy(time-1,:)./PSD_noise(time-1,:) - 1 ).^2 );
        alpha_c(time) = 1./(1 + ( average_over_freq_noisyPSD(time-1)./average_over_freq_noisyP(time) - 1).^2 );
end

correction_factor(1) = 0.3*max(alpha_c(1), 0.7);
for time = 2:frame
    correction_factor(time) = 0.7.*correction_factor(time-1) + 0.3*max(alpha_c(time), 0.7);
end

%update optimal alpha
alpha_max = 0.96;
alpha_min = 0.3;
%apply max constraint to alpha_opt
alpha_opt = min(alpha_opt, alpha_max);
alpha_matrix = correction_factor'.*alpha_opt;
%apply min constraint to alpha_matrix
alpha_matrix = max(alpha_matrix,alpha_min);



end