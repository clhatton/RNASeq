import pandas as pd

file = pd.read_csv('PRODMAT_samples.txt', header=None)
df_C = pd.read_csv('blank_Genes.txt', header=0)
df_M = pd.read_csv('blank_Genes.txt', header=0)
df_F = pd.read_csv('blank_Genes.txt', header=0)

base_path = '/data/rusers/hattonc/PRODMAT/STAR/TPM_txt/'

for index, row in file.iterrows():
    if 'C' in row[0]:
        file_path = f'{base_path}{row[0]}_tpm.txt'
        new_df = pd.read_csv(file_path, sep="\t", header=0)
        df_C = pd.merge(df_C, new_df, on='Gene')
    elif 'M' in row[0]:
        file_path = f'{base_path}{row[0]}_tpm.txt'
        new_df = pd.read_csv(file_path, sep="\t", header=0)
        df_M = pd.merge(df_M, new_df, on= 'Gene')
    elif 'F' in row[0]:
        file_path = f'{base_path}{row[0]}_tpm.txt'
        new_df = pd.read_csv(file_path, sep="\t", header=0)
        df_F = pd.merge(df_F, new_df, on= 'Gene')

df_C.to_csv('STAR_C_TPM.csv', index=False)
df_M.to_csv('STAR_M_TPM.csv', index=False)
df_F.to_csv('STAR_F_TPM.csv', index=False)