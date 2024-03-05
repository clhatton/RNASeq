import pandas as pd

# Read the two files into DataFrames
df1 = pd.read_csv('HISAT2_C.csv')
df2 = pd.read_csv('STAR_C.csv')

# Find differences between the two DataFrames
differences = (df1 != df2).stack()

# Get the row and column indices where differences occur
changed_rows, changed_columns = differences[differences].index.unstack()

# Display the differences
for row, col in zip(changed_rows, changed_columns):
    print(f"Difference at ({row}, {col}):")
    print(f"  Sheet 1: {df1.at[row, col]}")
    print(f"  Sheet 2: {df2.at[row, col]}")
    print()