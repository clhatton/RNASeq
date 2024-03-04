
import pandas as pd


alignment = HISAT2

file = pd.read_csv('PRODMAT_samples.txt', header=None)
df_C = pd.read_csv('blank_Genes.txt', header=True)
df_M = pd.read_csv('blank_Genes.txt', header=True)
df_F = pd.read_csv('blank_Genes.txt', header=True)

for index, row in file.iterrows():
    if 'C' in row:
        new_df = pd.read_csv('{alignment}/Counts_txt/{row}_count.txt', sep= " ", header=True)
        df_C = pd.merge(df_C, new_df, on='Gene', how='inner')
    elif 'M' in row:
        new_df = pd.read_csv('{alignment}/Counts_txt/{row}_count.txt', sep= " ", header=True)
        df_M = pd.merge(df_M, new_df, on='Gene', how='inner')
    elif 'F' in row:
        new_df = pd.read_csv('{alignment}/Counts_txt/{row}_count.txt', sep= " ", header=True)
        df_F = pd.merge(df_F, new_df, on='Gene', how='inner')

df_C.to_csv('{alignment}_C.csv', index=False)
df_M.to_csv('{alignment}_M.csv', index=False)
df_F.to_csv('{alignment}_F.csv', index=False)
