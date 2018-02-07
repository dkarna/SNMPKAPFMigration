import pandas as pd
import csv

res = {}
# read configuration section

with open("configfile.txt") as myfile:
    for args in myfile:
        pairs=args.split(',')
        for p in pairs:
            var, val = p.split("=")
            res[var] = val

input_file=res["inputfile"].rstrip()  # read inputfile path and filename
logfile=res["logfile"].rstrip()  # read logfile path and filename
outputpath=res["outputpath"].rstrip()  # read output path from config
solcolumn=res["solcol"].rstrip()  # read sol column name from config
curcolumn=res["curcol"].rstrip()  # read cur column name from config

# function to return the line count of filename passed
def retCount(fname):
    return len(list(csv.reader(open(fname))))



splitfiles=[]

logfd=open(logfile, "w")

logfd.write("input_file: " + str(input_file))
logfd.write(" line_count: " + str(int(retCount(input_file))-1))

dtype_dic= {solcolumn: str,
            curcolumn: str}   # pre-define the data type to be read in python

dfdata = pd.read_csv(input_file, dtype=dtype_dic)    # read csv file on the basis of defined data type for the specified columns

df=pd.DataFrame(dfdata)   # create dataframe out of the csv data
df.sort_values([solcolumn, curcolumn])  # sort the dataframe on the basis of specified columns


sols=df[solcolumn].unique()  # find unique sols
sols=sorted(sols)  # sort sols
curs=df[curcolumn].unique() # find unique cur
curs=sorted(curs)   # sort curs

for sol1 in sols:    # iterate over sols
    for cur1 in curs:  # iterate over curs

        ndf = df[(df.sol == sol1) & (df.cur == cur1)]   # get only matching data with sol and cur
        filename = str(outputpath) + "file_" + str(sol1) + "_" + str(cur1) + ".csv"  # create filename with specified sol and cur

        if len(ndf.index) == 0:   # check whether the combination of filename is empty in dataframe
            print('') # do nothing with file
        else:
            ndf.to_csv(filename, sep=',', index=False, header=False) # write to csv file
            splitfiles.append(filename) # add the filename to the list for further processing

logfd.write("\n") # append new line to the log
for file in splitfiles:  # iterate over the list of splitted files

    logfd.write("\n")
    logfd.write("split_file: " + str(file))  # splitted file name to the log
    logfd.write(" line_count: " + str(retCount(file)))  # splitted file line count to the log
    logfd.write("\n")

logfd.close()  # close log



