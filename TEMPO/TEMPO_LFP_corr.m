freq = [13 30];
burst_freq = [13 30];
fs = 2000;
cleanWindow = 1;
shfs = 1000;

bla_tempo_ch = 1;
vhc_tempo_ch = 3;

[filenames fileroot] = uigetfile('pick', 'MultiSelect', 'ON')  % load in data files for all animals
  
for file = 1:numel(filenames)
      
    load([fileroot filenames{file}])
      
    fprintf('Running %s...\n', filenames{file});

    vhc_ch = find(contains(fileInfo.channels, 'VHC'));
    bla_ch = find(contains(fileInfo.channels, 'BLA'));

    % filter tempo and lfp
    [bla_burst, ~, ~] = LFP_filter(fileInfo.rawdata(:,bla_ch), fs, burst_freq(1), burst_freq(2));
    [vhc_burst, ~, ~] = LFP_filter(fileInfo.rawdata(:,vhc_ch), fs, burst_freq(1), burst_freq(2));


    [bla_lfp, bla_lfp_amp, bla_lfp_phase] = LFP_filter(fileInfo.rawdata(:,bla_ch), fs, freq(1), freq(2));
    [vhc_lfp, vhc_lfp_amp, vhc_lfp_phase] = LFP_filter(fileInfo.rawdata(:,vhc_ch), fs, freq(1), freq(2));

    [cleanTEMPO] = TEMPO_clean(new_tempo, fs, floor(size(new_tempo,2)/2000), freq(1), freq(2), cleanWindow);
    bla_tempo = cleanTEMPO(bla_tempo_ch,:)';
    bla_tdt = cleanTEMPO(bla_tempo_ch+1,:)';
    vhc_tempo = cleanTEMPO(vhc_tempo_ch,:)';
    vhc_tdt = cleanTEMPO(vhc_tempo_ch+1,:)';


    window = 1000;
    max_test = min([numel(bla_lfp), numel(bla_tempo)]);
    startIndex = startIndex(startIndex + window < max_test);
    slider = round(fs/((freq(1) + freq(2))/2));

    n = 0;
    for i = 1:numel(startIndex)
        burst_corr_tmp = xcorr(vhc_burst(startIndex(i):startIndex(i)+window), bla_burst(startIndex(i):startIndex(i)+window),0,'coeff');

        if burst_corr_tmp >=0.5
            n = n+1;
            vhc_corr{file}(:,n) = xcorr(vhc_lfp(startIndex(i):startIndex(i)+window), vhc_tempo(startIndex(i):startIndex(i)+window),slider,'coeff');
            bla_corr{file}(:,n) = xcorr(bla_lfp(startIndex(i):startIndex(i)+window), bla_tempo(startIndex(i):startIndex(i)+window),slider,'coeff');
            bla2vhc_corr{file}(:,n) = xcorr(bla_lfp(startIndex(i):startIndex(i)+window), vhc_tempo(startIndex(i):startIndex(i)+window),slider,'coeff');
            vhc2bla_corr{file}(:,n) = xcorr(vhc_lfp(startIndex(i):startIndex(i)+window), bla_tempo(startIndex(i):startIndex(i)+window),slider,'coeff');
            tempo_corr{file}(:,n) = xcorr(vhc_tempo(startIndex(i):startIndex(i)+window), bla_tempo(startIndex(i):startIndex(i)+window),slider,'coeff');
            lfp_corr{file}(:,n) = xcorr(vhc_lfp(startIndex(i):startIndex(i)+window), bla_lfp(startIndex(i):startIndex(i)+window),slider,'coeff');
            
            R = floor((max_test - (window+1)) .* rand(shfs,1)+1);    

            for k = 1:shfs
                vhc_corr_tmp{file}(:,n,k) = xcorr(vhc_lfp(R(k):R(k)+window), vhc_tempo(R(k):R(k)+window),slider,'coeff');
                bla_corr_tmp{file}(:,n,k) = xcorr(bla_lfp(R(k):R(k)+window), bla_tempo(R(k):R(k)+window),slider,'coeff');
                bla2vhc_corr_tmp{file}(:,n,k) = xcorr(bla_lfp(R(k):R(k)+window), vhc_tempo(R(k):R(k)+window),slider,'coeff');
                vhc2bla_corr_tmp{file}(:,n,k) = xcorr(vhc_lfp(R(k):R(k)+window), bla_tempo(R(k):R(k)+window),slider,'coeff');
                tempo_corr_tmp{file}(:,n,k) = xcorr(vhc_tempo(R(k):R(k)+window), bla_tempo(R(k):R(k)+window),slider,'coeff');
                lfp_corr_tmp{file}(:,n,k) = xcorr(vhc_lfp(R(k):R(k)+window), bla_lfp(R(k):R(k)+window),slider,'coeff');
            end
        end
    end
end