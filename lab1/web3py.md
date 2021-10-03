To efficiently retrieve the information stored in your Ethereum node, such as blocks and transactions, you can use Python to work with the Web3py library. 

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

4. Execute the above code will print out the first 10 blocks. Note that in order to connect to your Ethereum node, you have to enable RPC by add '--rpc' (or --http) when you start Geth. For example, in step 2.1 of Lab 1, start Geth with this command 'geth --datadir bkc_data --rpc --networkid 89992018 --bootnodes "enode://a3b871242d7e40dc517514f6a995c2514cbe4907827275e3164ff43fb95d1d977d77e66da2e992c94a0843337fdfb86c9a02254e414db8ff0d6dbba15f32eb22@128.230.210.231:30301" console 2>console.log'.
```
python3.6 get_bkc.py
```

More web3py functions for working with Ethereum can be found at https://web3py.readthedocs.io/en/stable/web3.eth.html.
