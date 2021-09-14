# <multiple peaks/fit_multiple_peaks.py>
# 08/Aug/2021
# fit multiple peaks in KAUST

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import tkinter as tk
from tkinter import *
from sklearn.mixture import GaussianMixture
from lmfit.models import LorentzianModel, QuadraticModel, GaussianModel, LinearModel, ConstantModel
from lmfit.model import Model, save_model, save_modelresult

# get data
fit_raw = pd.read_table('latest_0040546_caz.dat', header=None)
fit = pd.DataFrame(fit_raw)
x = fit[0]
y = fit[1]
print(fit.shape)

# fit by Models
model_name = 'gs'
"""input 'gs' or 'lz'"""


def add_models(prefix, center, amplitude, sigma):
    if model_name == 'gs':
        peak = GaussianModel(prefix=prefix)
    if model_name == 'lz':
        peak = LorentzianModel(prefix=prefix)
    peak.set_param_hint('center', min=center - 0.5, max=center + 0.5)
    """input range for center"""
    pars = peak.make_params()
    pars[prefix + 'center'].set(center)
    pars[prefix + 'amplitude'].set(amplitude, min=0)
    pars[prefix + 'sigma'].set(sigma, min=0)
    return peak, pars


# model = QuadraticModel(prefix='bkg_')
model = LinearModel(prefix='bkg_')
# model = ConstantModel(prefix='bkg_')
# params = model.make_params(a=0, b=0, c=0.1)
model.set_param_hint('slope', value=0, min=0, max=0.000000001)
model.set_param_hint('intercept', value=0.3, min=0)
params = model.make_params()

# Composite Models
rough_peak_positions = [[21.4, 1000, 0.1], [22.1, 200, 2], [23.2, 300, 0.2]]
"""input init value: center, amplitude, sigma"""
for i, element in enumerate(rough_peak_positions):
    peak, pars = add_models('model%d_' % (i + 1), center=element[0], amplitude=element[1], sigma=element[2])
    model = model + peak
    params.update(pars)

# output by models
init = model.eval(params, x=x)
result = model.fit(y, params, x=x)
comps = result.eval_components()
dely = result.eval_uncertainty(sigma=3)
# conf_interval=result.conf_interval()
result.plot()
print(comps)

list_comps = list[comps.items()]
list[comps.values()]

print(comps.items())
print(dely)
# print(result.ci_report())
print(result.fit_report(min_correl=0.1))
save_model(model, "composite models.sav")
save_modelresult(result, 'model results.sav')
file0 = open('fit data_one.dat', 'wt')
pred = []
for name, comp in comps.items():
    file0.write(str(comp[1]))
# file0.write(str(comps.items().name))
file0.close()
try:
    file1 = open('fit data.dat', "wt")
    file1.write(list_comps['bkg_'])
    file2 = open('fit report.dat', "wt")
    file2.write(str(result.fit_report(min_correl=0.1)))
finally:
    file1.close()
    file2.close()

# plot original, fit curves
plt.plot(x, y, label='original data')
# plt.plot(x, init, label='supplied parameters fit')
plt.plot(x, result.best_fit, label='best fit')
plt.fill_between(x, result.best_fit - dely, result.best_fit + dely, color="#ABABAB",
                 label='3-$\sigma$ uncertainty band')
for name, comp in comps.items():
    # print(name)
    plt.plot(x, comp, '--', label=name[0:6])
plt.legend(loc='upper right')  # local='best' or loc=4 or local='upper right'
plt.title("Fit for Multiple Peaks")
plt.xlabel('x')
plt.ylabel('y')
plt.show()
# <end multiple peaks/fit_multiple_peaks.py>

# Human Machine Interface
top = Tk()
top.title("Fit for Multiple Peaks")
top.geometry('1000x600')
var = tk.StringVar()
tk.Label(top, textvariable=var, bg='green', fg='white', font=('Arial', 12), width=30, height=2).pack()
# tk.Label(top, textvariable=var, text='Fitting', bg='green', fg='white', font=('Arial', 12), width=30, height=2).pack()
Button(top, text='parameters', fg="white", bg="blue", command=add_peak).pack(side=LEFT)
Entry(top, show=None, font=('Arial', 14)).pack()

model_select = tk.StringVar()
l = tk.Label(top, text='Model Selection', bg='green', fg='white', font=('Arial', 12), width=20,
             textvariable=model_select)
l.pack()


def model_selection():
    l.config(text='Model Selection' + model_select.get())


model1 = tk.IntVar()
model2 = tk.IntVar()
c1 = tk.Checkbutton(top, text='gs', variable=model1, onvalue=1, offvalue=0, command=model_selection)
c1.pack()
c2 = tk.Checkbutton(top, text='lz', variable=model2, onvalue=1, offvalue=0, command=model_selection)
c2.pack()

r1 = tk.Radiobutton(top, text='gs', variable=model_select, value='gs', command=model_selection)
r1.pack()
r2 = tk.Radiobutton(top, text='lz', variable=model_select, value='lz', command=model_selection)
r2.pack()

range_select = tk.StringVar()
range = tk.Label(top, text='Range', bg='green', fg='white', font=('Arial', 12), width=20,
                 textvariable=range_select)
range.pack()


def range_selection():
    range.config(text='Range' + range_select.get())


s = tk.Scale(top, label='range', from_=0, to=10, orient=tk.HORIZONTAL, length=200, showvalue=0, tickinterval=2,
             resolution=0.01, command=range_selection)
s.pack()




model_parameters = ['center', 'amplitude', 'sigma']
model_center_range = ['mix', 'max']
listb = Listbox(top)
listb2 = Listbox(top)
for item in model_parameters:
    listb.insert(0, item)
for item in model_center_range:
    listb2.insert(0, item)
listb.pack(side='left')
listb2.pack(side='right')  # top, bottom, left, right

mainloop()

# cmd
