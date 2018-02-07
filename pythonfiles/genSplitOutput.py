## Python script to generate multiple output files on the basis of columns through configuration
import csv
import os
##Section 1: Read the configuration

sols = []
curs = []
filepath = []
sol_col=''
cur_col=''
inpfile=''
filedes=[]

with open("configfile", "r") as file:
    rows = ( line.split('|') for line in file)
    dict = { row[0]:row[1] for row in rows }
    #print('input file is:' + dict['input_file'])
    #print(dict['sol_col_no'])
    sol_col=dict['sol_col_no']
    cur_col=dict['cur_col_no']
    inputfile=dict['input_file']
    #print(inputfile)
##Section 2: Read the content of file and create unique lists (SOL and CUR)

#inputfile=inputfile.replace('"','')
#with open(inputfile,"r") as inputfile:
#inpfile=open("E:\\Deepak\\Personal\\Projects\\Personal\ Projects\\Finacle Migration\\GIT_Projects\\SanimaMigration\\NewCheckout\\SNMPKAPFMigration\\pythonfiles\\samplefile.csv","r")
inpfile = open("E:\\Deepak\\Personal\\Projects\\Personal Projects\\Finacle Migration\\GIT_Projects\\SanimaMigration\\NewCheckout\\SNMPKAPFMigration\\pythonfiles\\samplefile.csv", "r")
for rows in inpfile:
        fields=rows.split('|')
        #print(rows)
        #print(fields[int(sol_col)])
        #print(fields[int(cur_col)])
        if fields[int(sol_col)] not in sols:
            sols.append(str(fields[int(sol_col)]))
        if fields[int(cur_col)] not in curs:
            curs.append(str(fields[int(cur_col)]))

print(sols)
print(curs)
#inputfile=open(filepath[1],'r')
#for line in inputfile:
#    print(line)
#filedescriptor="filedes"
##Section 3: Read the content of file, compare with unique lists and write to separate files with combinations of SOL and CUR


      #print(sols[i]+'-'+curs[j])
      #fdesc=open("output_"+str(i)+"_"+str(j)+".csv")
inpfile = open(
        "E:\\Deepak\\Personal\\Projects\\Personal Projects\\Finacle Migration\\GIT_Projects\\SanimaMigration\\NewCheckout\\SNMPKAPFMigration\\pythonfiles\\samplefile.csv",
        "r")

for i in sols:
    print(i)
    #for j in curs:
        #for line in inpfile:
            #print(str(i)+','+str(j))
            #print(line)
        #fields1=line.split('|')
         #   if fields1[2]==i and fields1[3]==j:
          #      print(i)


    #for i in range(0, len(sols)):
            #for j in range(0, len(curs)):

                #if fields[int(sol_col)] == sols[i] and fields[int(cur_col)] == curs[j]:
                    #print(str(i)+','+str(j))
                    #print(rows)
                #for rows in inpfile:
                #print(rows)
     #print(str(i)+':'+str(j))
     #for rows in inpfile:
     #   fields = rows.split('|')
     #   #file=open(filename,'w')
     #   print(fields[int(sol_col)])
     #   print(fields[int(cur_col)])
     #   if fields[int(sol_col)]==sols[i] and fields[int(cur_col)]==curs[j]:
     #       #file.write(rows)
     #       print("matched")