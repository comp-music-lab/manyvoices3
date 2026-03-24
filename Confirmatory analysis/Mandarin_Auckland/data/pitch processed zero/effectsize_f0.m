N = 20; % Number of data pairs
d = zeros(N, 1);
sgm = zeros(N, 1);
speakerID = strings(N, 1);  

% Retrieve all csv files in the current directory
files = dir('./*.csv');  
fileNames = {files.name};  

% Categorize files into sing and conv groups
singFiles = fileNames(contains(fileNames, 'sing'));  
convFiles = fileNames(contains(fileNames, 'conv'));  

assert(length(singFiles) == length(convFiles), 'Sing and Conv file counts do not match.');

pattern = '(\w+?)_(\d+?)_(\d+?)_(M|F)_(\d+?)_(\w+)\.csv';

for i = 1:length(singFiles)
    singFile = singFiles{i};
    convFile = convFiles{i};
        
    tokens = regexp(singFile, '_', 'split');
    speakerID(i) = tokens{5}; 

    f0_songfile = readtable(singFile);
    f0_song = f0_songfile.f0_cent;
    f0_convfile = readtable(convFile);
    f0_conv = f0_convfile.f0_cent;

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

% Save Cohen's d results with speakerID
results = table(speakerID, d, sgm, cohensd, ...
    'VariableNames', {'SpeakerID', 'd', 'sgm', 'Cohens_d'});
writetable(results, './f0_cohend_results.csv');

% Save CI, p value and estimated mean effect size
extra_results = table(CI(1), CI(2), pval, mu_hat, ...
    'VariableNames', {'CI_lower', 'CI_upper', 'p_value', 'mu_hat'});
writetable(extra_results, './f0_extra_results.csv');


