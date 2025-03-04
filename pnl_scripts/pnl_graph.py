import pandas as pd
import matplotlib.pyplot as plt

def pnl_per_product(filename):
    # Load the CSV file
    df = pd.read_csv(filename, delimiter=';')

    # Filter for rows where action is 'filled'
    df = df[df['action'] == 'filled']

    # Convert currentTime to datetime
    df['currentTime'] = pd.to_datetime(df['currentTime'])

    # Calculate PnL
    df['PnL'] = df.apply(
        lambda row: row['tradePx'] * row['tradeAmt'] if row['orderSide'] == 'sell' else -row['tradePx'] * row['tradeAmt'], 
        axis=1
    )

    # Extract time of day from currentTime
    df['time'] = df['currentTime'].dt.time

    # Group by time and orderProduct to calculate total PnL
    pnl_per_product_time = df.groupby(['time', 'orderProduct'])['PnL'].sum().unstack(fill_value=0)

    # Plotting
    plt.figure(figsize=(12, 6))
    for product in pnl_per_product_time.columns:
        plt.plot(pnl_per_product_time.index.map(str), pnl_per_product_time[product], marker='o', label=product)

    plt.title('PnL per Order Product Over Time of Day')
    plt.xlabel('Time of Day')
    plt.ylabel('Total PnL')
    plt.xticks(rotation=45)
    plt.legend(title='Order Product')
    plt.grid()
    plt.tight_layout()
    plt.show()

def total_pnl(filename):
    # Load the CSV file
    df = pd.read_csv(filename, delimiter=';')

    # Filter for rows where action is 'filled'
    df = df[df['action'] == 'filled']

    # Convert currentTime to datetime
    df['currentTime'] = pd.to_datetime(df['currentTime'])

    # Calculate PnL
    df['PnL'] = df.apply(
        lambda row: row['tradePx'] * row['tradeAmt'] if row['orderSide'] == 'sell' else -row['tradePx'] * row['tradeAmt'], 
        axis=1
    )

    # Group by time and calculate cumulative PnL
    df['time'] = df['currentTime'].dt.time
    cumulative_pnl = df.groupby('time')['PnL'].sum().cumsum().reset_index()

    # Plotting
    plt.figure(figsize=(12, 6))
    plt.plot([item.strftime("%H:%M:%S") for item in cumulative_pnl['time']], cumulative_pnl['PnL'], marker='o', linestyle='-', color='b')
    plt.title('Cumulative PnL Over Time of Day')
    plt.xlabel('Time of Day')
    plt.ylabel('Cumulative PnL')
    plt.xticks(rotation=45)
    plt.grid()
    plt.tight_layout()
    plt.show()

if __name__=="__main__":
    total_pnl('test_logs.csv')
    pnl_per_product('test_logs.csv')
    
