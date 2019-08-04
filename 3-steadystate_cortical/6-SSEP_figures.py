
##################################################
## Project: Binaural Beats
## Script purpose: Plotting of steady state cortical responses
## Author: Hector D Orozco Perez
## Contact: hector.dom.orozco@gmail.com
## License: GNU GPL v3
##################################################

import glob
import xlrd

import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import seaborn as sns
import pandas as pd

# Theta SSEP
SSEPtheta = pd.read_csv('SSEP7_fig_no_outliers.csv') #I edited this manually
SSEPtheta['Frequency'] = SSEPtheta['Frequency'].astype('category')
SSEPtheta['Type'] = SSEPtheta['Type'].astype('category')

plt.clf()
sns.set_style('darkgrid', {'legend.frameon': True})
g = sns.violinplot(x="Type", y='Power [dB]',
                hue="Frequency", data=SSEPtheta, palette="Paired",
                showfliers=False)
plt.tight_layout()
g.figure.savefig('/Users/hectorOrozco/Desktop/binauralBeats/analysis/'
                 '3-steadystate_cortical/SSEPtheta_boxplot.eps',
                 format='eps', dpi=1000)

# Gamma SSEP
SSEPgamma = pd.read_csv('SSEP40_fig_no_outliers.csv') #I edited this manually
SSEPgamma['Frequency'] = SSEPgamma['Frequency'].astype('category')
SSEPgamma['Type'] = SSEPgamma['Type'].astype('category')

plt.clf()
sns.set_style('darkgrid', {'legend.frameon': True})
g = sns.violinplot(x="Type", y='Power [dB]',
                hue="Frequency", data=SSEPgamma, palette="Paired",
                showfliers=False)
plt.tight_layout()
g.figure.savefig('/Users/hectorOrozco/Desktop/binauralBeats/analysis/'
                 '3-steadystate_cortical/SSEPgamma_boxplot.eps',
                 format='eps', dpi=1000)




