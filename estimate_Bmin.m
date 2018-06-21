function Bmin = estimate_Bmin(PSD_noisy, PSD_noise, D, alpha)

%calculate inversed normalized variance of the smoothed noisy PSD estimate
Beta = min(alpha.^2, 0.8);
frame = size(PSD_noisy,1);

Pyy(1,:) = (1-Beta(1,:)).*PSD_noisy(1,:);
for i = 2:frame
    Pyy(i,:) = Beta(i,:).*Pyy(i-1,:) + (1-Beta(i,:)).*PSD_noisy(i,:);
end

PSD_noisyS = PSD_noisy.^2;
PyyS(1,:) = (1-Beta(1,:)).*PSD_noisyS(1,:);
for i = 2:frame
    PyyS(i,:) = Beta(i,:).*PyyS(i-1,:) + (1-Beta(i,:)).*PSD_noisyS(i,:);
end

Var_of_Noisy = PyyS - Pyy.^2;

Qeq = (2.*(PSD_noisy.^2))./Var_of_Noisy; %degree of freedom

MD = 0.865;
HD = 3.38;
QeqE = (Qeq - 2*MD)./(1-MD);

Bmin = 1 + 0.1 + (((D-1)*2)./QeqE).*(gamma(1 + 2./Qeq).^HD);

end