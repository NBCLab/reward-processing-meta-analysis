Steps:

Step 0: Get database dump from BrainMap (http://brainmap.org/collaborations.html). You will have to sign up as a collaborator.

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
Or use BMA_ModeledActivationImgs to make the MA maps (this script is called within 1_kmeans_clustering script)

Step 4: grab experiments meeting inclusion criteria, run k means clustering
```Matlab
1_kmeans_clustering;
```

Step 5: run k means clustering group separation and group stability metrics (Average Silhouette, Variation of Information, Hierarchy Index, Cluster Consistency)
```Matlab
2_kmeans_metrics;
```
This script creates four subplots, this will save the following variables in the file metrics.mat:

`avg_sil_sig`, `cluster_consistency`, `VI`, `HI` 
