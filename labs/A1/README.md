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
from time import sleep
from bs4 import BeautifulSoup
import re

pattern = r'0x[a-fA-F0-9]{40}'


def scrape_block(blocknumber, page):
    # the URL of the web page that we want to get transaction data
    api_url = "https://etherscan.io/txs?block=" + str(blocknumber) + "&p=" + str(page)
    # HTTP headers used to send a HTTP request
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:72.0) Gecko/20100101 Firefox/72.0'}
    # Pauses for 0.5 seconds before sending the next request
    sleep(0.5)
    # send the request to get data in the webpage
    response = requests.get(api_url, headers=headers)
    # get the transaction table from the response data we get
    txs = BeautifulSoup(response.content, 'html.parser').select('table.table-hover tbody tr')
    for row in txs:
        tx = extract_transaction_info(row)
        print("transaction of ID:", tx['hash'], "block:", tx['block'], "from address", tx['from'], "toaddress", tx['to'], "transaction fee", tx['fee'])


def extract_transaction_info(tr_element):
    try:
        # Extract transaction hash
        tx_hash = tr_element.select_one('.myFnExpandBox_searchVal').text.strip()

        # Extract transaction type
        tx_type = tr_element.select_one('span[data-title]').text.strip()

        # Extract block number
        block = tr_element.select_one('td:nth-child(5) a').text.strip()

        # Extract timestamp
        timestamp = tr_element.select_one('td.showAge span')['data-bs-title']

        # Extract from address
        from_element = tr_element.select_one('td:nth-child(9) a')
        from_addr = tr_element.select_one('td:nth-child(9) a').text.strip()
        if 'data-bs-title' in from_element.attrs:
            from_full = from_element['data-bs-title']
        else:
            # Try to get from span if <a> doesn't have it
            from_span = from_element.select_one('span[data-bs-title]')
            from_full = from_span['data-bs-title'] if from_span else from_addr
        from_address = re.search(pattern, from_full).group()

        # Extract to address
        to_element = tr_element.select_one('td:nth-child(11) a')
        to_addr = to_element.text.strip()
        # to_full = to_element['data-bs-title'] if 'data-bs-title' in to_element.attrs else to_addr
        if 'data-bs-title' in to_element.attrs:
            to_full = to_element['data-bs-title']
        else:
            # Try to get from span if <a> doesn't have it
            to_span = to_element.select_one('span[data-bs-title]')
            to_full = to_span['data-bs-title'] if to_span else to_addr
        to_address = re.search(pattern, to_full).group()

        # Extract value
        value = tr_element.select_one('.td_showAmount').text

        # Extract transaction fee
        tx_fee = tr_element.select_one('.showTxnFee').text.strip()

        # Extract gas price if available
        gas_price = tr_element.select_one('.showGasPrice')
        gas_price = gas_price.text.strip() if gas_price else None

        return {
            'hash': tx_hash,
            'type': tx_type,
            'block': block,
            'timestamp': timestamp,
            'from': from_address,
            'to': to_address,
            'value': value,
            'fee': tx_fee,
            'gas_price': gas_price
        }

    except Exception as e:
        print(f"Error extracting transaction info: {e}")
        return None


if __name__ == "__main__":  # entrance to the main function
    scrape_block(15479087, 1)
```

In this exercise, you will run a python code to crawl data from the etherscan website automatically. The example code above crawls the etherscan web page  (i.e., https://etherscan.io/txs?block=15479087) to read the first 50 transactions in block `15479087`.

To run the python code, you will need a Python runtime and some libraries. If your computer does not support Python (yet), you can find installation instructions on
https://www.python.org/downloads/ for both Windows and Mac machines. In addition, the Python libraries can be installed in a Python console: 

```bash
>>> pip3 install requests
>>> pip3 install beautifulsoup4
```

After installation, copy the above python code to a file and run the file in a python runtime (e.g., your favorite python IDE). After running the code, you can observe transaction attributes printed on the terminal or Python console.

Exercise 5. Automatically explore all transactions in one block
---

In this exercise, you are required to report the average fee of all transactions in block `15479087`. You can modify the given code.

- Hint: transactions in block `15479087` are listed on three pages.

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

