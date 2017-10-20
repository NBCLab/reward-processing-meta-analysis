#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 31 11:29:11 2017
Read in Flannery's files and make them pretty.

@author: tsalo
"""

import pandas as pd
import numpy as np

f1 = 'ForRev_input_Reward.csv'
f2 = 'cluster_ID.csv'

df1 = pd.read_csv(f1)
new_vals = {}
for i in df1.index:
    id_ = df1.loc[i].values[0].astype(str) + '-' + df1.loc[i].values[2].astype(str)
    vals = [v for v in df1.loc[i].values[3:] if not pd.isnull(v)]
    new_vals[id_] = vals

all_terms = sorted(list(set([i for sl in new_vals.values() for i in sl])))
df3 = pd.DataFrame(index=new_vals.keys(), columns=all_terms, data=np.zeros((len(new_vals.keys()), len(all_terms)), int))
for i, vs in new_vals.items():
    for v in vs:
        df3.loc[i][v] = 1
df3.to_csv('terms.csv', index_label='id')


df2 = pd.read_csv(f2)
df2['id'] = df2['PubMed ID'].astype(str) + '-' + df2['Exp ID'].astype(str)
df2.drop(['PubMed ID', 'Bmap ID', 'Exp ID'], axis=1, inplace=True)
df2 = df2[['id', 'cluster']]

df2.to_csv('clusters.csv', index=False)

df4 = df2.join(df3, on='id', how='right')
count_df = df4.groupby('cluster').sum()
count_df.index = ['cluster {0}'.format(i) for i in count_df.index]
total_row = count_df.sum(numeric_only=True)
total_row.name = 'total'
count_df = count_df.append(total_row, ignore_index=False).transpose()
count_df.index.name = 'term'
count_df.to_csv('term_counts.csv', index=True, index_label='cluster')
