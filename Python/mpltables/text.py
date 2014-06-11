for i in xrange(8):
	plt.plot(x, i*y, colours[i]+ls[i])
	
plt.title("My Plot of Varrying Linestyles", fontsize = 20, color = "gold")
plt.xlabel("x-axis", fontsize = 10, color = "darkcyan") 
plt.ylabel("y-axis", fontsize = 10, color = "darkcyan")

plt.axis([-1, 6, -1, 8])
plt.show()