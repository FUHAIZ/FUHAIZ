# <correlation_function_interface_distribution_function_final.py>
# 24/Aug/2021-14/Sep/2021
# fit correlation function and interface distribution function in KAUST
# author: Fuhai Zhou
# last revision: 14/Sep/2021

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math
import tkinter as tk
from tkinter import *
from sklearn.mixture import GaussianMixture
from scipy.optimize import curve_fit, minimize, shgo
from lmfit.model import Model, save_model, save_modelresult
from lmfit import Parameters
from sympy import *
from scipy import integrate
from scipy.fftpack import fft, ifft

# get data
fit = pd.read_table('Iq2.dat', header=None)
# fit = pd.read_table('s-I.dat', header=None)
# fit = np.array(fit, dtype=float)
s = fit[0] / (2 * np.pi)  # fit[0] / (2 * np.pi), it depends s or Q
Is = fit[1] / ((fit[0] / (2 * np.pi)) ** 2)
# s = fit[0]
# Is = fit[1]
print(fit.shape)

# in the range of high s
s_cut = s[110:]
Is_cut = Is[110:]

# get p, c
b = 1.6  # Typical values for 𝜎 are in the range between 1 and 2 nm, a larger value of 𝜎 in the window function 𝜔(s) can be used to make the function 16𝜋3[P − Iabss4]𝜔(s) decrease to zero
ds = s[1] - s[0]


# define porod
def porod(x, *p):
    """Porod fit, maybe Iabs(s)≈ Ps−4 + c1*s2 + c2, here Iabs(s)≈ Ps−4 + c, let c1 be 0.
    For real data, the intensity contains, in addition,
    a constant contribution from thermal density fluctuations within the amorphous phase c2
    and a contribution proportional to s2 from the amorphous halo."""
    return p[0] / (x ** 4) + p[1]


# Porod fit by scipy.optimize import minimize
# R square as a loss function
err = lambda p: (np.sum((porod(s_cut, *p) - Is_cut) ** 2) / np.sum((Is_cut - np.mean(Is_cut)) ** 2))


# get coefficients of function by minimize
cons = (
    {'type': 'eq', 'fun': lambda p: np.sum(
        16 * (np.pi ** 3) * (p[0] - (Is - p[1]) * (s ** 4)) * np.exp(-4 * (np.pi ** 2) * (s ** 2) * (b ** 2)) * ds)}
)

# results of Porod fit
x0 = np.array((0.0001, 0.01))  # initial value
bounds = [(0, None), (0, None)]  #
res = minimize(err, x0=x0, method='SLSQP', bounds=bounds, constraints=cons, tol=1e-11)  # COBYLA, trust-constr
# res = minimize(err, x0, method='SLSQP', bounds=bounds)
# print(res)
# print('minimal value: ', res.fun)
print('optimal solution of Porod fit: ', res.x)
# print('message: ', res.message)
# print('whether success: ', res.success)
print('R2 of Porod fit: ', 1 - res.fun)
p = np.array(res.x[0], dtype=float)
c = np.array(res.x[1], dtype=float)
y = Is - c  # corrected data

# Function 16𝜋3[P − Is4]𝜔 as calculated from I(s), w is window/smoothing function
y_c = 16 * (np.pi ** 3) * (p - y * (s ** 4)) * np.exp(-4 * (np.pi ** 2) * (s ** 2) * (b ** 2))


# define functions
def ha(x, ha_amp, ha_wid, ha_cen):
    """ha fit"""
    return (ha_amp / (sqrt(2 * np.pi) * ha_wid)) * np.exp(-(x - ha_cen) ** 2 / (2 * ha_wid ** 2))


def hc(x, hc_amp, hc_wid, hc_cen):
    """hc fit"""
    return (hc_amp / (sqrt(2 * np.pi) * hc_wid)) * np.exp(-(x - hc_cen) ** 2 / (2 * hc_wid ** 2))


def hac(x, hac_amp, hac_wid, hac_cen):
    """hc fit"""
    return (hac_amp / (sqrt(2 * np.pi) * hac_wid)) * np.exp(-(x - hac_cen) ** 2 / (2 * hac_wid ** 2))


def idf(s, *par):
    """interface distribution function fit"""
    wa, da, wc, dc = par
    y_simulation = 16 * (np.pi ** 3) * p * np.exp(-4 * (np.pi ** 2) * (s ** 2) * (b ** 2)) * \
                   (np.exp(-2 * (np.pi ** 2) * (s ** 2) * (wa ** 2)) * np.cos(2 * np.pi * s * da) + np.exp(
                       -2 * (np.pi ** 2) * (s ** 2) * (wc ** 2)) * np.cos(2 * np.pi * s * dc)
                    - 2 * np.exp(-2 * (np.pi ** 2) * (s ** 2) * (wa ** 2 + wc ** 2)) * np.cos(2 * np.pi * s * (da + dc))
                    - np.exp(-4 * (np.pi ** 2) * (s ** 2) * (wa ** 2)) * np.exp(
                               -2 * (np.pi ** 2) * (s ** 2) * (wc ** 2)) * np.cos(2 * np.pi * s * dc)
                    - np.exp(-4 * (np.pi ** 2) * (s ** 2) * (wc ** 2)) * np.exp(
                               -2 * (np.pi ** 2) * (s ** 2) * (wa ** 2)) * np.cos(2 * np.pi * s * da)
                    + 2 * np.exp(-4 * (np.pi ** 2) * (s ** 2) * (wa ** 2 + wc ** 2))
                    ) / \
                   (1 - 2 * np.exp(-2 * (np.pi ** 2) * (s ** 2) * (wa ** 2 + wc ** 2)) * np.cos(
                       2 * np.pi * s * (da + dc)) + np.exp(-4 * (np.pi ** 2) * (s ** 2) * (wa ** 2 + wc ** 2)))
    #
    # n = 0.00325  # For the data shown below, a value of 𝜎A = 0.00325 nm−1 was assumed.
    # a_s = np.exp(- s * s / (2 * n * n)) / (n * (2 * np.pi) ** 0.5)
    # return y_simulation * a_s
    return y_simulation


# resolution function, final simulation of k(s), something confused
n = 0.00325  # For the data shown below, a value of 𝜎A = 0.00325 nm−1 was assumed.
a_s = np.exp(- s ** 2 / (2 * n ** 2)) / (n * math.sqrt(2 * np.pi))
# k_simulation_final = y_c * a_s

# fit by scipy.optimize import minimize
# loss function for fit
# R square as a function of the parameters
err_z = lambda par: (np.sum((idf(s, *par) - y_c) ** 2) / np.sum((y_c - np.mean(y_c)) ** 2))
# least square method
# err_z = lambda par: (np.sum((idf(s, *par) - y_c) ** 2))

# get coefficients of function by minimize
# cons_z = (
#     # {'type': 'ineq', 'fun': lambda x: x},
#     {'type': 'eq', 'fun': lambda par: par[0] - 1},
#     {'type': 'eq', 'fun': lambda par: par[3] - 1},
# )

# results of fit
x0_z = np.array((3, 2, 4, 9.5))  # initial value
bounds_z = [(0, 30), (0, 30), (0, 30), (0, 30)]
res_z = minimize(err_z, x0=x0_z, method='SLSQP', bounds=bounds_z, tol=1e-11)  # COBYLA, trust-constr
# res_z = minimize(err_z, x0=x0_z, method='SLSQP', constraints=cons_z, bounds=bounds_z, tol=1e-11)  # COBYLA, trust-constr
print(res_z)
# print('minimal value: ', res_z.fun)
print('optimal solution for interface distribution function: ', res_z.x)
# print('message: ', res_z.message)
# print('whether success: ', res_z.success)
print('R2: ', 1 - res_z.fun)

# fit by lmfit
# kz_second_derivative = Model(idf)
# kz_second_derivative.set_param_hint('wa', value=4, min=0, max=30)
# kz_second_derivative.set_param_hint('da', value=4, min=0, max=30)
# kz_second_derivative.set_param_hint('wc', value=4, min=0, max=30)
# kz_second_derivative.set_param_hint('dc', value=4, min=0, max=20)
# params = kz_second_derivative.make_params()
# kz_sd_result = kz_second_derivative.fit(y_c, params, method='leastsq',
#                                         s=s)  # methond=least_squares, leastsq, shgo, differential_evolution, brute, basinhopping
# # kz_sd_result = kz_second_derivative.fit(kz_double_dot, x=kz_z, ha_wid=1, ha_cen=1, hc_wid=1, hc_cen=1)
# comps = kz_sd_result.eval_components()
# # print(comps)
# # print(kz_sd_result.fit_report(min_correl=0.1))
# # print(kz_sd_result.params)
# paras_values = []
# for key in kz_sd_result.params:
#     print(key, "=", kz_sd_result.params[key].value, "+/-", kz_sd_result.params[key].stderr)
#     paras_values.append(kz_sd_result.params[key].value)
# print(paras_values)

# fit by scipy.optimize import curve_fit
param_bounds = ([0, 0, 0, 0], [30, 30, 30, 30])
best_vals, covar = curve_fit(idf, s, y_c, bounds=param_bounds, p0=[4, 5.5, 5, 10.5])
print('optimal parameters for interface distribution function: ', best_vals)

# generate z, kz, kz'', kz''_fit
kz = []
kz_double_dot = []
kz_double_dot_fit = []
kz_z = []
# for z in range(0, 100, round(1/max(x))):  # Δz should be smaller than the scale of the smallest features to be determined, that is, da or dc,
for z in np.arange(0, 60, 0.5,
                   dtype=None):  # Δz should be smaller than the scale of the smallest features to be determined, that is, da or dc,
    new_kz_double_dot = np.sum(
        16 * (np.pi ** 3) * (p - y * (s ** 4)) * np.exp(-4 * (np.pi ** 2) * (s ** 2) * (b ** 2)) * np.cos(
            2 * np.pi * s * z) * ds)
    new_kz_double_dot_fit = np.sum(
        idf(s, *best_vals) * np.cos(
            2 * np.pi * s * z) * ds)
    new_kz = np.sum(4 * (np.pi ** 2) * y * (s ** 2) * np.cos(2 * np.pi * s * z) * ds)
    kz.append(new_kz)
    kz_double_dot.append(new_kz_double_dot)
    kz_double_dot_fit.append(new_kz_double_dot_fit)
    kz_z.append(z)
kz = np.array(kz, dtype=float)
kz_double_dot = np.array(kz_double_dot, dtype=float)
kz_double_dot_fit = np.array(kz_double_dot_fit, dtype=float)
kz_z = np.array(kz_z, dtype=float)
# print(len(kz_double_dot))
# print(len(kz_z))

# input optimal parameters; Higher order distributions hac are convolutions of ha and hc. Attention, not simply plus or product
gs_ha = ha(x=kz_z, ha_amp=1, ha_wid=best_vals[0], ha_cen=best_vals[1])
gs_hc = ha(x=kz_z, ha_amp=1, ha_wid=best_vals[2], ha_cen=best_vals[3])
gs_hac = hac(x=kz_z, hac_amp=1, hac_wid=math.sqrt(best_vals[0] ** 2 + best_vals[2] ** 2),
             hac_cen=best_vals[1] + best_vals[3])

# # plot original, fit curves
plt.figure()
plt.subplot(221)
plt.scatter(s, Is, s=2, label='measured data')
plt.scatter(s, porod(s, *res.x), s=2, color='r', label='Porod fit')
plt.legend(loc='upper right')  # local='best' or loc=4 or local='upper right'
plt.title("Porod fit")
plt.xscale('log')
plt.yscale('log')
plt.xlabel('s (nm^-1)')
plt.ylabel('I(s) (e.u./nm^3)')

# plot Function 16𝜋3[P − Is4]𝜔 as calculated from I(s)
plt.subplot(222)
plt.plot(s, y_c, label='calculated from measured data')
plt.scatter(s, y_c)
plt.plot(s, idf(s, *best_vals), color='r', label='fit')
# plt.plot(s, idf(s, *res_z.x), color='y', label='fit')
plt.legend(loc='upper right')  # local='best' or loc=4 or local='upper right'
plt.title("16 * pi^3 * [P − I * s^4] * window function as calculated from I(s)")
plt.xlabel('s (nm^-1)')
plt.ylabel('16 * pi^3 * [P − I * s^4] * window function')

# plot K(z)
plt.subplot(223)
plt.plot(kz_z, kz)
plt.title("K(z)")
plt.xlabel('z (nm)')
plt.ylabel('K(z)')

# plot interface distribution function K′′(z)
plt.subplot(224)
plt.plot(kz_z, kz_double_dot, linestyle='solid', label='calculated from measured data')
plt.scatter(kz_z, kz_double_dot)

# plot from curve_fit
plt.plot(kz_z, kz_double_dot_fit, label='calculated from fit')
# plt.plot(kz_z, gs_ha, label='ha')
# plt.plot(kz_z, gs_hc, label='hc')
# plt.plot(kz_z, - 2 * gs_hac, label='-2hac')
plt.plot(kz_z, p * 4.0 * (np.pi ** 3.0) * gs_ha, label='ha')
plt.plot(kz_z, p * 4.0 * (np.pi ** 3.0) * gs_hc, label='hc')
plt.plot(kz_z, - 2 * p * 4.0 * (np.pi ** 3.0) * gs_hac, label='-2hac')
plt.legend(loc='upper right')  # local='best' or loc=4 or local='upper right'
plt.title("Interface distribution function K′′(z)")
plt.xlabel('z (nm)')
plt.ylabel('K′′(z) (e.u./nm^8)')
plt.show()
# <correlation_function_interface_distribution_function_final.py>