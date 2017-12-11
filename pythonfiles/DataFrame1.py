import pandas as pd

data = pd.read_csv('test.txt')
df = pd.DataFrame(data)
# print(df)
print("Name: ")
print(df["name"])
print("Age: ")
df1 = (df["age"] == 36)
print( df1)