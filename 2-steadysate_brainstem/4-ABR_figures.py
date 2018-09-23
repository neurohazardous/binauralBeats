import glob
import xlrd

import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import seaborn as sns
import pandas as pd

# Initial parameters

# Theta relevant
ABRtheta = pd.read_csv('ABRtheta_relevanTones_fig.csv') #I edited this manually
ABRtheta['Frequency'] = ABRtheta['Frequency'].astype('category')
ABRtheta['Type'] = ABRtheta['Type'].astype('category')

plt.clf()
sns.set_style('darkgrid', {'legend.frameon': True})
g = sns.violinplot(x="Type", y='Power [dB]',
                hue="Frequency", data=ABRtheta, palette="Paired")
plt.tight_layout()
g.figure.savefig('/Users/hectorOrozco/Desktop/binauralBeats/analysis/'
                 '2-steadysate_brainstem/ABRtheta_boxplot.eps',
                 format='eps', dpi=1000)

# Gamma relevant
ABRgamma = pd.read_csv('ABRgamma_relevanTones_fig.csv') #I edited this manually
ABRgamma['Frequency'] = ABRgamma['Frequency'].astype('category')
ABRgamma['Type'] = ABRgamma['Type'].astype('category')

plt.clf()
sns.set_style('darkgrid', {'legend.frameon': True})
g = sns.violinplot(x="Type", y='Power [dB]',
                hue="Frequency", data=ABRgamma, palette="Paired")
plt.tight_layout()
g.figure.savefig('/Users/hectorOrozco/Desktop/binauralBeats/analysis/'
                 '2-steadysate_brainstem/ABRgamma_boxplot.eps',
                 format='eps', dpi=1000)




