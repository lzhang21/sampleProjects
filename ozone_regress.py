import LHD
import numpy as np
import statsmodels.api as sm
import matplotlib.pyplot as plt

# Read in data
file_d,col = LHD.load_header_data('ozone_fit_regression_input.dat')

# Extract variables
year = file_d[:,0]
obs_o3 = file_d[:,1]
tsi = file_d[:,3]
halo = file_d[:,4]
aero = file_d[:,5]
qbo = file_d[:,6]

# Defines the number of observations and regressors 
nobs = len(year)  # Number of observations
nrgs = 5  # Number of regressors + 1 (1 is for the y-intercept const.) 

# Create a matrix of 1s with the dimentions defined above
regressors = np.ones((nobs,nrgs), dtype= np.float)

# Populate the matrix columns with regressors (leaving column 0 as 1s) 
regressors[:,1] = tsi
regressors[:,2] = halo
regressors[:,3] = aero
regressors[:,4] = qbo

# Create an ordinary least squares model
model = sm.OLS(obs_o3, regressors)
# Extract the constants
constants = model.fit().params
print constants 

# Calculate the model fit result
result = constants[0] + constants[1]*tsi + constants[2]*halo + constants[3]*aero + constants[4]*qbo
print(model.fit().summary())
# Plot
plt.plot(year,obs_o3,c='g', label = 'Observed O3') # Observations
plt.plot(year,result,c='r', lw=1,label = 'MLR O3') # MLR with Python

plt.xlabel('Year')
plt.ylabel('Column Ozone Anomaly (DU)')
plt.legend()


plt.show()


