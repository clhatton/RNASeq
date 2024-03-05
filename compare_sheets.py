import pandas as pd

# Read the two files into DataFrames
df1 = pd.read_csv('HISAT2_C.csv')
df2 = pd.read_csv('STAR_C.csv')

# Find differences between the two DataFrames
differences = (df1 != df2).stack()

# Get the row and column indices where differences occur
changed_indices = differences[differences].index

# Display the differences
x=0
y=0
z=0
for index in changed_indices:
    row, col = index
    if abs(df1.at[row, col] - df2.at[row, col]) >= 5:
        x= x+1
        print(f"Difference at ({row}, {col}):")
        print(f"  HISAT2: {df1.at[row, col]}")
        print(f"  STAR: {df2.at[row, col]}")
        print()
    elif abs(df1.at[row, col] - df2.at[row, col]) >= 50:
        y= y+1
        print(f"Difference at ({row}, {col}):")
        print(f"  HISAT2: {df1.at[row, col]}")
        print(f"  STAR: {df2.at[row, col]}")
        print()
    elif abs(df1.at[row, col] - df2.at[row, col]) >= 100:
        z= z+1
        print(f"Difference at ({row}, {col}):")
        print(f"  HISAT2: {df1.at[row, col]}")
        print(f"  STAR: {df2.at[row, col]}")
        print()
    print(f"Difference of 5 or Greater is {x}")
    print(f"Difference of 50 or Greater is {y}")
    print(f"Difference of 100 or Greater is {z}")
