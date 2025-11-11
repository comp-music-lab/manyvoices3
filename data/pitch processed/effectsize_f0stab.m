N = 14; % Number of data pairs
d = zeros(N, 1);
sgm = zeros(N, 1);

% Retrieve all csv files in the current directory
files = dir('./*.csv');  % get all csv 
fileNames = {files.name};  % extract file names

% Categorize files into sing and conv groups
singFiles = fileNames(contains(fileNames, 'sing'));  % Files containing sing
convFiles = fileNames(contains(fileNames, 'conv'));  % Files containing conv

% Ensure the number of sing and conv files match
assert(length(singFiles) == length(convFiles), 'Sing and Conv file counts do not match.');

for i=1:N
    f0_songfile = readtable(singFiles{i});
        f0_song = f0_songfile.f0stab(f0_songfile.f0stab < 0);
    f0_convfile = readtable(convFiles{i});
f0_conv = f0_convfile.f0stab(f0_convfile.f0stab < 0);
[d_i, sgm_i] = pb_effectsize(f0_song, f0_conv);
    d(i) = d_i;
    sgm(i) = sgm_i;

    figure(i); histogram(f0_song); hold on; histogram(f0_conv); hold off
end

[CI, pval, mu_hat] = exactCI(d, sgm, 0.05*2/3, 0.5);


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
writetable(results, './f0stab_cohend_results.csv');

% Save CI, p value and estimated mean effect size
extra_results = table(CI(1), CI(2), pval, mu_hat, ...
    'VariableNames', {'CI_lower', 'CI_upper', 'p_value', 'mu_hat'});
writetable(extra_results, ['./f0stab_extra_results.csv']);
