function simulation_unit_es()
    %% configuration
    datainfofile = './datainfo.csv';
    idx_song = 1;
    idx_desc = 2;
    
    %% check files
    datainfo = readtable(datainfofile);
    idx_keep = contains(datainfo.dataname, '_song') | contains(datainfo.dataname, '_desc');
    datainfo_songdesc = datainfo(idx_keep, :);

    groupid = unique(datainfo_songdesc.groupid);
    datafilepath = cell(length(groupid), 2, 3);

    for i=1:size(datainfo_songdesc, 1)
        gid_i = datainfo_songdesc.groupid(i);

        if contains(datainfo_songdesc.dataname{i}, '_song')
            idx_type = idx_song;
        elseif contains(datainfo_songdesc.dataname{i}, '_desc')
            idx_type = idx_desc;
        end

        f0filepath = strcat('./data/f0/', datainfo_songdesc.dataname{i}, '_f0.csv');
        onsetfilepath = strcat('./data/onset_break/onset_', datainfo_songdesc.dataname{i}, '.csv');
        breakfilepath = strcat('./data/onset_break/break_', datainfo_songdesc.dataname{i}, '.csv');

        datafilepath(gid_i, idx_type, :) = {f0filepath, onsetfilepath, breakfilepath};

        check_f0 = isfile(f0filepath);
        check_onset = isfile(onsetfilepath);
        check_break = isfile(breakfilepath);
        fprintf('%d%d%d - %s\n', check_f0, check_onset, check_break, datainfo_songdesc.dataname{i});
    end

    %% analysis
    populationES = false;
    N_sim = [2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 17, 20, 22, 25, 27, 30, 35, 40, 45, 50];

    if populationES
        al = 0.05;
        mu_null = 0.5;
        mu_hat_ioi = zeros(length(N_sim), 1);
        CI_ioi = zeros(length(N_sim), 2);
        mu_hat_f0 = zeros(length(N_sim), 1);
        CI_f0 = zeros(length(N_sim), 2);
        mu_hat_df0 = zeros(length(N_sim), 1);
        CI_df0 = zeros(length(N_sim), 2);
    end

    numunits = zeros(length(groupid), 2);
    t_ed = zeros(length(groupid), 2);

    p_ioi = zeros(length(groupid), length(N_sim));
    p_f0 = zeros(length(groupid), length(N_sim));
    p_df0 = zeros(length(groupid), length(N_sim));
    tau_ioi = zeros(length(groupid), length(N_sim));
    tau_f0 = zeros(length(groupid), length(N_sim));
    tau_df0 = zeros(length(groupid), length(N_sim));

    t_ed_N = zeros(length(groupid), 2, length(N_sim));
    T_N = zeros(length(groupid), 2, length(N_sim));

    meanioirate = zeros(length(groupid), 2);
    
    for j=1:length(N_sim)
        N = N_sim(j);

        for i=1:length(groupid)
            T = readtable(datafilepath{groupid(i), idx_song, 2}, 'ReadVariableNames', false, 'Format', '%f%s');
            t_onset = unique(T.Var1);
            T = readtable(datafilepath{groupid(i), idx_song, 3}, 'ReadVariableNames', false, 'Format', '%f%s');
            t_break = unique(T.Var1);
            [ioi_song, ~, ~, t_ed_song, ~] = helper.h_ioi(t_onset, t_break);
        
            T = readtable(datafilepath{i, idx_desc, 2}, 'ReadVariableNames', false, 'Format', '%f%s');
            t_onset = unique(T.Var1);
            T = readtable(datafilepath{i, idx_desc, 3}, 'ReadVariableNames', false, 'Format', '%f%s');
            t_break = unique(T.Var1);
            [ioi_desc, ~, ~, t_ed_desc, ~] = helper.h_ioi(t_onset, t_break);
            
            T = readtable(datafilepath{groupid(i), idx_song, 1});
            f0_song = table2array(T(:, 2));
            t_f0_song = table2array(T(:, 1));
            df0_song = ft_deltaf0(f0_song, t_f0_song(2) - t_f0_song(1), 440);

            T = readtable(datafilepath{groupid(i), idx_desc, 1});
            f0_desc = table2array(T(:, 2));
            t_f0_desc = table2array(T(:, 1));
            df0_desc = ft_deltaf0(f0_desc, t_f0_desc(2) - t_f0_desc(1), 440);

            numunits(groupid(i), :) = [length(ioi_song), length(ioi_desc)];
            t_ed(groupid(i), :) = [t_ed_song(end), t_ed_desc(end)];
    
            if length(ioi_song) >= N
                ioi_song_N = ioi_song(1:N);
                t_ed_N(groupid(i), idx_song, j) = t_ed_song(N);
                T_N(groupid(i), idx_song, j) = sum(ioi_song_N);
                f0_song_N = f0_song(t_f0_song <= t_ed_song(N));
                df0_song_N = df0_song(t_f0_song <= t_ed_song(N));
            else
                t_ed_N(groupid(i), idx_song, j) = NaN;
                T_N(groupid(i), idx_song, j) = NaN;
            end

            if length(ioi_desc) >= N
                ioi_desc_N = ioi_desc(1:N);
                t_ed_N(groupid(i), idx_desc, j) = t_ed_desc(N);
                T_N(groupid(i), idx_desc, j) = sum(ioi_desc_N);
                f0_desc_N = f0_desc(t_f0_desc <= t_ed_desc(N));
                df0_desc_N = df0_desc(t_f0_desc <= t_ed_desc(N));
            else
                t_ed_N(groupid(i), idx_desc, j) = NaN;
                T_N(groupid(i), idx_desc, j) = NaN;
            end
                
            if length(ioi_song) >= N && length(ioi_desc) >= N
                [p_ioi(groupid(i), j), tau_ioi(groupid(i), j), ~] = stat.pb_effectsize(1./ioi_desc_N, 1./ioi_song_N);
                [p_f0(groupid(i), j), tau_f0(groupid(i), j), ~] = stat.pb_effectsize(f0_song_N(f0_song_N > 0), f0_desc_N(f0_desc_N > 0));
                [p_df0(groupid(i), j), tau_df0(groupid(i), j), ~] = stat.pb_effectsize(-abs(df0_song_N(f0_song_N > 0)), -abs(df0_desc_N(f0_desc_N > 0)));
            else
                p_ioi(groupid(i), j) = NaN;
                tau_ioi(groupid(i), j) = NaN;
                p_f0(groupid(i), j) = NaN;
                tau_f0(groupid(i), j) = NaN;
            end

            meanioirate(groupid(i), :) = [mean(1./ioi_song(t_ed_song <= 20)) mean(1./ioi_desc(t_ed_desc <= 20))];
        end
        
        if populationES
            idx_nonnan = ~isnan(p_ioi(:, j));
            [CI_ioi(j, :), ~, mu_hat_ioi(j)] = stat.exactCI(p_ioi(idx_nonnan, j), tau_ioi(idx_nonnan, j), 2*al, mu_null);
            [CI_f0(j, :), ~, mu_hat_f0(j)] = stat.exactCI(p_f0(idx_nonnan, j), tau_f0(idx_nonnan, j), 2*al, mu_null);
            [CI_df0(j, :), ~, mu_hat_df0(j)] = stat.exactCI(p_df0(idx_nonnan, j), tau_df0(idx_nonnan, j), 2*al, mu_null);
        end
    end

    %% Plot feature ES
    for k=1:3
        if k == 1
            p = p_f0;
            figstr = 'Pitch height';

            if populationES
                mu_hat = mu_hat_f0;
            end
        elseif k == 2
            p = p_ioi;
            figstr = 'Temporal rate';

            if populationES
                mu_hat = mu_hat_ioi;
            end
        elseif k == 3
            p = p_df0;
            figstr = 'Pitch stability';

            if populationES
                mu_hat = mu_hat_df0;
            end
        end

        figobj = figure(k);
        d = sqrt(2).*norminv(p);
        plot(N_sim, d, 'Color', [0 0.4470 0.7410 0.3], 'LineWidth', 0.8);
        hold on
        yl = [floor(min(d(~isinf(d)))), ceil(max(d(:)))];
        plot([30, 30], yl, 'LineStyle', '-.', 'Color', [0.8500 0.3250 0.0980 0.9], 'LineWidth', 1.1);
        
        if populationES
            d_hat = sqrt(2).*norminv(mu_hat);
            plot(N_sim, d_hat, 'Color', [0.8500 0.3250 0.0980 0.9], 'LineWidth', 1.0);
        end
        
        hold off
        grid on
        ax = gca(figobj);
        ax.FontSize = 16;
        xlabel('Number of units', 'FontSize', 20);
        ylabel('Translated Cohen''s D', 'FontSize', 20);    
        xlim([min(N_sim) - 0.5, max(N_sim) + 0.5]);
        ylim(yl);
        title(figstr, 'FontSize', 20);
        saveas(figobj, sprintf('./output/%s.jpg', figstr));
    end

    %% N-T figure
    for k=1:2
        figobj = figure(3+k);

        if k == 1
            duration = t_ed_N;
        elseif k == 2
            duration = T_N;
        end

        for j=1:length(N_sim)
            q95_song = quantile(duration(:, 1, j), 0.95);
            q95_desc = quantile(duration(:, 2, j), 0.95);
    
            subplot(2, ceil(length(N_sim)/2), j);
            scatter(duration(:, 1, j), duration(:, 2, j));
            hold on
            plot([q95_song, q95_song], [0, 25], 'LineStyle', '-.', 'Color', "#D95319");
            plot([0, 45], [q95_desc, q95_desc], 'LineStyle', '-.', 'Color', "#D95319");
            hold off
            xlim([0, 45]);
            ylim([0, 25]);
            grid on
    
            if j <= ceil(length(N_sim)/2)
                set(gca,'xticklabel',[]);
            end
            
            if mod(j, ceil(length(N_sim)/2)) ~= 1
                set(gca,'yticklabel',[]);
            end
    
            title(sprintf('N = %d', N_sim(j)));
        end
        
        han=axes(figobj, 'visible', 'off'); 
        han.Title.Visible = 'on';
        han.XLabel.Visible = 'on';
        han.YLabel.Visible = 'on';
        ylabel(han, 'Duration of speech', 'FontSize', 18);
        xlabel(han, 'Duration of singing', 'FontSize', 18);

        saveas(figobj, sprintf('./output/N_T_%d.jpg', k));
    end
    
    %% mean ioi-rate
    figure(6);
    histogram(meanioirate(:, 1), 10);
    hold on
    histogram(meanioirate(:, 2), 10);
    hold off
    title('Collaborator-wise mean IOI-rate (20 seconds)');

    %% Save results
    T = table(arrayfun(@(id) unique(datainfo_songdesc.performer(datainfo_songdesc.groupid == id)), groupid),...
        numunits(:, 1), numunits(:, 2), t_ed(:, 1), t_ed(:, 2), 'VariableNames', {'Name', 'N_song', 'N_desc', 'T_song', 'T_desc'});
    writetable(T, './output/N_T_info.csv');
    
    %{
    T = array2table(p_ioi, 'VariableNames', {'releffect_10', 'releffect_15', 'releffect_20', 'releffect_25', 'releffect_30'});
    writetable(T, './output/p_ioi.csv');

    T = array2table(tau_ioi, 'VariableNames', {'releffectCI_10', 'releffectCI_15', 'releffectCI_20', 'releffectCI_25', 'releffectCI_30'});
    writetable(T, './output/tau_ioi.csv');

    T = array2table(reshape(t_ed_N, [length(groupid), 2*length(N_sim)]), 'VariableNames', {...
        'songduration_10', 'descduration_10', 'songduration_15', 'descduration_15', ...
        'songduration_20', 'descduration_20', 'songduration_25', 'descduration_25', 'songduration_30', 'descduration_30'});
    writetable(T, './output/t_ed_N.csv');
    %}
end

