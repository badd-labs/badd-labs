
实验A1
===

介绍
---

Etherscan (https://etherscan.io/) 是以太坊网络的区块链浏览器，可用于搜索交易、区块、钱包地址、智能合约以及其它链上数据。在实验中，你需要使该网站的信息来检索和分析etherscan上的以太坊交易历史记录。你将从中分析出关于交易费用的更深的理解。

练习1. 手动查询三个交易
---

假设以下 Etherscan 页面显示这个交易的详细信息（哈希 0x84ae）：
https://etherscan.io/tx/0x84aee3793659afeebfb89b86e6a8ffd3b9f143b3719c9b358905a83dbd71cb79
你需要计算三笔费用的的平均费用，是0x84ae，以及他的前一笔交易和他的后一笔交易。如果 tx1 在同一块中的 tx2 之前，交易 tx1 是 tx2 的前一笔交易。
提示：您可以在以下网页上找到与区块15479087相关的交易历史顺序：https://etherscan.io/txs?block=15479087

练习2. 手动探索单个区块
---

在区块 15479087 中找到交易额度最高的交易。报告他的哈希值。

练习3. 手动探索两个区块
---

找到区块15479087中的最后一笔交易和区块15479088中的第一笔交易。计算这两个交易的平均费用。
提示：假定一个区块中的第一笔交易是 etherscan.io 上该区块下第一页的第一行。 同样，一个区块中的最后一个交易是 etherscan.io 上该区块下最后一页的最后一行。

练习 4. 自动探索区块中五十个交易
---

```
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
        ######################## modify code below for each exercise #######################
        print("transaction of ID:", hash, "block:", block, "from address", from1, "toaddress", to1, "transaction fee",txnfee)

if __name__ == "__main__":  # entrance to the main function
    scrape_block(15479087, 1)
```

在本练习中，您将运行 Python 代码以自动从 etherscan 网站抓取数据。 上面的示例代码爬取 etherscan 网页（即 https://etherscan.io/txs?block=15479087）以读取块 15479087 中的前 50 笔交易。
要运行 Python 代码，您将需要 Python 运行时和一些库。 如果您的计算机不支持 Python，您可以在 https://www.python.org/downloads/上找到适用于 Windows 和 Mac 计算机的安装说明。 此外，Python 库可以在控制台中安装：

```
>>> pip3 install requests
>>> pip3 install beautifulsoup4
```

安装后，将上述 python 代码复制到一个文件中，并在 python 运行时（例如，您最喜欢的 python IDE）中运行该文件。 运行代码后，您可以观察打印在终端或 Python 控制台上的属性。

练习 5. 自动探索区块内中所有交易
---

在本练习中，您需要探索区块 15479087 中所有交易的平均费用。您需要修改给定的代码。
提示：区块 15479087 中的交易分三页列出。

练习 6. 自动探索两个区块间的交易
---

在本练习中，您需要报告 100 笔交易的平均费用，即区块 15479087 中的前 50 笔交易和区块 15479088 中的前 50 笔交易。您需要修改给定的代码。

练习 7（附加） 在一个区块中自动探索调用合约的交易
---

在本练习中，您需要报告块 15479087 中调用方法 transfer 的次数。 您需要修改给定的代码。

- 常见问题：如何验证您的代码是否正确？
    - 答：假设您修改后的 Python 代码需要扫描 100 笔交易并计算平均交易费用。要验证您的代码是否正确，您可以将程序中的数字 100 更改为较小的数字，例如 3，然后手动计算 3 笔交易的平均费用。如果手动计算结果等于你的程序结果，说明你的程序很可能是正确的。
- 问题：我可以在 4/5/6 做实验练习而不在我的电脑上安装任何东西吗？
    - 答：是的，这是可能的。您可以使用支持在网络浏览器中运行 python 代码的谷歌 colab 平台：https://colab.research.google.com/?utm_source=scs-index
- 问题：如何安装 Python IDE？
    - 答：不需要安装 Python IDE。但是，如果您愿意，您可以按照此处的说明安装 Pycharm for Python IDE：https://www.jetbrains.com/help/pycharm/installation-guide.html#toolbox。您需要在 Pycharm 中配置 Python 环境：https://www.jetbrains.com/help/pycharm/configuring-local-python-interpreters.html
