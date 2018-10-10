
Step 1: Install `Solc` 
----

```
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
```

Step 2: Migrate data from the previous lab.
----

In this lab, we are going to connect the same Ethereum network we used for the last lab, so we reusue all the data from the previous lab for this lab.

```
cd ~
cp -r lab3 lab4
cd lab4
```

Step 3: Create a smart contract program
----

1. Create a simple "Hello World" program, where you set the greeting string and output the greeting string and save the file as `hello.sol`
Sample Code is given below:
```
pragma solidity ^0.4.13;
contract hello {
 /* define variable greeting of the type string */
 string greeting;
 function greeter(string _greeting) public {
    greeting = _greeting;
 }

 /* main function */
 function greet() public constant returns (string) {
    return greeting;
 }
}
```
2. Save	it	to	`lab4` directory

3. Compile the code using solc/soljs depending on the installtion

```
solc -o . --bin --abi hello.sol
```
You	will see	two	files	generated	as	`hello.abi`	and	`hello.bin`	.	The `.abi` file	holds	the contract interface	&	.bin holds the	compiled	code.

4. Edit the generated .abi and .bin files to look as below

***hello.abi***
```
var helloContract = eth.contract([{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"greeter","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}])
```
***hello.bin***
```
personal.unlockAccount(eth.accounts[0])
var helloVar = helloContract.new({from:eth.accounts[0],
data:"0x608060405234801561001057600080fd5b506102d7806100206000396000f30060806040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063cfae321714610051578063faf27bca146100e1575b600080fd5b34801561005d57600080fd5b5061006661014a565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100a657808201518184015260208101905061008b565b50505050905090810190601f1680156100d35780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b3480156100ed57600080fd5b50610148600480360381019080803590602001908201803590602001908080601f01602080910402602001604051908101604052809392919081815260200183838082843782019150505050505091929192905050506101ec565b005b606060008054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156101e25780601f106101b7576101008083540402835291602001916101e2565b820191906000526020600020905b8154815290600101906020018083116101c557829003601f168201915b5050505050905090565b8060009080519060200190610202929190610206565b5050565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061024757805160ff1916838001178555610275565b82800160010185558215610275579182015b82811115610274578251825591602001919060010190610259565b5b5090506102829190610286565b5090565b6102a891905b808211156102a457600081600090555060010161028c565b5090565b905600a165627a7a72305820a06cc690f3e38c276b8c4e70ec8a61437d1c71e3779bdfbd2f8d12bc3601f20a0029",gas:500000})
```

Step 4: Deploy the smart contract
----

1. Connect to the Ethereum network (these steps are the same as per the last lab)

```
$ geth --datadir bkc_data init ~/lab4/genesis.json # create a database that uses this genesis block
$ geth --datadir bkc_data --networkid 89992018 --bootnodes enode://d3cd4e70fe7ad1dd7fb23539c53982e42816b4218cc370e8af13945f7b5e2b4a288f8b949dbdba6a998c9141266a0df61523de74490c91fc1e3d538b299bb8ab@128.230.208.73:30301 console 2>console.log 
>admin.addPeer("enode://d2547d500b1e982ac93a6ce1dbf34cff6545987740313373ccecb28e095c6ce4294e5cf4be2f002672d30fb717b8bd05e1a12163b24743b907bb7d2c37415928@[128.230.208.73]:30303")
```

2. Load and run the script to deploy smart contract

```
> loadScript("hello_sol_hello.abi")
> loadScript("hello_sol_hello.bin")
```
You will see the below message in console log file
```
INFO [06-26|14:39:04] Submitted contract creation              fullhash=0x3a866d157afb43afaef5e33ef7ec61ab0dfe2edf36783f8a332ee8d622dadea9 contract=0x5dDd255aBa54b65595BB80dDd492Ea260bBA23a1
```
Make	a	note	of both contract value which is contract address and transcation hash value,	which is used in	future.

Step 5: Run the smart contract program
----

Run the below commands to call the deployed functions, the first one is calling `greeter` function, the second one is calling `greet` function.

```
> helloVar.greeter.sendTransaction("Hello",{from:eth.accounts[0],gas:700000}) 
"0xae7ef314af8923baf12d93d17cbfc62ba93dab325fbae94c0a5d9bec4578aa62"
> helloVar.greet.call()
"Hello"
```
