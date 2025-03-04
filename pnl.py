import pandas as pd

# Load the CSV file
# Replace 'your_file.csv' with the path to your CSV file
df = pd.read_csv('test.csv', delimiter=';')
df = df[df['action'] == 'filled']

# Calculate PnL
df['PnL'] = df.apply(
    lambda row: row['tradePx'] * row['tradeAmt'] if row['orderSide'] == 'sell' else -row['tradePx'] * row['tradeAmt'], 
    axis=1
)

# Group by orderProduct to calculate total PnL per product
pnl_per_product = df.groupby('orderProduct')['PnL'].sum().reset_index()
print(pnl_per_product)

# Calculate total PnL
total_pnl = pnl_per_product['PnL'].sum()
print(total_pnl)

# Append total PnL to the DataFrame
total_row = pd.DataFrame({'orderProduct': ['Total'], 'PnL': [total_pnl]})
pnl_per_product = pd.concat([pnl_per_product, total_row], ignore_index=True)

# Print the results
print(pnl_per_product)