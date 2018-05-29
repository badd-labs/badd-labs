Module 3: Blockchain Storage and Mining on Campus
===

In this lab, you are given the initial state that a custom Blockchain network of several miners is hosted on an on-campus machine which has been running for several days before the class. The Blockchain machine also runs a daemon that periodically instructs some miner to conduct transactions with other miners.

Prerequisite
---

1. Linux shell commands
2. Understand [Ethereum](http://www.ethdocs.org/en/latest/introduction/index.html)

Lab Environment Setup
---

### 1. Download VM with Ethereum clients

Install VirtualBox on your computer: https://www.virtualbox.org/wiki/Downloads

Download our prebuilt VirtualBox image from [[here](https://drive.google.com/file/d/1CGCbMczq66DSqChOYXG5QkOEvRaefykp/view?usp=sharing)]. Make sure this image runs with more than 4 GB memory. There is a user `user1` and the password is `blockchainsu`. 

You may want to open a terminal and update the `genesis.json` file:

```bash
cd ~/SUBlockchainLabs
git pull
# it succeeds if it prompts "Already up-to-date"
```

### 1' (Alternative option). Download Ethereum clients

You can skip this step (1') if you have done step 1. This is for students who want to use their native OS to do the mining. 

There are several `Ethereum` [clients](http://ethdocs.org/en/latest/ethereum-clients/choosing-a-client.html) implementations, we will use the `Go` implementation, that is, `Geth`, for this lab. You can choose to either install the `Geth` on you own machine or the Linux machine running on VirtualBox which you've already had in previous lab. See [here](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum) for more information.

***Ubuntu Users***

Here is the instructions to install the `Geth` for Ubuntu.

```
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository -y ppa:ethereum/ethereum
$ sudo apt-get update
$ sudo apt-get install ethereum
```

***Mac Users***

```
brew tap ethereum/ethereum
brew install ethereum
```

***Windows Users***

https://github.com/ethereum/go-ethereum/wiki/Installation-instructions-for-Windows

### 2. Join the Blockchain network

**2.1 Connect to the Blockchain Gateway (Bootnode)**: Every blockchain starts with the genesis block. When you run geth with default settings for the first time, the main net genesis block is committed to the database. For a private network, you usually want a different genesis block. We have a pre-defined custom [[genesis.json](genesis.json)] file. The `config` section ensures that certain protocol upgrades are immediately available. The `alloc` section pre-funds accounts, which is currently empty. Following the instructions below to run geth.

```
$ cd labs; mkdir <data-dir>
$ geth --datadir lab3 init ~/SUBlockchainLabs/lab3.1/genesis.json
# create a database that uses this genesis block
$ # genesis.json file is in ~/labs/SUBlockchainLabs/lab3.1 in the VM image
$ geth --datadir <data-dir> --networkid 89992018 --bootnodes enode://dc9999f8ff5f19d304ef338d4d89428cf95df7dd0ad853581c7ad084dc7b86bd5d1711b041af8487b455e079513dd9419cde7f03dca30064fe0aca622f3910dd@128.230.208.73:30301 console 2>console.log 
```

In the last command above, `--networkid` specify the private network ID. Connections between nodes are valid only if peers have identical protocol version and network ID, you can effectively isolate your network by setting either of these to a non default value. `--bootnode` option specify the bootnode address, following the format `[nodeID]:IP:port`. Every subsequent Geth node pointed to the bootnode for peer discovery. [This page](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) describes the options for ```geth``` commands.

**2.2 Add a Peer Miner**: Add a peer node running on the remote machine by specify the node URL.
	
```
>admin.addPeer("enode://aaffef5c90bc23750a45a14e882818853d91759a2df4454623503b298a95c8ef440bdf2360955432eaece9f7b67d4369da1ab46d6ff68add90041b5e3ce5eba5@128.230.208.73:30303")
```	

Check the connectivity by running:
	
```
> admin.peers
```

### 3. Start Mining
	
Before mining, the coinbase has to be specified to one personal account, where your earnings will be settled. Run following commands to create a new account, and set it as coinbase.

```
> personal.newAccount() # create an Account
> eth.accounts # check accounts
> miner.setEtherbase(eth.accounts[0]) # that address that will receive your earnings	
```
	
You can now start/stop the miner. 
	
```
> miner.start(1)	# one thread in this case, you can increase the thread number to increase the mining power so that you can compete with remote server.
> miner.stop()
```

To know currently you are mining or not, you can run 
	
```
> miner.getHashrate()  # The output should be a number, and this number indicates the current mining power. 
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
> eth.getBlock(eth.blockNumber-3)  # display a certain block 
> eth.getBlock('latest', true)	# display the latest block
> eth.getBlock('pending', true)	# display the pending block
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

Note 3: Before sending transactions, you may need to unlock your personal wallet/account and input passphrase. Example:

```
personal.unlockAccount(eth.accounts[0])
```

