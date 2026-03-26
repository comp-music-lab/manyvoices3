function [ioi, ioiratio, t_st, t_ed, ioipair] = h_ioi(t_onset, t_break)
    %%
    ioi = [];
    t_st = [];
    t_ed = [];
    ioiratio = [];
    ioipair = [];

    %%
    N = numel(t_onset);
    for i=2:N
        idx = t_onset(i - 1) < t_break & t_break < t_onset(i);
        t_break_i = t_break(idx);

        if isempty(t_break_i)
            ioi(end + 1) = t_onset(i) - t_onset(i - 1);
            t_st(end + 1) = t_onset(i - 1);
            t_ed(end + 1) = t_onset(i);
        else
            ioi(end + 1) = t_break_i - t_onset(i - 1);
            t_st(end + 1) = t_onset(i - 1);
            t_ed(end + 1) = t_break_i;
        end
    end

    if ~isempty(t_break) && t_break(end) > t_onset(end)
        ioi(end + 1) = t_break(end) - t_onset(end);
        t_st(end + 1) = t_onset(end);
        t_ed(end + 1) = t_break(end);
    end

    idx = ioi ~= 0;
    ioi = ioi(idx);
    t_st = t_st(idx);
    t_ed = t_ed(idx);

    %%
    for i=2:numel(ioi)
        if t_st(i) == t_ed(i - 1)
            ioiratio(end + 1) = ioi(i)/(ioi(i) + ioi(i - 1));
            ioipair(end + 1, :) = [ioi(i - 1), ioi(i)];
        end
    end
end