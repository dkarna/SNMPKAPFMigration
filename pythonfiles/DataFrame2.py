import pandas as pd

reviews = pd.read_csv("ign.csv")
#print(reviews.head())
#print(reviews.shape)
#print(reviews
#print(reviews["score"].value_counts(9))
df = pd.DataFrame(reviews)
#print(df)
#print(reviews["release_year"].value_counts())
reviews_2012 = df[df.release_year == 2012]

#print(max(df.release_year))

#print(reviews_2012)
minrelyear = min(df.release_year)
maxrelyear = max(df.release_year)

for relyear in range(minrelyear,maxrelyear+1):
    #print(relyear)
    ndf = df[df.release_year == relyear]
    filename = "file_" + str(relyear) + ".txt"
    #print
    ndf.to_csv(filename, sep=',', index=False, header=True)
    #print(ndf)
    #print(filename)




