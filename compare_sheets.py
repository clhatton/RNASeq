import pandas as pd

# Read the two files into DataFrames
df1 = pd.read_csv('HISAT2_C.csv')
df2 = pd.read_csv('STAR_C.csv')

# Find differences between the two DataFrames
differences = (df1 != df2).stack()

# Get the row and column indices where differences occur
changed_indices = differences[differences].index

# Display the differences
for index in changed_indices:
    row, col = index
    if abs(df1.at[row, col] - df2.at[row, col]) >= 5:
        print(f"Difference at ({row}, {col}):")
        print(f"  HISAT2: {df1.at[row, col]}")
        print(f"  STAR: {df2.at[row, col]}")
        print()