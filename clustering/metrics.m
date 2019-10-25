for a = 1:5
    tmp_exp = Experiments(find(cluster_sol==a));
    numel(tmp_exp)
    tmp_unstudy = unique([tmp_exp.BMid]);
    for b = 1:length(tmp_unstudy)
        con_per_study(b) = length(find([tmp_exp.BMid] == tmp_unstudy(b)));
        foci_per_study(b) = sum([tmp_exp([find([tmp_exp.BMid] == tmp_unstudy(b))]).Peaks]);
    end
    max_con_per_study(a) = max(con_per_study);
    min_con_per_study(a) = min(con_per_study);
    avg_con_per_study(a) = mean(con_per_study);
    perc_con_per_study(a) = 100*max(con_per_study)/numel(tmp_exp);
    perc_foci_per_study(a) = 100*max(foci_per_study)/sum([tmp_exp.Peaks]);
    foci_per_cluster(a) = sum([tmp_exp.Peaks]);
    clear tmp_exp tmp_unstudy con_per_study b foci_per_study
end