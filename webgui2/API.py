#! /home/bitnami/.local/bin/hug -f 
import numpy as np
import sys
import os
import matplotlib.pyplot as plt
import json

dataIn = sys.argv[1]

mainpath,filename = os.path.split(os.path.realpath(__file__))
emissionpath,mainfolder = os.path.split(mainpath)
pythonpath = emissionpath + '/python'
sys.path.append(pythonpath)

import getelec_mod as gt

def fit_fun(indata_arr):
   
    F0 = [1., 5., 20.]
    R0 = [1., 5., 50.]
    gamma0 = [1., 10., 100.]
    Temp0 = [299.99999, 300., 300.01]
    
    #load the data
    xdata = 1./np.array(indata_arr[0])
    ydata = np.log(np.array(indata_arr[1]))
    W0 = np.array([1.-1e-4, 1., 1.+1e-4]) * float(indata_arr[2][0])

    print(indata_arr)
    print(W0)

    fit= gt.fitML(xdata,ydata, F0, W0, R0, gamma0, Temp0)
    popt = fit.x
    yopt = gt.MLplot(xdata, popt[0], popt[1], popt[2], popt[3], popt[4])
    yshift = max(yopt) - max(ydata)

    xth = np.linspace(min(xdata),max(xdata),32)
    yth = np.exp(gt.MLplot(xth, popt[0], popt[1], popt[2], popt[3], popt[4]) - yshift)      
    
    xplot = xdata / popt[0]

    xplot_th = xth / popt[0]
    
    outdata = {"xplot_mrk": xplot.tolist(), "yplot_mrk": indata_arr[1], \
                "xplot_line": xplot_th.tolist(), "yplot_line": yth.tolist(), \
                "beta": popt[0], "Radius": popt[2], "sigma_Aeff": 1e-9*np.exp(-yshift), \
                "xAxisUnit": "1 / (Local Field [V/nm])", "yAxisUnit": "Current [Amps]"}
    
    return json.dumps(outdata)


#converts string input and returns array of float arrays
def convertInput(input):
    _dataIn = input.split("]")
    _data = []
    for i in range(len(_dataIn)):
        _ddataIn = _dataIn[i].split("[")
        if(len(_ddataIn) > 1):
            paramListStr = _ddataIn[1].split(",")
            paramListFloat = []
            for j in range(len(paramListStr)):
                paramListFloat.append(float(paramListStr[j]))
            _data.append(paramListFloat)
        else:
            param = _ddataIn[0].split(":")[1].split("}")[0]
            _data.append([float(param)])
    return _data

# 231.3, 251.1, 262.2, 270.6, 280.3, 291.5, 299.9
# 0.8719, 1.582, 2.967, 5.038, 8.555, 14.06, 23.09
# data  = {"Voltage": [2.413e+02, 2.511e+02, 2.622e+02, 2.706e+02, 2.803e+02, 2.915e+02, 2.999e+02, 3.096e+02, 3.208e+02, 3.305e+02, 3.403e+02, 3.515e+02, 3.612e+02, 3.710e+02, 3.808e+02, 3.891e+02, 4.003e+02, 4.100e+02, 4.184e+02, 4.338e+02, 4.491e+02, 4.644e+02, 4.826e+02, 4.993e+02],
#           "Current": [8.719e-01, 1.582e+00, 2.967e+00, 5.038e+00, 8.555e+00, 1.406e+01, 2.309e+01, 3.670e+01, 5.643e+01, 8.678e+01, 1.249e+02, 1.797e+02, 2.502e+02, 3.371e+02, 4.540e+02, 6.116e+02, 7.459e+02, 9.720e+02, 1.267e+03, 1.764e+03, 2.376e+03, 3.096e+03, 4.310e+03, 5.617e+03], "Work_function": 4.5
#         }

print("Successfully calculated IV data. ")
print(fit_fun(convertInput(dataIn)))



 