import matplotlib.pyplot as plt
from numpy import pi
import numpy as np

class Solver:
	def __init__(self):
		# Define Problem Constants
		self.alpha = 0.25
		self.L = pi
		self.n = 100 + 1
		self.delta_x = self.L / (self.n-1)
		self.t = 50
		self.t_step = 10 ** -4
		self.t_end = int(self.t/self.t_step) + 1

		# Define empty arrays
		self.x = np.linspace(0, self.L, self.n, dtype = float)
		self.temperature = np.zeros((self.t_end, self.n))

		#Define Starting Conditions
		self.setBoundaryConditions()

	def setBoundaryConditions(self):
		# Define Initial Conditions
		self.temperature[0, :] = self.x * (pi - self.x)

		#Define Boundary Conditions
		self.temperature[0, [0,self.n-1]] = 0

	def step(self, current_step):
		# Iterate through all points minus endpoints
		Tn = self.temperature[current_step,1:-1]
		Tn_up = self.temperature[current_step,2:]
		Tn_down = self.temperature[current_step,0:-2]

		x = self.x[1:-1]

		self.temperature[current_step+1,1:-1] = (self.alpha * ((Tn_up - 2*Tn + Tn_down) / (self.delta_x ** 2)) + np.sin(5 * x)) * self.t_step + Tn

	def solve(self):
		print('\nStarting Solve\n')
		for current_step in range(0,self.t_end-1):
			print(current_step)
			self.step(current_step)

		print('\nCompleted Solve\n')

	def question1a(self):
		# Part 1
		temp = self.temperature[:,50]
		time = np.linspace(0,self.t,self.temperature.shape[0])

		plt.subplot(121)
		plt.plot(time, temp)
		plt.xlabel('Time')
		plt.ylabel('Temperature C')

		# Part 2
		temp = self.temperature[-1,:]
		time = self.x

		plt.subplot(122)
		plt.plot(time, temp)
		plt.xlabel('Length x')
		plt.show()

if __name__ == '__main__':
	# Question 1a
	s = Solver()
	s.solve()
	s.question1a()
	print(s.temperature)