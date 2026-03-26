N = 20;
d = zeros(N, 1);
sgm = zeros(N, 1);
speakerID = strings(N, 1);  % 用 string 类型存储 speaker 编号

files = dir('./*.csv');
fileNames = {files.name};

singFiles = fileNames(contains(fileNames, 'sing'));
convFiles = fileNames(contains(fileNames, 'conv'));

assert(length(singFiles) == length(convFiles), 'Sing and Conv file counts do not match.');

for i = 1:N
    singFile = singFiles{i};
    convFile = convFiles{i};

    % 提取 speaker ID（假设是第五段，用 _ 分割）
    tokens = regexp(singFile, '_', 'split');
    speakerID(i) = tokens{5};  % 第5个是speaker编号，比如 '001'

    f0_songfile = readtable(singFile);
    f0_song = f0_songfile.f0stab(f0_songfile.f0stab < 0);

    f0_convfile = readtable(convFile);
    f0_conv = f0_convfile.f0stab(f0_convfile.f0stab < 0);

    [d_i, sgm_i] = pb_effectsize(f0_song, f0_conv);
    d(i) = d_i;
    sgm(i) = sgm_i;

    figure(i); histogram(f0_song); hold on; histogram(f0_conv); hold off
end

[CI, pval, mu_hat] = exactCI(d, sgm, 0.05/3, 0.5);

cohensd = sqrt(2)*norminv(d);
disp("Cohen's d value:"); disp(cohensd)
disp("Confidence Interval (CI):"); disp(CI)
disp("p value:"); disp(pval)
disp("Estimated mean effect size: mu_hat:"); disp(mu_hat)

% 保存主结果表
results = table(speakerID, d, sgm, cohensd, ...
    'VariableNames', {'SpeakerID', 'd', 'sgm', 'Cohens_d'});
writetable(results, './f0stab_cohend_results.csv');

% 保存 CI 和估计值
extra_results = table(CI(1), CI(2), pval, mu_hat, ...
    'VariableNames', {'CI_lower', 'CI_upper', 'p_value', 'mu_hat'});
writetable(extra_results, './f0stab_extra_results.csv');

