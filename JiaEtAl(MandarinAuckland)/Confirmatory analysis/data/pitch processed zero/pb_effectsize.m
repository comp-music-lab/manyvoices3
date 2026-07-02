function [A, tau, dof] = pb_effectsize(x, y)
    %%
    n_x = length(x);
    n_y = length(y);

    %%
    x = x(:);
    y = y(:);

    R_ik = tiedrank([x; y]);
    R_ikx = tiedrank(x);
    R_iky = tiedrank(y);
    R_ix = mean(R_ik(1:n_x));
    R_iy = mean(R_ik((n_x + 1):end));
    
    A = 1 - 1/n_x*(R_iy - (n_y + 1)/2);

    %% Separated samples scenario (3.5.3)
    if A == 1
        A = 1 - 1/(2*n_x*n_y);
        S_xsq = 1/(4*n_x);
        S_ysq = 1/(4*n_y);
    elseif A == 0
        A = 1/(2*n_x*n_y);
        S_xsq = 1/(4*n_x);
        S_ysq = 1/(4*n_y);
    else
        if n_x == 1
            S_xsq = 0;
        else
            S_xsq = 1/(n_x - 1) * sum((R_ik(1:n_x) - R_ikx - R_ix + (n_x + 1)/2).^2);
        end

        if n_y == 1
            S_ysq = 0;
        else
            S_ysq = 1/(n_y - 1) * sum((R_ik((n_x + 1):end) - R_iky - R_iy + (n_y + 1)/2).^2);
        end
    end

    %% Confidence interval using the approximation by a t-distribution (3.7.2)
    tau = 1/(n_x*n_y)*sqrt(n_x*S_xsq + n_y*S_ysq);
    dof = (S_xsq/n_y + S_ysq/n_x)^2/((S_xsq/n_y)^2/(n_x - 1) + (S_ysq/n_x)^2/(n_y - 1));
end

%% Test code 1 - relative effects
%{
mu_X = normrnd(0, 2);
mu_Y = normrnd(0, 2);
sgm = gamrnd(5, 0.2);
d = (mu_X - mu_Y)/sgm;
p = normcdf(d/sqrt(2));

support = linspace(min(mu_X, mu_Y) - 6*sgm, max(mu_X, mu_Y) + 6*sgm, 1024);
A = 1 - trapz(support, normcdf(support, mu_X, sgm).*normpdf(support, mu_Y, sgm));

fprintf('%3.4f, %3.4f, %e\n', p, A, abs(p - A));
%}

%% Test code 2 - confidence intervals
%{
for j=1:2
    if j == 1
        mu_X = normrnd(0, 2);
        mu_Y = normrnd(0, 2);
        sgm_X = gamrnd(5, 0.2);
        sgm_Y = gamrnd(5, 0.2);
        support = linspace(min(mu_X, mu_Y) - 6*max(sgm_X, sgm_Y), max(mu_X, mu_Y) + 6*max(sgm_X, sgm_Y), 1024);
        p_0 = 1 - trapz(support, normcdf(support, mu_X, sgm_X).*normpdf(support, mu_Y, sgm_Y));

        xrnd = @(N) normrnd(mu_X, sgm_X, [N, 1]);
        yrnd = @(N) normrnd(mu_Y, sgm_Y, [N, 1]);
    elseif j == 2
        mu = normrnd(4, 0.1);
        sgm = normrnd(0.9, 0.04);
        a = normrnd(3, 0.1);
        b = normrnd(1.1, 0.07);
        
        support = linspace(0, 16, 1024);
        p_0 = 1 - trapz(support, normcdf(support, mu, sgm).*gampdf(support, a, b));

        xrnd = @(N) normrnd(mu, sgm, [N, 1]);
        yrnd = @(N) gamrnd(a, b, [N, 1]);

        figure(3)
        clf; cla;
        plot(support, normpdf(support, mu, sgm));
        hold on
        plot(support, gampdf(support, a, b));
        hold off
    end
    
    N = poissrnd(100, [2, 1]);
    
    M = 8192;
    p = zeros(M, 1);
    p_sim = zeros(M, 1);
    CI = zeros(M, 4);
    al = 0.05;
    
    parfor m=1:M
        X = xrnd(N(1));
        Y = yrnd(N(2));
        [p(m), tau, dof] = pb_effectsize(X, Y);
        
        u_ts = tinv(1 - al/2, dof);
        u_os = tinv(1 - al, dof);
        CI(m, :) = [p(m) - tau*u_ts, p(m) + tau*u_ts, p(m) - tau*u_os, p(m) + tau*u_os];

        p_sim(m) = mean(X(1:min(N)) >= Y(1:min(N)));
    end
    
    hitrate_ts = mean(CI(:, 1) < p_0 & p_0 < CI(:, 2));
    hitrate_os_l = mean(CI(:, 3) < p_0);
    hitrate_os_u = mean(p_0 < CI(:, 4));

    figure(j);
    clf; cla;
    histogram(p, 64, 'Normalization', 'pdf', 'EdgeColor', 'None');
    hold on
    histogram(p_sim, 'Normalization', 'pdf', 'EdgeColor', 'None');
    yl = ylim();
    plot([p_0, p_0], yl, '-.m');
    hold off
    title({[num2str(100*(1 - al), '%3.3f'), '% CI: ', num2str(hitrate_ts*100, '%3.3f'), '% (two-sided)'],...
            [num2str(hitrate_os_l*100, '%3.3f'), '% (one-sided, lower limit), ', num2str(hitrate_os_u*100, '%3.3f'), '% (one-sided, upper limit)']});
end
%}

%% Test code 3 - coreset
%{
mu_X = normrnd(0, 2);
mu_Y = normrnd(0, 2);
sgm = gamrnd(5, 0.2);
d = (mu_X - mu_Y)/sgm;
p_0 = normcdf(d/sqrt(2));

N = 8192;
M = 4096;
c = 256;
p = zeros(M, 3);

parfor m=1:M
    X = normrnd(mu_X, sgm, [N, 1]);
    Y = normrnd(mu_Y, sgm, [N, 1]);
    p_XY = pb_effectsize(X, Y);
    
    x = sort(X);
    y = sort(Y);
    x = x(1:c:N);
    y = y(1:c:N);
    p_xy = pb_effectsize(x, y);
    
    X_c = normrnd(mu_X, sgm, [N/c, 1]);
    Y_c = normrnd(mu_Y, sgm, [N/c, 1]);
    p_c = pb_effectsize(X_c, Y_c);

    p(m, :) = [p_XY, p_xy, p_c];
end

figure(1);
clf; cla;
histogram(p(:, 1), 32, 'Normalization', 'pdf', 'EdgeColor', 'None');
hold on
histogram(p(:, 2), 'Normalization', 'pdf', 'EdgeColor', 'None');
histogram(p(:, 3), 32, 'Normalization', 'pdf', 'EdgeColor', 'None');
yl = ylim();
plot([p_0, p_0], yl, '-.m');
hold off
%}

%{
mu_x = 42.14;
sgm_x = 16.07;

mu_y = 16.30;
sgm_y = 8.34;

n = 83 + 306;
br = 0.02:0.02:0.98;

M = 1000;
A = zeros(M, 1);
A_m = zeros(length(br), 1);

for j=1:length(br)
    n_x = round(br(j) * n);
    n_y = n - n_x;

    parfor m=1:M
        x = normrnd(mu_x, sgm_x, [n_x 1]);
        y = normrnd(mu_y, sgm_y, [n_y 1]);

        A(m) = lib.pb_effectsize(x, y);
    end

    A_m(j) = mean(A);
end

figure(1);
plot(br, A_m);
ylim([0 1]);
%}

%{
mu_x = 2;
mu_y = 0;

sgm_y = 1;
sgm_x = [1 2 4 8 16].*sgm_y;

br = 0.01:0.01:0.99;

N = 2000;
M = 2000;

A = zeros(length(br), length(sgm_x));
A_m = zeros(M, 1);

for i=1:length(sgm_x)
    sgm_xi = sgm_x(i);
    
    for j=1:length(br)
        n_x = round(br(j) * N);
        n_y = N - n_x;
        
        parfor m=1:M
            x = normrnd(mu_x, sgm_xi, [n_x 1]);
            y = normrnd(mu_y, sgm_y, [n_y 1]);

            A_m(m) = lib.pb_effectsize(x, y);
        end

        A(j, i) = mean(A_m);
    end
end

figure(1);
plot(br, A);
xlim([-0.05 1.05]); ylim([0.49 1.01]);
%}

%{
mu_x = 1;
mu_y = 0;
sgm_x = 1;
sgm_y = 1;

N = 500;

x = normrnd(mu_x, sgm_x, [N 1]);
y = normrnd(mu_y, sgm_y, [N 1]);
A = lib.pb_effectsize(x, y);

y = normrnd(mu_x, sgm_x, [N 1]);
x = normrnd(mu_y, sgm_y, [N 1]);
B = lib.pb_effectsize(x, y);

disp([A B]);
%}

%{
al = 0.05;
mu_1 = 1.2;
mu_2 = 0.7;
sgm = 1.8;
d = (mu_1 - mu_2)/sgm;
rho = normcdf(d/sqrt(2));

n_1 = 128;
n_2 = 128;

M = 4096;
CI = zeros(M, 2);

d_0 = 0;
dlt = 0.4;
rho_ul = normcdf([d_0 - dlt, d_0 + dlt]./sqrt(2));
C = (0.5 - rho_ul(1) + rho_ul(2) - 0.5);
equivalencehit = zeros(M, 1);

for m=1:M
    X = normrnd(mu_1, sgm, [n_1, 1]);
    Y = normrnd(mu_2, sgm, [n_2, 1]);
    [rho_m, tau, dof] = pb_effectsize(X, Y);
    u = tinv(1 - al, dof);
    CI(m, :) = [rho_m - tau*u, rho_m + tau*u];

    C_mw = sqrt(ncx2inv(al, 1, C^2/(2*tau)^2));
    equivalencehit(m) = abs(rho_m - 0.5 - (rho_ul(2) - rho_ul(1))/2)/tau < C_mw;
end

falsepositive = sum(rho < CI(:, 1) | CI(:, 2) < rho)/M;
disp(falsepositive);

disp(sum(equivalencehit)/M);

figure(1);
for m=1:M
    plot([m, m], CI(m, :), 'Color', 'k');
    hold on
end
plot([1, M], rho_ul(1).*[1, 1], '-.m');
plot([1, M], rho_ul(2).*[1, 1], '-.m');
plot([1, M], [rho, rho], 'Color', 'g');
hold off
%}

%{
c_1 = 0;
c_2 = 0;

parfor i=1:n_x
    c_1 = c_1 + numel(find(x(i) > y));
    c_2 = c_2 + 0.5 * numel(find(x(i) == y));
end

A = (c_1 + c_2)/(n_x * n_y);
%}