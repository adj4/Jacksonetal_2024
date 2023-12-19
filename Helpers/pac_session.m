function [pac, amps] = pac_window(x, y, flow, fhigh, fs)

% low frequency should be phase(y), high frequency amplitude - so x is what is
% being tested in high freq

dt = 1/fs;

L = ceil(3*(1/fhigh(1))/dt+1);
L2 = ceil(2*(1/flow(1))/dt+1);

B = fir1(L, [fhigh(1) fhigh(2)]*dt*2);
B2 = fir1(L2, [flow(1) flow(2)]*dt*2);


high_filt = filtfilt(B,1,x);
low_filt = filtfilt(B2,1,y);
    

x_amp = abs(hilbert(high_filt));
y_phase = angle(hilbert(low_filt));

nbins = 18;

pac=[];

[~, pac] = get_mi(y_phase,x_amp, nbins);

ampprofile = zeros(nbins,1);
ampcounts = zeros(nbins,1);

for k = 1:numel(y_phase)
    phi = mod(y_phase(k), 2*pi);
    phasebin = ceil(phi / (2*pi/nbins));
    ampprofile(phasebin) = ampprofile(phasebin) + x_amp(k);
    ampcounts(phasebin) = ampcounts(phasebin) + 1;          
end
   
amps = ampprofile ./ ampcounts;  

end

