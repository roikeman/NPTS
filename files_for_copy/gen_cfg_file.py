import sys
size_to_col = {256:0, 1024:1, 4096:2, 16384:3, 65536:4, 262144:5, 1048576:6}
parameters=[[256,147,64733,74379,32886,7473,3627],[1024,139,229055,250684,116132,17748,8719],[4096,134,851085,901106,428425,42882,21160],[16384,132,3253590,3373092,1638058,106054,52716],[65536,131,12660810,12948962,6376444,262459,131151],[262144,130,49783960,50491816,25027682,658291,329322],[1048576,129,197048950,198793066,98729980,1647898,823204]]
files=["data.txt","ip.txt"]
column=size_to_col[int(sys.argv[1])]

with open ("cfg.txt",'w') as file:
    file.write("seeds="+str(parameters[int(column)][1])+"\n"+
			   "Nbf="+str(parameters[int(column)][2])+"\n"+
			   "Not="+str(parameters[int(column)][3])+"\n"+
			   "NumOfOnes="+str(parameters[int(column)][4])+"\n"+
			   "Nc="+str(parameters[int(column)][5])+"\n"+
			   "Nr="+str(parameters[int(column)][6])+"\n"+
			   "Data_file="+files[0]+"\n"+
			   "IP_file="+files[1])

file.close()
