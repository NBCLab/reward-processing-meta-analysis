#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 31 12:12:22 2017

@author: tsalo
"""
import pandas as pd
import decode

df1 = pd.read_csv('clusters.csv')
df2 = pd.read_csv('terms.csv', index_col='id')

for c in sorted(df1['cluster'].unique()):
    sel_ids = df1.loc[df1['cluster']==c]['id'].values
    p_df = decode.decode(df2, sel_ids)
    p_df.to_csv('cluster{0}_pvalues.csv'.format(c), index=False)
