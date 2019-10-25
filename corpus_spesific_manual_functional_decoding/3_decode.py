from __future__ import division
import pandas as pd
import numpy as np
from scipy.stats import norm
from statsmodels.sandbox.stats.multicomp import multipletests
import sys

sys.path.append('/Users/tsalo/Documents/tsalo/neurosynth/')
from neurosynth.analysis import stats


def p_to_z(p, sign):
    """
    From Neurosynth's meta.py
    """
    p = p/2  # convert to two-tailed
    # prevent underflow
    p[p < 1e-240] = 1e-240
    # Convert to z and assign tail
    z = np.abs(norm.ppf(p)) * sign
    # Set very large z's to max precision
    z[np.isinf(z)] = norm.ppf(1e-240)*-1
    return z


def decode(df, selected, prior=None, u=0.05):
    """
    Will require multiple comparisons correction.
    Can be used with BrainMap database as well.
    Taken from Neurosynth's meta-analysis method.
    
    Employs Benjamini-Hochberg FDR-correction
    """
    pmids = df.index.tolist()
    terms = df.columns.values
    unselected = list(set(pmids) - set(selected))
    sel_array = df.loc[selected].values
    unsel_array = df.loc[unselected].values
    
    n_selected = len(selected)
    n_unselected = len(unselected)

    n_selected_active = np.sum(sel_array, axis=0)
    n_unselected_active = np.sum(unsel_array, axis=0)
    
    n_selected_inactive = n_selected - n_selected_active
    n_unselected_inactive = n_unselected - n_unselected_active
    
    n_active = n_selected_active + n_unselected_active
    n_inactive = n_selected_inactive + n_unselected_inactive
    
    pF = n_selected / (n_selected + n_unselected)
    pA = (n_selected_active + n_unselected_active) / (n_selected + n_unselected)
    pAgF = n_selected_active * 1.0 / n_selected  # p(term presence given in cluster)
    pAgU = n_unselected_active * 1.0 / n_unselected
    pFgA = pAgF * pF / pA  # Conditional probability (in cluster given term presence)

    # Recompute conditions with empirically derived prior
    if prior is None:
        prior = pF
    
    pAgF_prior = prior * pAgF + (1 - prior) * pAgU
    pFgA_prior = pAgF * prior / pAgF_prior
    
    # One-way chi-square test for consistency of activation
    p_fi = stats.one_way(n_selected_active, n_selected)
    sign_fi = np.sign(n_selected_active - np.mean(n_selected_active)).ravel()
    z_fi = p_to_z(p_fi, sign_fi)

    # Two-way chi-square test for specificity of activation
    cells = np.array([[n_selected_active, n_unselected_active],
                      [n_selected_inactive, n_unselected_inactive]]).T
    p_ri = stats.two_way(cells)
    sign_ri = np.sign(pAgF - pAgU).ravel()
    z_ri = p_to_z(p_ri, sign_ri)
        
    # FDR
    sig_fi, corr_fi, _, _ = multipletests(p_fi, alpha=u, method='fdr_bh',
                                          returnsorted=False)
    sig_ri, corr_ri, _, _ = multipletests(p_ri, alpha=u, method='fdr_bh',
                                          returnsorted=False)

    out_p = np.array([corr_fi, z_fi, pAgF_prior, corr_ri, z_ri, pFgA_prior]).T

    out_df = pd.DataFrame(columns=['pForward', 'zForward', 'probForward', 'pReverse', 'zReverse', 'probReverse'],
                          data=out_p)
    out_df['Term'] = terms
    out_df = out_df[['Term', 'pForward', 'zForward', 'probForward', 'pReverse', 'zReverse', 'probReverse']]
    return out_df
