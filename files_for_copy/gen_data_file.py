import sys
import random

input,output,n,player=sys.argv[1:]

with open(input,'r') as file:
    for line in file:
        data=line.split(',')
file.close()		

data=[int(d) for d in data]
data=set(data)
print(data)

random.seed()

while (len(data)!=int(n)):
    #print(len(data))
    data.add(int(random.random()*1000000))
	
print(data)

data=[str(d) for d in data]

with open (output,'w') as file:
    for d in data[:-1]:
        file.write(d+',')
    file.write(data[-1])
file.close()
