To efficiently interact with the Ethereum node on your own computer, for example, retrieve blocks and transactions, you can use Web3 to do that.

1. Install python3 
```bash
   sudo apt updates
   sudo apt upgrades
   sudo apt install python3.6
```
2. Install web3
```bash
   sudo python3.6 -m pip install web3
```

3. Write your own python code (say __get_bkc.py__) to retrieve content from your Ethereum node. 
```
from web3 import Web3

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))

for i in range(1, 10):
    print(w3.eth.getBlock(i))
```

4. Execute the above code will print out the first 10 blocks. 
```
python3.6 get_bkc.py
```

More web3py functions for working with Ethereum can be found at https://web3py.readthedocs.io/en/stable/web3.eth.html.
