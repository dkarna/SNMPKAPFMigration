import csv

dirPath = (r"/Users/Apple/Desktop/Deepak/")
filePath = dirPath + "/samplefile.csv"
targetDir = "uploads"

d = {}
l = []

with open(filePath) as csvfile:
    reader = csv.DictReader(csvfile)
    
    for row in reader:

        key = row['BRANCH'] + "_" + row['CURRENCY']
        
        if key in d:
            l = d[key]
            nl = []
            nl.append(row['ID'])
            nl.append(row['NAME'])
            nl.append(row['BRANCH'])
            nl.append(row['CURRENCY'])
            nl.append(row['ADDRESS'])
            l.append(nl)
            d[key] = l
        else:
            l = []
            l.append(row['ID'])
            l.append(row['NAME'])
            l.append(row['BRANCH'])
            l.append(row['CURRENCY'])
            l.append(row['ADDRESS'])
            d[key] = [l]
    
for key, value in d.items():
    
    newFileName = "Branch_" + key
    newFilePath = dirPath + "/" + targetDir + "/" + newFileName + ".csv"

    with open(newFilePath, 'w') as resultFile:
        writer = csv.writer(resultFile, lineterminator='\n')
        writer.writerows(value)
        

