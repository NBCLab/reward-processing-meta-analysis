Steps:

Step 0: Get database dump from BrainMap (link). You will have to sign up as a collaborator.

Step 1: open MatLab

Step 2: load experiment structure of all experiments in BrainMap database in workspace
```Matlab
LV = load(databaseFile.mat);
Experiments = LV.Experiments;
```

Step 3: Create modeled activation (MA) map for each experiment in database.
```Matlab
Experiments = 1_make_ma_maps(Experiments);
```

Step 4: grab experiments meeting inclusion criteria, run k means clustering
```Matlab
2_kmeans_clustering;
```

Step 5: run k means clustering group separation and group stability metrics (Average Silhouette, Variation of Information, Hierarchy Index, Cluster Consistency)
```Matlab
3_kmeans_metrics;
```
This script creates four subplots, this will save the following variables in the file metrics.mat:

`avg_sil_sig`, `cluster_consistency`, `VI`, `HI` 
