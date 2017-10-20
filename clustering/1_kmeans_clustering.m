for a = 1:numel(Experiments)
    if length(find(strcmp(Experiments(a).Experiments.Paradigm_Class, 'Reward'))) > 0
        isrewardexp(a) = 1;
    elseif length(find(strcmp(Experiments(a).Experiments.Paradigm_Class, 'Gambling'))) > 0
        isrewardexp(a) = 1;
    elseif length(find(strcmp(Experiments(a).Experiments.Paradigm_Class, 'Delay Discounting'))) > 0
        isrewardexp(a) = 1;
    else
        isrewardexp(a) = 0;
    end
end

RewardExps = Experiments(find(isrewardexp));
masklocs = find(spm_read_vols(spm_vol('Tal_2x2x2_mask.nii.gz')));

RewardExps = BMA_ModeledActivationImgs(RewardExps);
save('RewardExperiments.mat', 'RewardExps');

for a = 1:numel(RewardExps)
    voxval(:, a) = tempimg.ModActs(masklocs);
    clear tempimg
    a
end

corrmat = corr(voxval);

rmpath /Users/riedel/Documents/MATLAB/spm12/external/fieldtrip/external/stats/
for a = 2:8
    [IDX{a-1},C{a-1},SUMD{a-1},D{a-1}] = kmeans(corrmat,a,'distance','correlation','emptyaction','singleton','start','cluster','replicates',25, 'options',statset('MaxIter',1023));
end
addpath /Users/riedel/Documents/MATLAB/spm12/external/fieldtrip/external/stats/

kmeans_metrics

cluster_sol = IDX{3};
for a = 1:max(cluster_sol)
    cluster_exps{a} = RewardExps(find(cluster_sol==a));
end

SigMetaData = BMA_ForRevInf(cluster_exps);

for a = 1:max(cluster_sol)
    templateline = '//Reference=Talairach';
    thefilname = strcat('Reward_Cluster_03162016_', num2str(a), '_of_', num2str(max(cluster_sol)), '.txt');
    fid = fopen(thefilname, 'w');
    fprintf(fid, '%s\n', templateline);
    fclose(fid);
    secondstarters = cluster_exps{a};

    for b = 1:numel(secondstarters)
        fid = fopen(thefilname, 'a');
        subnum = secondstarters(b).Subject_Total;
        subnum = num2str(subnum);
        fprintf(fid, '%s\n', strcat('//Subjects=',subnum));
        clear subnum
        peaknum = secondstarters(b).Peaks;
        for c = 1:peaknum
            checkpts = secondstarters(b).XYZmm_Tal(c,:);
            fprintf(fid, '%f\t%f\t%f\n', [checkpts(1) checkpts(2) checkpts(3)]);
            clear checkpts
        end
        clear peaknum
        fprintf(fid, '%s\n', '');
        fclose(fid);
    end
    clear secondstarters
end

for a = 1:max(cluster_sol)-1
    for b = (a+1):max(cluster_sol)
        templateline = '//Reference=Talairach';
        thefilname = strcat('Reward_Cluster_03162016_', num2str(a), '_and_', num2str(b), '_of_', num2str(max(cluster_sol)), '.txt');
        fid = fopen(thefilname, 'w');
        fprintf(fid, '%s\n', templateline);
        fclose(fid);
        secondstarters = [cluster_exps{a} cluster_exps{b}];

        for b = 1:numel(secondstarters)
        fid = fopen(thefilname, 'a');
        subnum = secondstarters(b).Subject_Total;
        subnum = num2str(subnum);
        fprintf(fid, '%s\n', strcat('//Subjects=',subnum));
        clear subnum
        peaknum = secondstarters(b).Peaks;
        for c = 1:peaknum
        checkpts = secondstarters(b).XYZmm_Tal(c,:);
        fprintf(fid, '%f\t%f\t%f\n', [checkpts(1) checkpts(2) checkpts(3)]);
        clear checkpts
        end
        clear peaknum
        fprintf(fid, '%s\n', '');
        fclose(fid);
        end
        clear secondstarters
    end
end
