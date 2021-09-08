import matplotlib.pyplot as plt
from numpy import pi
import numpy as np

class Solver:
	def __init__(self, t_step = 10 ** -4, divs = 100):
		# Define Problem Constants
		self.alpha = 0.25
		self.L = pi
		self.n = divs + 1
		self.delta_x = self.L / (self.n-1)
		self.t = 50
		self.t_step = t_step
		self.t_end = int(self.t/self.t_step)

		# Define empty arrays
		self.x = np.linspace(0, self.L, self.n, dtype = np.float32)
		self.temperature = np.zeros(self.n)
		self.temperature_new = np.zeros(self.n)
		self.midpoint_temp = np.zeros(self.t_end)

		#Define Starting Conditions
		self.setBoundaryConditions()

	def setBoundaryConditions(self):
		# Define Initial Conditions
		self.temperature = self.x * (pi - self.x)

		#Define Boundary Conditions
		self.temperature[[0,self.n-1]] = 0

	def step(self, current_step):
		# Iterate through all points minus endpoints
		Tn = self.temperature[1:-1]
		Tn_up = self.temperature[2:]
		Tn_down = self.temperature[0:-2]

		x = self.x[1:-1]

		self.temperature_new[1:-1] = (self.alpha * ((Tn_up - 2*Tn + Tn_down) / (self.delta_x ** 2)) + np.sin(5 * x)) * self.t_step + Tn
		self.midpoint_temp[current_step] = self.temperature[int(self.n/2)]

		#Update current temperature
		self.temperature[1:-1] = self.temperature_new[1:-1]

	def solve(self):
		print('\nStarting Solve\n')
		for current_step in range(0,self.t_end):
			print(current_step)
			self.step(current_step)

		print('\nCompleted Solve\n')

	def question1a(self):
		# Part 1
		time = np.linspace(0,self.t,self.t_end)
		temp = self.midpoint_temp

		plt.subplot(121)
		plt.title(r'Temperature vs. Time at L = $\frac{\pi}{2}$')
		plt.plot(time, temp)
		plt.xlabel('Time')
		plt.ylabel('Temperature C')

		# Part 2
		temp = self.temperature
		time = self.x

		plt.subplot(122)
		plt.plot(time, temp)
		plt.xlabel('Length x')
		plt.show()

	def question1b(self):
		# Part 1
		time = np.linspace(0,self.t,self.t_end)
		temp = self.midpoint_temp

		plt.subplot(121)
		plt.title(r'Temperature vs. Time at L = $\frac{\pi}{2}$')
		plt.plot(time, temp)
		plt.xlabel('Time')
		plt.ylabel('Temperature C')

		# Part 2
		temp = self.temperature
		time = self.x

		plt.subplot(122)
		plt.plot(time, temp)
		plt.xlabel('Length x')
		plt.show()

	def question1c(self):
		exact = (1/(25*self.alpha)) * np.sin(5*self.x)
		error = np.sum(np.power((exact - self.temperature), 2))
		return error

	def question1d(self):
		# Part 1
		time = np.linspace(0,self.t,self.t_end)
		temp = self.midpoint_temp

		plt.subplot(121)
		plt.title(r'Temperature vs. Time at L = $\frac{\pi}{2}$')
		plt.plot(time, temp)
		plt.xlabel('Time')
		plt.ylabel('Temperature C')

		# Part 2
		temp = self.temperature
		time = self.x

		plt.subplot(122)
		plt.plot(time, temp)
		plt.xlabel('Length x')
		plt.show()


def question1a():
	s1 = Solver(t_step = 10 ** -4)
	s1.solve()
	s1.question1a()

def question1b():
	s2 = Solver(t_step = 10 ** -2)
	s2.solve()
	s2.question1b()

def question1c():
	divs_list = [10, 50, 100, 200, 300, 400]
	error = []

	for divs in divs_list:
		s3 = Solver(t_step = 10 ** -4, divs = divs)
		s3.solve()
		e = s3.question1c()
		error.append(e)

	print(error)

	plt.plot(divs_list, error)
	plt.xlabel('Number of Divisions')
	plt.ylabel('Error')
	plt.yscale('log')
	plt.show()

def question1d():
	s4 = Solver(t_step = 10 ** -4, divs = 1000)
	s4.solve()
	s4.question1d()

if __name__ == '__main__':
	question1a()