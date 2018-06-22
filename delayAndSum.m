function Sk = delayAndSum(freq1,freq2,t,alpha,Fs,c)
%delayAndSum 





for j = 1:size(freq1,2)
    
    
    omega_vect = (freq2(:,j).*2*pi); % convert to radians
    delay = omega_vect.*deg2rad(alpha)./c;
    
    freq2_delayed(:,j) = freq2(:,j).*exp(i.*delay);
    
    Sk(:,j) = (freq1(:,j)+freq2_delayed(:,j))./2;


end    


end

