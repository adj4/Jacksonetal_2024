function [cleanTEMPO] = TEMPO_clean(tempo, fs, duration, fmin, fmax, cleanWindow)

    tempo_N = length(tempo(1,:));
    tempo_dt = 1/fs;
    
    duration = duration * fs;
    
    tempo = tempo(:, 1:duration);
 
    tempo_N = length(tempo(1,:));

    L = ceil(3*(1/fmin)/tempo_dt+1);

    B = fir1(L,[fmin fmax]*tempo_dt*2);

    %%% Clean TEMPO signals
    
    cleanTEMPO = [];
    for jj=1:4,
        cleanTEMPO(jj,:) = filtfilt(B, 1, tempo(jj,:)); %r is filtered version of x (runs forward and backward using filtfilt -- if it goes in one direction, there will be a phase delay
    end

    % 10 periods of 13-30hz (mid-freq 21.5Hz)

    n = 0; %going through vector from first timepoint to end. take data in 1sec chunks. n is chunk number

    regressWin = round(fs*cleanWindow);  %Window to apply to signals for regression. Window is dependent on freq with optimal # of periods = 10. 
    for in=1:regressWin:(tempo_N-regressWin),
        n=n+1;

        XneonL = cleanTEMPO(1,in:in+regressWin-1);
        XtomatoL = cleanTEMPO(2,in:in+regressWin-1);
        XneonR = cleanTEMPO(3,in:in+regressWin-1);
        XtomatoR = cleanTEMPO(4,in:in+regressWin-1);
        
        b = robustfit(XtomatoL,XneonL);
        YFITL = b(1) + b(2)*XtomatoL;
        b = robustfit(XtomatoR,XneonR);
        YFITR = b(1) + b(2)*XtomatoR;
    
        tempL = XneonL - YFITL;
        tempR = XneonR - YFITR;
    
        j = 0;
        for jj=in:in+regressWin-1
            j = j+1;
            cleanTEMPO(1,jj) = tempL(j);
            cleanTEMPO(3,jj) = tempR(j);
        end
    
    end
    
    for jj=1:4,
       cleanTEMPO(jj,:) = filtfilt(B, 1, cleanTEMPO(jj,:)); %r is filtered version of x (runs forward and backward using filtfilt -- if it goes in one direction, there will be a phase delay
    end
    
end