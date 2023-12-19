function [MvM, MvT, TvT] = TEMPO_corr(tempo, fs, corrWindow)
     
   corrWindow = fs*corrWindow;
    
   n = 0; 
   for in=1:corrWindow:(size(tempo,2)-corrWindow),
       n=n+1;
       tmp1(n) = xcorr(tempo(1,in:in+corrWindow),tempo(3,in:in+corrWindow),0,'normalized'); %Perform cross correlation between both adjusted and filtered mNeons
       tmp2(n) = xcorr(tempo(1,in:in+corrWindow),tempo(4,in:in+corrWindow),0,'normalized'); %Perform cross correlation between left mNeon and right tdTomato - for investigating level of tdTomato contamination still present
       tmp3(n) = xcorr(tempo(2,in:in+corrWindow),tempo(4,in:in+corrWindow),0,'normalized'); 
   end
    
    MvM = nanmean(tmp1);
    MvT = nanmean(tmp2);
    TvT = nanmean(tmp3);
    
end

