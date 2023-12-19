function [pac, amps, pls] = pac_window(x, y, startPoints, flow, fhigh, window, overlap, analysisWindow, fs)

% low frequency should be phase(y), high frequency amplitude - so x is what is
% being tested in high freq

window = window*fs;
analysisWindow = analysisWindow*fs;
overlap = overlap*fs;
dt = 1/fs;

starts = startPoints - window;
ends = startPoints + window;

starts = starts(ends < numel(x));
ends = ends(ends < numel(x));

ends = ends(starts > 1);
starts = starts(starts > 1);


L = ceil(3*(1/fhigh(1))/dt+1);
L2 = ceil(2*(1/flow(1))/dt+1);

B = fir1(L, [fhigh(1) fhigh(2)]*dt*2);
B2 = fir1(L2, [flow(1) flow(2)]*dt*2);


high_filt = filtfilt(B,1,x);
low_filt = filtfilt(B2,1,y);
    

x_amp = abs(hilbert(high_filt));
x_phase = angle(hilbert(high_filt));
y_phase = angle(hilbert(low_filt));

nbins = 18;

pac=[];

for i = 1:numel(starts)
    slider = [starts(i):overlap:ends(i)-analysisWindow];
    for j = 1:numel(slider)
        [~, pac(j,i)] = get_mi(y_phase(slider(j):slider(j)+analysisWindow),x_amp(slider(j):slider(j)+analysisWindow), nbins);
        
        ampprofile = zeros(nbins,1);
        ampcounts = zeros(nbins,1);
        for k = 1:analysisWindow 
            phi = mod(y_phase(slider(j)+k), 2*pi);
            phasebin = ceil(phi / (2*pi/nbins));
            ampprofile(phasebin) = ampprofile(phasebin) + x_amp(slider(j)+k);
            ampcounts(phasebin) = ampcounts(phasebin) + 1;
        end
        amps(:,j,i) = ampprofile ./ ampcounts;
        amp_counts(:,j,i) = ampcounts;
        phases = x_phase(slider(j):slider(j)+analysisWindow) - y_phase(slider(j):slider(j)+analysisWindow);
        pls(j,i) = abs(mean(exp(2*pi*sqrt(-1)*phases)));
%         rESC(j,i)= corr(realy3(slider(j):slider(j)+analysisWindow),x_amp(slider(j):slider(j)+analysisWindow)); %Envelope signal correlation
%         rNESC(j,i) = corr(cos(y_phase(slider(j):slider(j)+analysisWindow)),x_amp(slider(j):slider(j)+analysisWindow)); % Ampltude-normalized ESC
%         rAEC(j,i)= corr(y_amp(slider(j):slider(j)+analysisWindow), x_amp(slider(j):slider(j)+analysisWindow)); %amplitude envelope comodulation
    end
end

