Lab A1: Transaction History Exploration
===

Introduction
---

Etherscan (https://etherscan.io/) provides a web service to explore Ethereum transactions and blocks. In this lab, you will retrieve and analyze Ethereum transaction history on etherscan by interacting with this website. Particularly, you will extract insights on transaction fees.

| Tasks | CS student | Finance student
| --- | --- | --- |
|  1  | Required | Required |
|  2  | Required | Required |
|  3  | Required | Bonus (50%) |
|  4  | Required | Bonus (50%) |
|  5  | Required | Bonus (50%) |

Task 1. Manually explore two transactions
---

Suppose the following Etherscan page shows details of a particular transaction (hash 0x936c):

https://etherscan.io/tx/0x936ccf3baa1721689b960326a36abccdf5088b219df65474ad910a6fa8ca2d6d 

You are asked to report the average fees of transaction 0x936c and the next transaction. 

Hint: You can find ordered transaction history related to block 15479087 on the following web page: https://etherscan.io/txs?block=15479087

Task 2 Manually explore transactions across two blocks
---

Find the last transaction in block 15479087 and the first transaction in block 15479088. Report the average fees of these two transactions.


Task 3. Automatically explore 50 transactions
---

```python
import requests
from time import sleep
from bs4 import BeautifulSoup

def scrape_block(blocknumber, page):
    # the URL of the web page that we want to get transaction data
    api_url = "https://etherscan.io/txs?block=" + str(blocknumber) + "&p="+str(page)
    # HTTP headers used to send a HTTP request
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:72.0) Gecko/20100101 Firefox/72.0'}
    # Pauses for 0.5 seconds before sending the next request
    sleep(0.5)
    # send the request to get data in the webpage
    response = requests.get(api_url, headers=headers)
    # get the transaction table from the response data we get
    for row in BeautifulSoup(response.content, 'html.parser').select('table.table-hover tbody tr'):
        # each row in the table is a transaction
        attributes = map(lambda x: x.text, row.findAll('td'))
        # extract transaction attributes
        _begin, hash, method, block, timestamp1, age, from1, _arr, to1, value1, txnfee, burnfee = attributes
        ######################## modify code below for each task #######################
        print("transaction of ID:", hash, "block:", block, "from address", from1, "toaddress", to1, "transaction fee",txnfee)

if __name__ == "__main__":  # entrance to the main function
    scrape_block(15479087, 1)
```

In this task, you will run a python code to crawl data from the etherscan website automatically. The example code above crawls the etherscan web page  (i.e., https://etherscan.io/txs?block=15479087) to read the first 50 transactions in block 15479087.

To run the python code, you will need a Python runtime and some libraries. If your computer does not support Python (yet), you can find installation instructions on
https://www.python.org/downloads/ for both Windows and Mac machines. In addition, the Python libraries can be installed in a Python console: 

```bash
>>> pip3 install requests
>>> pip3 install beautifulsoup4
```

After installation, copy the above python code to a file and run the file in a python runtime (e.g., your favorite python IDE). After running the code, you can observe transaction attributes printed on the terminal or Python console.

Task 4. Automatically explore all transactions in one block

In this task, you are required to report the average fee of all transactions in block 15479087. You can modify the given code.

Hint: transactions in block 15479087 are shown on three pages.

Task 5. Automatically explore transactions across two blocks

In this task, you are required to report the average fees of the first 50 transactions in block 15479087 and the first 50 transactions in block 15479088. You can modify the given code.

Deliverable
—

1. Report the transaction fee required for each task.
 
2. For task 3, submit the screenshot that runs the crawler code on your computer.

3. For task 4/5, submit your modified Python file and the screenshot that runs the code on your computer.

FAQ
---

- Q: How to install a Python IDE?
- You may want to install Pycharm (the community version) by following the instruction here: https://www.jetbrains.com/help/pycharm/installation-guide.html#toolbox. You will need to configure Python interpreter in Pycharm: https://www.jetbrains.com/help/pycharm/configuring-local-python-interpreters.html.

