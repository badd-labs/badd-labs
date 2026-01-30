Lab A1: Transaction History Exploration
===

Introduction
---

Etherscan (https://etherscan.io/) provides a web service to explore Ethereum transactions and blocks. In this lab, you will retrieve and analyze Ethereum transaction history on etherscan by interacting with this website. Particularly, you will extract insights on transaction fees.

| Exercises | Points | CS student | Finance student
| --- | --- | --- | --- |
|  1  | 10 |  Required | Required |
|  2  | 10 | Required | Required |
|  3  | 10 | Required | Required |
|  4  | 20 | Required | Bonus |
|  5  | 30 | Required | Bonus |
|  6  | 20 | Required | Bonus |
|  7  | 10 | Bonus | Bonus |

Exercise 1. Manually explore three transactions
---

Suppose the following Etherscan page shows details of a particular transaction (hash 0x84ae):

https://etherscan.io/tx/0x84aee3793659afeebfb89b86e6a8ffd3b9f143b3719c9b358905a83dbd71cb79

You are asked to report the average fees of three transactions, that is, transaction 0x84ae, its predecessor transaction and successor transaction. Transaction tx1 is the predecessor of tx2, if tx1 is ordered right before tx2 in the same block.

Hint: You can find ordered transaction history related to block `15479087` on the following web page: https://etherscan.io/txs?block=15479087

Exercise 2. Manually explore one block
---

Find the transaction that transfers the highest Ether "value" in block `15479087`. Report the transaction hash. 

Exercise 3. Manually explore two blocks
---

Find the last transaction in block `15479087` and the first transaction in block `15479088`. Report the average fees of these two transactions.

- Hint: Assume the first transaction in a block is listed as the first row on the first page under that block on etherscan.io. Likewise, the last transaction in a block is listed as the last row on the last page under that block on etherscan.io.

Exercise 4. Automatically explore 50 transactions in one block
---

```python
import requests
import time
API_KEY = "YOUR_KEY"
URL = "https://api.etherscan.io/v2/api"
SLEEP = 0.25

def get_block_txs(block_number):
    params = {"chainid": "1", "module": "proxy", "action": "eth_getBlockByNumber", "tag": hex(block_number), "boolean": "true", "apikey": API_KEY}
    r = requests.get(URL, params=params)
    r.raise_for_status()
    data = r.json()

    if "result" not in data or isinstance(data["result"], str):
        print(data)
        raise RuntimeError("Etherscan API error")
    return data["result"]["transactions"]

def get_receipt(tx_hash):
    time.sleep(SLEEP)
    params = { "chainid": "1", "module": "proxy", "action": "eth_getTransactionReceipt", "txhash": tx_hash, "apikey": API_KEY } 
    r = requests.get(URL, params=params)
    r.raise_for_status()
    data = r.json()
    if "result" not in data or isinstance(data["result"], str):
        print(data)
        raise RuntimeError("Receipt error")
    return data["result"]

if __name__ == "__main__":
    block_number = 15479087
    txs = get_block_txs(block_number)
    print("tx count:", len(txs))
    for tx in txs[:50]:
        receipt = get_receipt(tx["hash"])
        # value, gasused, gasprice
        value_eth = int(tx["value"], 16) / 10**18
        gas_used = int(receipt["gasUsed"], 16)
        eff_gas_price = int(receipt["effectiveGasPrice"], 16)
        print("hash:", tx["hash"], "from:", tx["from"], "to:", tx.get("to"), "value_eth:", value_eth, "gasUsed:", gas_used, "effectiveGasPrice:", eff_gas_price, "status:", receipt["status"]
)
```

In this exercise, you will run the above python code to obtain transaction data via RPC API (provided by RPC service at https://api.etherscan.io/v2/api). The code retrieves the information of the first 50 transactions in block `15479087`.

To run the python code, you will need a Python runtime and some libraries. If your computer does not support Python (yet), you can find installation instructions on https://www.python.org/downloads/ for both Windows and Mac machines. In addition, the Python libraries can be installed in a Python console: 

```bash
>>> pip3 install requests
>>> pip3 install beautifulsoup4
```

After installation, copy the above python code to a file and run the file in a python runtime (e.g., your favorite python IDE). After running the code, you can observe transaction attributes printed on the terminal or Python console.

Exercise 5. Automatically explore all transactions in one block
---

In this exercise, you are required to report the average fee of all transactions in block `15479087`. You can modify the given code.

- Hint: transactions in block `15479087` are listed on three pages.
- Hint: In Ethereum, a transaction's `fee' equals the transaction's `effectiveGasPrice' multiplied by its `gasUsed'.

Exercise 6. Automatically explore transactions across two blocks
---

In this exercise, you are required to report the average fees of 100 transactions, which are the first 50 transactions in block `15479087` and the first 50 transactions in block `15479088`. You can modify the given code.

Exercise 7 (Additional). Automatically explore contract-calling transactions in one block
---

In this exercise, you are required to report the number of transactions in block `15479087` that call the method `Approve`. You can modify the given code.

Deliverable
---

1. Report the transaction fee required for each exercise.
2. For exercise 4, submit the screenshot that runs the crawler code on your computer.
    - If there are too many results that cannot fit into a single screen, you can randomly choose two screens and do two screenshots. 
3. For exercise 5/6/7, submit your modified Python file and the screenshot that runs the code on your computer. The Python programs need to be stored in plaintext format and in separate files from your report. 

FAQ
---

- Question: How to verify your code is correct?
    - Answer: Let's say your modified Python code needs to scan 100 transactions and calculate the average transaction fee. To verify your code is correct, you can change the number 100 in your program to a smaller one, say 3, and manually calculate the average fee of the 3 transactions. If the manual calculation result equals your program result, it shows that your program is likely to be correct.
- Question: Can I do lab exercises 4/5/6 without installing anything on my computer?
    - Answer: Yes, it is possible. You could use Google's colab platform that supports running python code in a web browser:  https://colab.research.google.com/?utm_source=scs-index .
- Question: How to install a Python IDE?
    - Answer: It is not required to install a Python IDE (Python runtime is enough). But if you want, you can install the Pycharm for Python IDE (the community version) by following the instruction here: https://www.jetbrains.com/help/pycharm/installation-guide.html#toolbox. You will need to configure Python interpreter in Pycharm: https://www.jetbrains.com/help/pycharm/configuring-local-python-interpreters.html.

