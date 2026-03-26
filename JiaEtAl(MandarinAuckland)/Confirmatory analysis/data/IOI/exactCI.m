function [CI, pval, mu_hat] = exactCI(Y, sgm, al, mu_null)
    %%
    % Y      : effect sizes. The size shold be K*1 (column vector).
    % sgm    : square root of the variance in effect size estimates (e.g., standard errors). Size The size should be K*1 (column vector).
    % al     : alpha-level for hypothesis testing. Scalar value.
    %          Note this function performs two-sided test. If you want to perform one-sided test, double the alpha value.
    % mu_null: Location parameter of the null distribution of effect sizes to be tested. Scalar value.
    %
    % References
    % Brockwell, S. E., & Gordon, I. R. (2001). A comparison of statistical methods for meta-analysis. Statistics in Medicine, 20(6), 825–840. https://doi.org/10.1002/sim.650
    % 
    % 

    %%
    L = 16;
    K = numel(Y);
    if K <= L
        L = 2^K;
        V = dec2bin(0:(L - 1))' - '0';
    else
        V = binornd(1, 0.5, [K, 2^L]);
    end
    V(V == 0) = -1;

    mu_min = min(Y);
    mu_max = max(Y);

    %% CI
    mu_u_min = h_upperp(mu_min, Y, sgm, V, al);
    mu_u_max = h_upperp(mu_max, Y, sgm, V, al);
    if mu_u_min ~= mu_u_max
        mu_u = fzero(@(mu) h_upperp(mu, Y, sgm, V, al) - 0.5, [mu_min, mu_max]);
    else
        mu_u = fzero(@(mu) h_upperp(mu, Y, sgm, V, al) - 0.5, [0 + 1e-5, 1 - 1e-5]);
    end

    mu_l_min = h_lowerp(mu_min, Y, sgm, V, al);
    mu_l_max = h_lowerp(mu_max, Y, sgm, V, al);
    if mu_l_min ~= mu_l_max
        mu_l = fzero(@(mu) h_lowerp(mu, Y, sgm, V, al) - 0.5, [mu_min, mu_max]);
    else
        mu_l = fzero(@(mu) h_lowerp(mu, Y, sgm, V, al) - 0.5, [0 + 1e-5, 1 - 1e-5]);
    end
    
    CI = [mu_l, mu_u];

    %% mu
    mu_hat = fzero(@(mu) h_upperp(mu, Y, sgm, V, 1) - 0.5, [mu_min, mu_max]);

    %% p-value
    p_ul = h_upperp(mu_null, Y, sgm, V, 0);
    p_uu = h_upperp(mu_null, Y, sgm, V, 1);
    p_ll = h_lowerp(mu_null, Y, sgm, V, 0);
    p_lu = h_lowerp(mu_null, Y, sgm, V, 1);

    if p_ul ~= p_uu
        pval = fzero(@(p) h_upperp(mu_null, Y, sgm, V, p) - 0.5, [0, 1]);
    elseif p_ll ~= p_lu
        pval = fzero(@(p) h_lowerp(mu_null, Y, sgm, V, p) - 0.5, [0, 1]);
    elseif (p_ul == p_uu) && (p_ll == p_lu)
        pval = 0;
    end
end

function s = h_upperp(mu, Y, sgm, V, al)
    [T_mu, T_null] = h_stat(mu, Y, sgm, V);
    c = quantile(T_null, al/2);
    s = c < T_mu;
end

function s = h_lowerp(mu, Y, sgm, V, al)
    [T_mu, T_null] = h_stat(mu, Y, sgm, V);
    c = quantile(T_null, 1 - al/2);
    s = T_mu < c;
end

function [T_mu, T_null] = h_stat(mu, Y, sgm, V)
    sgm_musq = sgm.^2 + max(0, mean((Y - mu).^2 - sgm.^2));
    w = (Y - mu)./sgm_musq;
    %w = sign(Y - mu)./sqrt(sgm_musq); %median-based test statistics: used in the pilot analysis
    T_mu = sum(w);
    T_null = abs(w)'*V;
end

%% Test code
%{
rng(11);

al = 0.05/6;
K = 16;

mu_0 = normrnd(0, 1);
sgm = gamrnd(0.8, 1.0, [K, 1]);
tau_0 = gamrnd(0.8, 1.0);

mu_null = 0;
%mu_null = mu_0;

%%
M = 2048;
CI = zeros(M, 2);
mu_hat = zeros(M, 1);
pval = zeros(M, 1);

X = zeros(K, M);
parfor m=1:M
    X(:, m) = normrnd(mu_0, sqrt(tau_0^2 + sgm.^2));
end

tic;
parfor m=1:M
    Y = X(:, m);
    [CI(m, :), pval(m), mu_hat(m)] = exactCI(Y, sgm, al, mu_null)
end
toc;

%%
figure(1);
clf; cla;
hitrate = mean(CI(:, 1) < mu_0 & mu_0 < CI(:, 2));
plot(CI(:, 1));
hold on
plot(CI(:, 2));
plot([1, M], mu_0.*[1, 1], '-.m');
hold off
title(['alpha level = ', num2str(hitrate*100, '%3.4f'), ' (nominal = ', num2str(1 - al, '%3.4f'), ')']);

figure(2);
clf; cla;
histogram(mu_hat);
hold on
yl = ylim();
plot(mu_0.*[1, 1], yl, '-.m');
hold off

figure(3);
clf; cla;
histogram(pval);
A = pval > al;
B = CI(:, 1) < mu_null & mu_null < CI(:, 2);
disp([mean(A), mean(B), all(A == B)]);

figure(4);
plot(sort(pval));
hold on
plot([1, M], [0, 1], '-.m');
hold off
axis tight;
%}