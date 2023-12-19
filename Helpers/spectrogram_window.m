function [P, f, t]= spectrogram_window(x, startPoints, window, fs, params)

% script that returns a spectrogram that is centered around a behavioral/lfp
% timepoint

starts = startPoints - (window*fs);
ends = startPoints + (window*fs);

starts = starts(ends < numel(x));
ends = ends(ends < numel(x));

ends = ends(starts > 1);
starts = starts(starts > 1);


for i = 1:numel(starts)
    [P(:,:,i), f,t] = mtspecgramc(x(starts(i):ends(i)),[1 0.1],params);
end