%This script is used for calculating F0 stability. 
% Time point and f0 have been elicited using f0_pyin.py, and this script is
% based on what we elicited to convert f0 as cents and using wavelet-based
% method to obtain the derivation of f0.
% Define folder path
input_folder = './pitch delete zero/';
output_folder = './pitch processed/';

% Ensure the output folder exists
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Get all f0.csv files in the folder
file_list = dir(fullfile(input_folder, '*_f0.csv'));

% Loop through each file
for i = 1:length(file_list)
    % Read the current file
    file_name = file_list(i).name;
    file_path = fullfile(input_folder, file_name);
    datainfofile = readtable(file_path, 'PreserveVariableNames', true);

time = datainfofile{:,1};
f0 = datainfofile{:,2};
language = datainfofile{:,3};
location = datainfofile{:,4};
group  = datainfofile{:,5};
gender = datainfofile{:,6};
speaker = datainfofile{:,7};
condition = datainfofile{:,8};
dt = diff(time); 
dt = [dt; NaN]; 

valid_idx = ~isnan(dt);
time = time(valid_idx);
f0 = f0(valid_idx);
dt = dt(valid_idx);
speaker = speaker(valid_idx);
% date = date(valid_idx);
langauge = language(valid_idx);
location = location(valid_idx);
group = group(valid_idx);
gender = gender(valid_idx);
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

minlen = min([length(time), length(f0), length(language), ...
              length(location), length(group), length(gender), ...
              length(speaker), length(condition), length(dt), ...
              length(df0), length(f0stab)]);


time = time(1:minlen);
f0 = f0(1:minlen);
language = language(1:minlen);
location = location(1:minlen);
group = group(1:minlen);
gender = gender(1:minlen);
speaker = speaker(1:minlen);
condition = condition(1:minlen);
f0_cent = f0_cent(1:minlen);
dt = dt(1:minlen);
df0 = df0(1:minlen);
f0stab = f0stab(1:minlen);

    results = table(time, f0, language, location, group, gender, speaker, condition, f0_cent, dt, df0, f0stab);
        % Create results table
    output_filename = strrep(file_name, '_f0.csv', '_f0_processed.csv');
    output_path = fullfile(output_folder, output_filename);
    writetable(results, output_path);
    
    fprintf('Fully processed %s\n', output_path);
end
