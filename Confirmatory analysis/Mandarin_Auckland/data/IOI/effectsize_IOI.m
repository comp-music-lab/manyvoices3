N = 20; % Number of data pairs
d = zeros(N, 1);
sgm = zeros(N, 1);
speakerID = strings(N, 1);  % 新增变量用于记录 speaker 编号

% Retrieve all csv files in the current directory
files = dir('./*.csv');  % get all csv 
fileNames = {files.name};  % extract file names

% Categorize files into sing and conv groups
singFiles = fileNames(contains(fileNames, 'sing'));  % Files containing sing
convFiles = fileNames(contains(fileNames, 'conv'));  % Files containing conv

% Ensure the number of sing and conv files match
assert(length(singFiles) == length(convFiles), 'Sing and Conv file counts do not match.');

for i = 1:length(singFiles)
    singFile = singFiles{i};
    convFile = convFiles{i};

    % 提取 speaker ID：假设是第 5 个由 '_' 分隔的部分
    tokens = regexp(singFile, '_', 'split');
    speakerID(i) = tokens{4};  % 例如 "013010"

    dur_songfile = readtable(singFile, 'VariableNamingRule', 'preserve');
    dur_song = dur_songfile.IOI;

    dur_convfile = readtable(convFile, 'VariableNamingRule', 'preserve');
    dur_conv = dur_convfile.IOI;

    [d_i, sgm_i] = pb_effectsize(dur_conv, dur_song);
    d(i) = d_i;
    sgm(i) = sgm_i;

    figure(i); histogram(dur_song); hold on; histogram(dur_conv); hold off
end

[CI, pval, mu_hat] = exactCI(d, sgm, 0.1/3, 0.5);


cohensd = sqrt(2)*norminv(d);
disp("Cohen's d value:")
disp(cohensd)

disp("Confidence Interval (CI):")
disp(CI)

disp("p value:")
disp(pval)

disp("Estimated mean effect size: mu_hat:")
disp(mu_hat)

if pval > 0
    fprintf('log10(p) = %.6f\n', log10(pval));
else
    fprintf('p is numerically 0; log10(p) = -Inf (underflow). Consider high-precision methods.)\n');
end

% Save cohen D with speaker ID
results = table(speakerID, d, sgm, cohensd, ...
    'VariableNames', {'SpeakerID', 'd', 'sgm', 'Cohens_d'});
writetable(results, './IOI_cohend_results.csv');

% Save CI, p value and estimated mean effect size
extra_results = table(CI(1), CI(2), pval, mu_hat, ...
    'VariableNames', {'CI_lower', 'CI_upper', 'p_value', 'mu_hat'});
writetable(extra_results, './IOI_extra_results.csv');
