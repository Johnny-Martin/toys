
def fabnacii(tar):
	x=0
	y=1
	while y<tar:
		x,y = y, x+y
		print(x)
		

fabnacii(1000)