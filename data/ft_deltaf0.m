%This script is used for calculating F0 stability. 
% Time point and f0 have been elicited using f0_pyin.py, and this script is
% based on what we elicited to convert f0 as cents and using wavelet-based
% method to obtain the derivation of f0.
datainfofile = readtable('./f20240821_s1_f0_conv.csv', 'PreserveVariableNames', true);
time = datainfofile{:,1};
f0 = datainfofile{:,2};
speaker = datainfofile{:,3};
date = datainfofile{:,4};
condition = datainfofile{:,5};
dt = diff(time); 
dt = [dt; NaN]; 

valid_idx = ~isnan(dt);
time = time(valid_idx);
f0 = f0(valid_idx);
dt = dt(valid_idx);
speaker = speaker(valid_idx);
date = date(valid_idx);
condition = condition(valid_idx);
reffreq = 440;

    
    %%
    f0 = f0(:);
    f0_cent = 1200.*log2(f0./reffreq);
    
    %%
    df0 = f0 .* 0 + NaN;
    idx_ed = 0;
    idx_st = find(~isinf(f0_cent(idx_ed + 1:end)), 1, 'first') + idx_ed;


    while ~isempty(idx_st)
        idx_ed = find(isinf(f0_cent(idx_st:end)), 1, 'first') + idx_st - 2;
        if isempty(idx_ed)
            idx_ed = numel(f0_cent);
        end

        f0_cent_i = f0_cent(idx_st:idx_ed);
        df0_j = cwtdiff(f0_cent_i, 0.02, 1/0.005, 1);
        df0(idx_st:idx_ed) = df0_j;

        idx_st = find(~isinf(f0_cent(idx_ed + 1:end)), 1, 'first') + idx_ed;
    end

f0stab = -abs(df0);

    results = table(time, f0, dt, df0, f0stab, speaker, date, condition);
    output_filename = strrep('./f20240821_s1_f0_conv.csv', '.csv', '_processed.csv');
    writetable(results, output_filename);
    
    fprintf('Fully processed %s\n', output_filename);