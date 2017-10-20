count1=(1)
for a in "${count1[@]}"; do
    echo $a
    if [[ a -eq 1 ]]; then
        count2=(3)
    fi
    for b in "${count2[@]}"; do
        echo $b
        java -cp GingerALE.jar org.brainmap.meta.getALE2 Reward_Cluster_03162016_"$a"_and_"$b"_of_4.txt -mask=Tal_wb_dil.nii -perm=1000 -clust=0.05 -p=0.001 -nonAdd -ale=Reward_Cluster_03162016_"$a"_and_"$b"_of_4_ALE.nii -pval=Reward_Cluster_03162016_"$a"_and_"$b"_of_4_P.nii -thresh=Reward_Cluster_03162016_"$a"_and_"$b"_of_4_ALE_C05_1k.nii

        java -cp GingerALE.jar org.brainmap.meta.getClustersOnly Reward_Cluster_03162016_"$a"_and_"$b"_of_4_ALE_C05_1k.nii -out=Reward_Cluster_03162016_"$a"_and_"$b"_of_4_clust.nii

        java -cp GingerALE.jar org.brainmap.meta.getClustersStats Reward_Cluster_03162016_"$a"_and_"$b"_of_4.txt Reward_Cluster_03162016_"$a"_and_"$b"_of_4_ALE_C05_1k.nii Reward_Cluster_03162016_"$a"_and_"$b"_of_4_clust.nii

    done
done