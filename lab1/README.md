Lab 1: Blockchain Storage and Mining on Campus
===

In this lab, you are given the initial state that a custom Blockchain network of several miners is hosted on an on-campus machine which has been running for several days before the class. The Blockchain machine also runs a daemon that periodically instructs some miner to conduct transactions with other miners.

- Link of this lab (raw): https://goo.gl/gAU8nq
- Link to genesis.json: https://goo.gl/onnjb4 

Prerequisite
---

1. Linux shell commands
2. Understand [Ethereum](http://www.ethdocs.org/en/latest/introduction/index.html)

Lab Environment Setup
---

### 1A. Download our VM with Ethereum 

Install VirtualBox on your computer: https://www.virtualbox.org/wiki/Downloads . Choose `Ubuntu-64` bit option while installing the VM.

Download our prebuilt VirtualBox image from [[here](https://drive.google.com/file/d/19_U2UmsnZmMGRwe4AxMlfYoEot-xZ7Br/view?usp=sharing)]. Make sure this image runs with more than 4 GB memory. There is a user `user1` and the password is `blockchainsu`. 

**_Script 1a_**: 

```
$ mkdir -p ~/lab1/bkc_data
$ cd ~/lab1
$ gedit genesis.json
```

Copy this online file [[link](https://raw.githubusercontent.com/syracuse-fullstacksecurity/SUBlockchainLabs/master/lab1/genesis.json)] to the gedit and save it (by hitting `control+S` in Ubuntu).

### 1B. (Alternative option) Install Ethereum on your OS

If you are good with option 1A, you can skip 1B. This step is for who want to install Ethereum on their OS.

We will use `Geth`, the Ethereum client implemented in Language `Go`. You can choose to either install the `Geth` on you own machine or the Linux machine running on VirtualBox. See [here](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum) for more information.

***Ubuntu Users***

Here is the instructions to install the `Geth` for Ubuntu.

Even when you are not using Ubuntu as native OS, you can set up VirtualBox and download a Ubuntu-1604-LTS image from [[here](http://releases.ubuntu.com/16.04.5/)]. This image is typically 1 GB, much smaller than the 7 GB image above. To set up an empty Ubuntu OS on VirtualBox, here is a useful [[link](https://medium.com/@tushar0618/install-ubuntu-16-04-lts-on-virtual-box-desktop-version-30dc6f1958d0)].


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
$ mkdir -p ~/lab1/bkc_data
$ cd ~/lab1
$ geth --datadir bkc_data init ~/lab1/genesis.json # create a database that uses this genesis block
$ geth --datadir bkc_data --networkid 89992018 --bootnodes enode://7320559847736145843099b94c6c67d52c3abd4af42200dde25557d58da3f36358b6a029ff37058461ee5e627aed6fb55386c3e334b54fa35480aee4ea73eb61@128.230.208.73:30301 console 2>console.log 
```

Alternatively, you can try other enodes like `enode://7320559847736145843099b94c6c67d52c3abd4af42200dde25557d58da3f36358b6a029ff37058461ee5e627aed6fb55386c3e334b54fa35480aee4ea73eb61@128.230.208.73:30303`.

In the last command above, `--networkid` specify the private network ID. Connections between nodes are valid only if peers have identical protocol version and network ID, you can effectively isolate your network by setting either of these to a non default value. `--bootnode` option specify the bootnode address, following the format `[nodeID]:IP:port`. Every subsequent Geth node pointed to the bootnode for peer discovery. [This page](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) describes the options for ```geth``` commands.

**2.2 Add a Peer Miner**: Manually add a peer node to your miner node by a specific node URL. (Updates: It seems that add a peer miner is not required to connect your miner nodes to the on-campus Blockchain network).

**_Script 2.2_**: 

```bash
$ admin.addPeer("enode://7320559847736145843099b94c6c67d52c3abd4af42200dde25557d58da3f36358b6a029ff37058461ee5e627aed6fb55386c3e334b54fa35480aee4ea73eb61@128.230.208.73:30303")
```

Check the connectivity by running:

**_Script 2.3_**: 

```
> admin.peers
```

This command should return non-empty text about the peer nodes connected by your miner node.


### 3A. Get Coins by Transactions

**_Script 3a.1_**: 


```
> personal.newAccount() # create an Account
> eth.accounts # check accounts
```

Publish your account identity to the public bulletin (https://goo.gl/6WHAq9). The TA will send some coins to your account.
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

You can now start/stop the miner. If mining doesn't seem to work, you may try to unlock your account and start mining again:

```
> personal.unlockAccount(“accountAddress”, “accountPassword”)
```

**_Script 3b.2_**: 

```
> miner.start(1)# one thread in this case, you can increase the thread number to increase the mining power so that you can compete with remote server.
> miner.stop()
```

Mining takes a while to get start, you can monitor the event log by

**_Script 3b.3_**: 

```
tail -f ~/lab1/console.log
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
> loadScript("/path/to/script.js")
```

**Task 1:** After you started mining, show the coins that you have mined. Then wait 1 minute, check the balance again.

**Task 2:** Show the content (show the latest three blocks and the latest transaction) on the blockchain. Then wait 1 minute, show the blockchain again to see how it is extended over time. (Hint: To find the latest transaction on the blockchain, you can iterate through the blocks and check the transaction(s) in them. To iterate through the blocks, you can use JavaScript.)

**Task 3:** 

1. Submit a transaction, say `tx5`, to the blockchain. You create another account as the recipient (seller) of the transaction. 

2. Show whether transaction `tx5` is included in the Blockchain; if not wait for a while, check again.

Note 1: The above command will return a hash tag which served as the ID of the transaction, you could use that ID to query the transaction in the future.

Note 2: [Ether](http://www.ethdocs.org/en/latest/ether.html) is the name of the currency used within Ethereum. Wei is the smallest unit in Ethereum. 1 Ether = 10^18 Wei. The account balance and transfer amount are shown in Wei. You can use the converter utility web3.fromWei and web3.toWei to convert between Ether and Wei. 


Deliverable
---

- For each task, the deliverable includes the following:
    1. The script program of the Geth commands
    2. The screenshot that shows your script has run successfully on your computer
        - Make sure include your name in the screenshot. You can, for example, open a text editor with your name in it. 

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
- Q4: How to check if my node is mining?
    - Answer: You can check by running "eth.mining", it returns "true" or "false" to indicate if the mining is on-going or not. Note: "miner.getHashrate()" may return "0" even if the mining process is active. 
    
- Q5: I choose options 1.A to setup the environment, and it is running out of disk memory, what would I do?
    - Answer: You have two options.
        1, You can choose to install a Ubuntu inside of VirtualBox and start from option 1.B (recommended)
        2, you can add a new virtual hard disk to your current virtual machine.
            Step 1:  Follow the instructions in the below link (but skipping the last step - "mounting the partition") [[Add Disk Storage](http://www.vitalsofttech.com/add-disk-storage-to-oracle-virtualbox-with-linux/)]. Step 2: Run the below command to cleanup some space
               `sudo rm -rf /var/*`
               Step 3. Run the below command to mount the new disk to the home directory. `sudo mount /dev/sdb1 ~`
             
- Q5: Why does ```admin.peers``` return null sometimes?

    - ```admin.peers``` returns you the information about connected remote nodes and it seems like the method uses public IP addresses for this. Few students mentioned that ```admin.peers``` runs successfully when they run it outside of the school network while it failed in the shcool network. Even though it's returning null, you should still be able to mine your own coins if you connected to the private blockchain network successfully.

- Q6: Out of space?

   - Clear the folder  ~/.ethereum/ after you finish the lab. Also, clear the folder specified through ``--datadir'' when starting geth.
