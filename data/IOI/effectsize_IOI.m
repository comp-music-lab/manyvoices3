N = 14; % Number of data pairs
d = zeros(14, 1);
sgm = zeros(14, 1);

% Retrieve all csv files in the current directory
files = dir('./*.csv');  % get all csv 
fileNames = {files.name};  % extract file names

% Categorize files into sing and conv groups
singFiles = fileNames(contains(fileNames, 'sing'));  % Files containing sing
convFiles = fileNames(contains(fileNames, 'conv'));  % Files containing conv

% Ensure the number of sing and conv files match
assert(length(singFiles) == length(convFiles), 'Sing and Conv file counts do not match.');

for i=1:length(singFiles)
    dur_songfile = readtable(singFiles{i}, 'VariableNamingRule', 'preserve');
        dur_song = dur_songfile.IOI;
    dur_convfile = readtable(convFiles{i}, 'VariableNamingRule', 'preserve');
        dur_conv = dur_convfile.IOI;
    [d_i, sgm_i] = pb_effectsize(dur_conv, dur_song);
    d(i) = d_i;
    sgm(i) = sgm_i;

    figure(i); histogram(dur_song); hold on; histogram(dur_conv); hold off
end

[CI, pval, mu_hat] = exactCI(d, sgm, 0.05/6, 0.5);


cohensd = sqrt(2)*norminv(d);
disp("Cohen's d value:")
disp(cohensd)

disp("Confidence Interval (CI):")
disp(CI)

disp("p value:")
disp(pval)

disp("Estimated mean effect size: mu_hat:")
disp(mu_hat)

% Save cohen D
results = table(d, sgm, cohensd, 'VariableNames', {'d', 'sgm', 'Cohens_d'});
writetable(results, ['./IOI_cohend_results.csv']);

% Save CI, p value and estimated mean effect size
extra_results = table(CI(1), CI(2), pval, mu_hat, ...
    'VariableNames', {'CI_lower', 'CI_upper', 'p_value', 'mu_hat'});
writetable(extra_results, ['./IOI_extra_results.csv']);