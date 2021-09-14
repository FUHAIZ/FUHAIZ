# 04/Aug/2021
# fit in KAUST

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit, minimize, shgo
import math

# get data
fit = pd.read_table('data1.dat', header=None)
fit_frame = pd.DataFrame(fit)
x = fit_frame[0]
y = fit_frame[1]

# # define special function
# def fit(x, a1, a2, a3, t2s, t2i, t2l1, t2l2):
#     a = 0.05
#     # a0 = 1 - a1 - a2 - a3
#     # if t2s < t2i < t2l1 < t2l2:
#     return (1 - a1 - a2 - a3) * np.exp(-(x / (2 * t2s)) ** 2) * (np.sin(a * x) / (a * x)) + a1 * np.exp(
#         -(x / t2i)) + a2 * np.exp(-(x / t2l1)) + a3 * np.exp(-(x / t2l2))
#
#
# # get coefficients of function by curve_fit
# param_bounds = ([0, 0, 0, 0, 0, 0, 0], [np.inf, np.inf, np.inf, np.inf, np.inf, np.inf, np.inf])
# coeff, pcov = curve_fit(fit, x, y, bounds=param_bounds, method='trf')  # lm/trf/dogbox
# print(coeff)
# a0 = 1 - sum(coeff[0:3])
# a1 = coeff[0]
# a2 = coeff[1]
# a3 = coeff[2]
# t2s = coeff[3]
# t2i = coeff[4]
# t2l1 = coeff[5]
# t2l2 = coeff[6]
# print(a0, a1, a2, a3, t2s, t2i, t2l1, t2l2)
# print(pcov)


# define fit function
def fit(x, *p):
    a = 0.05
    a0, a1, a2, a3, t2s, t2i, t2l1, t2l2 = p
    # if t2s < t2i < t2l1 < t2l2:
    return a0 * np.exp(-(x / (2 * t2s)) ** 2) * (np.sin(a * x) / (a * x)) + a1 * np.exp(-(x / t2i)) + a2 * np.exp(
        -(x / t2l1)) + a3 * np.exp(-(x / t2l2))


# mean squared error as a function of the parameters
# err = lambda p: np.mean((fit(x, *p) - y) ** 2)


# R square as a function of the parameters
# err = lambda p: 1 - (np.sum((fit(x, *p) - y) ** 2) / np.sum((y - np.mean(y)) ** 2))
err = lambda p: (np.sum((fit(x, *p) - y) ** 2) / np.sum((y - np.mean(y)) ** 2))

# get coefficients of function by minimize
cons = (
    # {'type': 'ineq', 'fun': lambda x: x},
    {'type': 'eq', 'fun': lambda p: 1 - p[0] - p[1] - p[2] - p[3]},
    {'type': 'ineq', 'fun': lambda p: p[0] - p[1]},
    {'type': 'ineq', 'fun': lambda p: p[1] - p[2]},
    {'type': 'ineq', 'fun': lambda p: p[2] - p[3]},
    {'type': 'ineq', 'fun': lambda p: p[5] - p[4]},
    {'type': 'ineq', 'fun': lambda p: p[6] - p[5]},
    {'type': 'ineq', 'fun': lambda p: p[7] - p[6]}
)
# x0 = np.array((0.47, 0.43, 0.06, 0.04, 1.8, 8.9, 9, 1000))  # initial value
# x0 = np.array((0.439, 0.435, 0.09, 0.036, 25.7, 91.7, 620, 3100))  # initial value
x0 = np.array((0.439, 0.435, 0.09, 0.036, 25.7, 91.7, 820, 4100))  # initial value
bounds = [(0, None), (0, None), (0, None), (0, None), (0, None), (0, None), (0, None), (0, None)] # 20-50, 50-100, 100-1000, >1000
res = minimize(err, x0=x0, method='SLSQP', bounds=bounds, constraints=cons, tol=1e-11) # COBYLA, trust-constr
# res = minimize(err, x0, method='SLSQP', bounds=bounds)
print(res)
print('minimal value: ', res.fun)
print('optimal solution: ', res.x)
print('message: ', res.message)
print('whether success: ', res.success)
print('a0 + a1 + a2 +a3: ', sum(res.x[0:4]))
print('R2: ', 1 - res.fun)

# get coefficients of function by shgo
# if __name__ == "__main__":


# plot original, fit curves
plt.plot(fit_frame[0], fit_frame[1], 'blue', label='original data')
# plt.plot(x, fit(x, *coeff), 'r', label='curve_fit')
plt.plot(x, fit(x, *res.x), 'y', label='minimize')
# a = 0.05
# plt.plot(x, res.x[0] * np.exp(-(x / (2 * res.x[4])) ** 2) * (np.sin(a * x) / (a * x)), 'b--', label='ao')
# plt.plot(x, res.x[1] * np.exp(-(x / res.x[5])), 'r--', label='a1')
# plt.plot(x, res.x[2] * np.exp(-(x / res.x[6])), 'y--', label='a2')
# plt.plot(x, res.x[3] * np.exp(-(x / res.x[7])), 'g--', label='a3')
plt.title("fit")
plt.xlabel('time')
# plt.ylabel('log(y)')
# plt.yscale('log')
# plt.ylim((0, 1))
plt.legend(loc='best')  # local='best' or loc=4
plt.show()
