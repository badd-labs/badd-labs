Module 3: Blockchain Storage and Mining on Campus
===

In this lab, you are given the initial state that a custom Blockchain network of several miners is hosted on an on-campus machine which has been running for several days before the class. The Blockchain machine also runs a daemon that periodically instructs some miner to conduct transactions with other miners.

Prerequisite
---


1. Linux shell commands
2. Understand [Ethereum](http://www.ethdocs.org/en/latest/introduction/index.html)

Lab Environment Setup
---

### 1A. Download our VM with Ethereum 

Install VirtualBox on your computer: https://www.virtualbox.org/wiki/Downloads

Download our prebuilt VirtualBox image from [[here](https://drive.google.com/file/d/19_U2UmsnZmMGRwe4AxMlfYoEot-xZ7Br/view?usp=sharing)]. Make sure this image runs with more than 4 GB memory. There is a user `user1` and the password is `blockchainsu`. 

**_Script 1a_**: 

```
$ mkdir -p ~/lab3/bkc_data
$ gedit genesis.json
```

Copy this online file [[link](https://raw.githubusercontent.com/syracuse-fullstacksecurity/SUBlockchainLabs/master/lab3.1/genesis.json)] to the gedit and save it (by hitting `control+S` in Ubuntu).

### 1B. (Alternative option) Install Ethereum on your OS

If you are good with option 1A, you can skip 1B. This step is for who want to install Ethereum on their OS.

We will use `Geth`, the Ethereum client implemented in Language `Go`. You can choose to either install the `Geth` on you own machine or the Linux machine running on VirtualBox which you've already had in previous lab. See [here](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum) for more information.

***Ubuntu Users***

Here is the instructions to install the `Geth` for Ubuntu.

**_Script 1b_**: 

```
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository -y ppa:ethereum/ethereum
$ sudo apt-get update
$ sudo apt-get install ethereum
```

***Mac Users***

**_Script 1bb_**: 

```
brew tap ethereum/ethereum
brew install ethereum
```

***Windows Users***

https://github.com/ethereum/go-ethereum/wiki/Installation-instructions-for-Windows

### 2. Join the Blockchain network

**2.1 Connect to the Blockchain Gateway (Bootnode)**: Every blockchain starts with the genesis block. When you run geth with default settings for the first time, the main net genesis block is committed to the database. For a private network, you usually want a different genesis block. We have a pre-defined custom [[genesis.json](genesis.json)] file. The `config` section ensures that certain protocol upgrades are immediately available. The `alloc` section pre-funds accounts, which is currently empty. Following the instructions below to run geth.

**_Script 2.1_**: 

```
$ mkdir -p ~/lab3/bkc_data
$ cd ~lab3
$ geth --datadir bkc_data init ~/lab3/genesis.json # create a database that uses this genesis block
$ geth --datadir bkc_data --networkid 89992018 --bootnodes enode://9b46f0691dd12ae427adde13988a56e4691ddcba52f7d6f32d4a4129c709196d1ade96985a9522aa73cac957b666b1f41d69ebceae350643ae83217196e6240d@128.230.208.73:30301 console 2>console.log 
```

In the last command above, `--networkid` specify the private network ID. Connections between nodes are valid only if peers have identical protocol version and network ID, you can effectively isolate your network by setting either of these to a non default value. `--bootnode` option specify the bootnode address, following the format `[nodeID]:IP:port`. Every subsequent Geth node pointed to the bootnode for peer discovery. [This page](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) describes the options for ```geth``` commands.

**2.2 Add a Peer Miner**: Add a peer node running on the remote machine by specify the node URL.

**_Script 2.2_**: 

```bash
>admin.addPeer("enode://62bceb7302bf4368858a15c408ab8d57a263cb590fb4a6ccb588a1ecad42266772370c5d6b3cdaa1a1284c80f6f3fe959ba1453761482fbcc9920a4c2c7099ab@128.230.208.73:30303")
```

Check the connectivity by running:

**_Script 2.3_**: 

```
> admin.peers
```

### 3A. Get Coins by Transactions

**_Script 3a.1_**: 


```
> personal.newAccount() # create an Account
> eth.accounts # check accounts
```

Publish your account identity to the public bulletin (e.g., the piazza post). The TA will send some coins to your account.
After that, you can check the balance.

**_Script 3a.2_**: 

```
> web3.fromWei(eth.getBalance(eth.accounts[0]),"ether")
```

### 3B. Get Coins by Mining

Before mining, the coinbase has to be specified to one personal account, where your earnings will be settled. Run following commands to create a new account, and set it as coinbase.

**_Script 3b.1_**: 

```
> personal.newAccount() # create an Account
> eth.accounts # check accounts
> miner.setEtherbase(eth.accounts[0]) # that address that will receive your earnings
```

You can now start/stop the miner. 

**_Script 3b.2_**: 

```
> miner.start(1)# one thread in this case, you can increase the thread number to increase the mining power so that you can compete with remote server.
> miner.stop()
```

Mining takes a while to get start, you can monitor the event log by

**_Script 3b.3_**: 

```
tail -f ~/lab3/console.log
```

To know currently you are mining or not, you can run 

**_Script 3b.4_**: 

```
> miner.getHashrate()  # The output should be a number, and this number indicates the current mining power. 
```

If you find your account has non-zero balance, you get some coins through mining:

**_Script 3b.5_**: 

```
> web3.fromWei(eth.getBalance(eth.accounts[0]),"ether")
```

The list of `Geth` commands can be found on [[this page](https://github.com/ethereum/go-ethereum/wiki/Management-APIs)].


Lab Tasks
---

The tasks in this lab require to inspect and modify the content of Blockchain. In addition to the Ethereum commands you used  above, there are other relevant commands as below.

```
> eth.accounts[0] # check the account id
> eth.getBalance(<account>) # check the balance for one account, the argument is account id
> web3.fromWei(<value>,"ether") # convert Wei to Ether
> web3.toWei(<value>,"ether") #convert Ether to Wei
> eth.blockNumber # check the latest block number on the chain
> eth.getBlock(eth.blockNumber-3) # display a certain block 
> eth.getBlock('latest', true) # display the latest block
> eth.getBlock('pending', true) # display the pending block
> eth.sendTransaction({from:"0x0c54f3f7d820bf52344772fa8ed097d1189cd93f", to:"0xda1b60c80502fea9977bab42dcebad05c289dcd2", value:web3.toWei(1,"ether")})
#eth.sendTransaction({from:senderAccount, to:receiverAccount, value: amount})
> eth.getTransaction("0x57dfe8f7f4760f09cd76a8b09000fd43275d798503ed88ed6d8b39c1d5ce3157")
```

**Task 1:** After you started mining, show the coins that you have mined. Then wait 1 minute, check the balance again.

**Task 2:** Show the content (all the blocks and transactions) on the blockchain. Then wait 1 minute, show the blockchain again to see how it is extended over time.

**Task 3:** 

1. Submit a transaction, say `tx5`, to the blockchain. You create another account as the recipient (seller) of the transaction. Optionally you can find other students' account on this [[document](https://docs.google.com/document/d/1nI3o1YH-rkAto9iysuExh5PbnFgCAgjFifturm2nQzg/edit?usp=sharing)];

2. Show whether transaction `tx5` is included in the Blockchain; if not wait for a while, check again.

Note 1: The above command will return a hash tag which served as the ID of the transaction, you could use that ID to query the transaction in the future.

Note 2: [Ether](http://www.ethdocs.org/en/latest/ether.html) is the name of the currency used within Ethereum. Wei is the smallest unit in Ethereum. 1 Ether = 10^18 Wei. The account balance and transfer amount are shown in Wei. You can use the converter utility web3.fromWei and web3.toWei to convert between Ether and Wei. 


FAQ/Trouble shooting
---

- Q1: When sending transaction, I got this error: "account is locked"
   - Answer: Before sending transactions, you may need to unlock your personal wallet/account and input passphrase. Example:

```
personal.unlockAccount(eth.accounts[0])
```
- Q2: In Mining, I keep getting zero balance?
    - Answer: One of possible reasons is your VM/OS does not have enough memory. We recommend at least 4 GB for mining. If you don't run mining, you don't have to allocate large memory for this lab.
- Q3: When my terminal crashes in VM (e.g., during mining),  I cannot restart the `geth` properly.
    - Answer: You can restart the VM to get around this issue. (Terminal crash may mess up network stack in your VM which `geth` depends on).
