function plot_figure3()
	%%
	outputdir_fig = './output/';
	audio_song = './data/figure3/Patrick Savage_Twinkle Twinkle_Song.wav';
	f0_song = './data/figure3/Patrick Savage_Twinkle Twinkle_Song_f0.csv';
	onset_song = './data/figure3/onset_Patrick Savage_Twinkle Twinkle_Song.csv';
	break_song = './data/figure3/break_Patrick Savage_Twinkle Twinkle_Song.csv';

    %%
    T = readtable(f0_song);
    t_f0_song = T.time;
    f0_song = T.voice_1;
    
    %%
    T = readtable(onset_song);
    t_onset_song = table2array(T(:, 1));

    T = readtable(break_song);
    t_break_song = table2array(T(:, 1));

    %%
    [s_song, fs_song] = audioread(audio_song);
    s_song = mean(s_song, 2);

    [S, F_song, T_song] = spectrogram(s_song, hann(2048), 2048*3/4, 2048, fs_song);
    P_song = 10.*log10(abs(S).^2) - 100;
    
    %% Figure object
    fobj = figure;
    clf; cla;
    fobj.Position = [50, 540, 1000, 450];
    
    %% First window
    subplot(5, 1, 1:4);

    xl = [0.2, 8.6];
    yl = 1200.*log2([60, 1000]./440);
    axFontSize = 12;

    % Spectrogram
    C = 1200.*log2(F_song./440);

    surf(T_song, C, P_song, 'EdgeColor', 'none');
    view(0, 90);
    axis tight;
    hold on

    % F0 contour
    f0_C_song = 1200.*log2(f0_song./440);
    scatter(t_f0_song, f0_C_song, 'MarkerEdgeColor', 'r', 'Marker', '.');

    % Onset and break annotations
    for i=1:numel(t_onset_song)
        plot(t_onset_song(i).*[1, 1], yl, 'Color', '#FF00FF', 'LineWidth', 1.2);
    end
    for i=1:numel(t_break_song)
        plot(t_break_song(i).*[1, 1], yl, 'Color', '#0000CD', 'LineWidth', 1.2, 'LineStyle', '-.');
    end
    
    LEGEND_POS_LEFT = 0.720;
    LEGEND_POS_BOTTOM = 0.720;
    LEGEND_WIDTH = 0.080;
    LEGEND_HEIGHT = 0.150;
   
    h = zeros(3, 1);
    h(1) = plot(NaN, NaN, 'Color', '#FF0000', 'LineWidth', 1.2);
    h(2) = plot(NaN, NaN, 'Color', '#FF00FF', 'LineWidth', 1.2);
    h(3) = plot(NaN, NaN, 'Color', '#0000CD', 'LineStyle', '-.', 'LineWidth', 1.2);
    legend(h, {'f_0', 'Onset', 'Breath'}, 'FontName', 'Times New Roman', 'FontSize', 14,...
        'Position', [LEGEND_POS_LEFT, LEGEND_POS_BOTTOM, LEGEND_WIDTH, LEGEND_HEIGHT]);
    
    % text annotation
    TEXT_POS_BOTTOM = 0.880;
    TEXT_POS_LEFT = [0.174, 0.220, 0.265, 0.302, 0.341, 0.382, 0.424...
        0.473, 0.503, 0.542, 0.587, 0.624, 0.662, 0.704, 0.738, 0.792];
    strlist = {'|Twin', '|kle', '|twin', '|kle', '|li', '|ttle', '|star'...
        , '/', '|how', '|I', '|won', '|der', '|what', '|you', '|are', '/'};
    for i=1:numel(TEXT_POS_LEFT)
        annotation('textbox', [TEXT_POS_LEFT(i), TEXT_POS_BOTTOM, 0.1, 0.1], 'String', strlist{i}, 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14, 'FontAngle', 'Italic');  
    end

    TEXT_POS_LEFT = 0.840;
    annotation('textbox', [TEXT_POS_LEFT, 0.72, 0.1, 0.1], 'String', 'List of features', 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14);
    annotation('textbox', [TEXT_POS_LEFT + 0.005, 0.78, 0.085, 0.0], 'String', '');
    annotation('textbox', [TEXT_POS_LEFT, 0.65, 0.1, 0.1], 'String', '1. Pitch height', 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14);
    annotation('textbox', [TEXT_POS_LEFT + 0.013, 0.60, 0.1, 0.1], 'interpreter', 'latex', 'String', '($$f_0$$)', 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14);
    annotation('textbox', [TEXT_POS_LEFT, 0.55, 0.1, 0.1], 'String', '2. Temporal rate', 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14);
    annotation('textbox', [TEXT_POS_LEFT + 0.013, 0.50, 0.1, 0.1], 'interpreter', 'latex', 'String', '(IOI rate)', 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14);
    annotation('textbox', [TEXT_POS_LEFT, 0.45, 0.1, 0.1], 'String', '3. Pitch stability', 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14);
    annotation('textbox', [TEXT_POS_LEFT + 0.013, 0.40, 0.1, 0.1], 'interpreter', 'latex', 'String', '($$-|\Delta f_0|$$)', 'EdgeColor', 'none', 'FontName', 'Times New Roman', 'FontSize', 14);
    
    hold off
    xlim(xl);
    ylim(yl);

    ax = gca(fobj);
    ax.FontSize = axFontSize;
    ax.Position(3) = 0.7;

    ylabel('Cent [440 Hz = 0]', 'FontSize', 13);
   
    %% Second window
    subplot(5, 1, 5);

    % Delta f0
    df0 = ft_deltaf0(f0_song, 0.005, 440);
    plot(t_f0_song, df0);
    xlim(xl);
    yticks([-4000, 0, 4000, 8000]);
    ylim([-4000, 9000]);

    ax = gca(fobj);
    ax.FontSize = axFontSize;
    ax.Position(3) = 0.7;

    xlabel('Time (sec.)', 'FontSize', 13);
    
    legend({'\Delta f_0'}, 'FontName', 'Times New Roman', 'FontSize', 14,...
        'Position', [LEGEND_POS_LEFT, 0.185, LEGEND_WIDTH, 0.030]);

    %%
    saveas(fobj, strcat(outputdir_fig, '/figure3.png'))
end
