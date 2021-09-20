import matplotlib.pyplot as plt
from numpy import pi
import numpy as np

class Solver:
	def __init__(self, t_step = 10 ** -4, divs = 100, alpha = 0.1, length = 1):
		# Define Problem Constants
		self.alpha = alpha
		self.L = length
		self.n = divs + 1
		self.delta_x = self.L / (divs)
		self.t = 10
		self.t_step = t_step
		self.t_end = int(self.t/self.t_step)

		# Define empty arrays
		self.x = np.linspace(0, self.L, self.n, dtype = np.float64)
		self.temperature = np.zeros(self.n)
		self.temperature_new = np.zeros(self.n)
		self.midpoint_temp = np.zeros(self.t_end)

		#Exact array size
		self.temperature_exact = np.zeros(self.n)
		self.temperature_exact_new = np.zeros(self.n)

		#Pic saving
		self.current_pic = 1

		#Define Starting Conditions
		self.setBoundaryConditions()

	def setBoundaryConditions(self):
		# Define Initial Conditions
		self.temperature = np.sin((pi*self.x)/self.L)

		# Exact Temperature
		self.temperature_exact = np.sin((self.x * pi) / self.L) * np.exp(- (self.alpha * (pi**2) * 0)/(self.L^2))

		#Define Boundary Conditions
		self.temperature[[0,self.n-1]] = 0
		self.temperature_exact[[0,self.n-1]] = 0

	def step(self, current_step):
		# Iterate through all points minus endpoints
		Tn = self.temperature[1:-1]
		Tn_up = self.temperature[2:]
		Tn_down = self.temperature[0:-2]

		x = self.x[1:-1]

		self.temperature_new[1:-1] = (self.alpha * ((Tn_up - 2*Tn + Tn_down) / (self.delta_x ** 2))) * self.t_step + Tn
		self.temperature_exact_new[1:-1] = np.sin((x * pi) / self.L) * np.exp((-self.alpha * (np.power(pi,2)) * (current_step*self.t_step))/(self.L^2))
		self.midpoint_temp[current_step] = self.temperature[int(self.n/2)]

		#Update current temperature
		self.temperature[1:-1] = self.temperature_new[1:-1]
		self.temperature_exact[1:-1] = self.temperature_exact_new[1:-1]

		self.question2(current_step)

	def solve(self):
		print('\nStarting Solve\n')
		for current_step in range(0,self.t_end):
			print(current_step)
			self.step(current_step)

		print('\nCompleted Solve\n')


	def question2(self, current_step):
		# Part 1
		if current_step % 10000 == 0:
			plt.plot(self.x, self.temperature, self.x, self.temperature_exact)
			plt.xlim(0,1)
			plt.ylim(0,1)
			plt.savefig(f'{str(self.current_pic).zfill(2)}.png')
			self.current_pic += 1
			plt.clf()

def question2():
	s1 = Solver(t_step = 10 ** -5)
	s1.solve()

if __name__ == '__main__':
	question2()