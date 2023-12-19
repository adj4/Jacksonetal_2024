% LFP_filter created 2/9/23 AJ

% filters data at the given frequency and returns filtered signal,
% amplitude envelope and phase information

function [filtered_data, amp_data, phase_data] = LFP_filter(data, fs, f_low, f_high)

  dt = 1/fs;                                    % calculate delta step
  L = ceil(3*(1/f_low)/dt+1);                % set up filter
  B = fir1(L, [f_low f_high]*dt*2);
  filtered_data = filtfilt(B,1,data);           % run filter with filtfilt
  
  if nargout > 1
    hilb_data = hilbert(filtered_data);           % compute hilbert transform if requested
    phase_data = angle(hilb_data);                % calculate phases
    amp_data = abs(hilb_data);                    % calculate amplitude envelope
  end
   
end