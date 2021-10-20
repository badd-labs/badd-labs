Lab L2-4.1/Exercise 1b: Hello-world on Solc and Ethereum
---

Start your Ethereum VM in VirtualBox and open a terminal there.

1. Install `Solc` 

Method 1a. Installing all versions of `solc` and use version `0.4.25`:

```
sudo python3 -m pip install py-solc
sudo python3 -m solc.install v0.4.25
sudo chmod 777 ~/.py-solc/solc-v0.4.25/bin/solc
sudo mv ~/.py-solc/solc-v0.4.25/bin/solc /usr/bin/solc
solc --version
```

Method 1b. 

```
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
```

You will find `solc` under the path `/usr/bin`.

For **MacOs**, please find the install instruction at: https://docs.soliditylang.org/en/v0.8.9/installing-solidity.html#macos-packages.

2. Set up the Ethereum client for this lab. We will reuse your client data (e.g., accounts and balances) created in the previous lab, and connect to the same Ethereum network.
```
cd ~
cp -r lab1 lab2
cd lab2
```

3. Create a smart-contract file. Copy the text of the above hello-world program and save it in a file `~/lab2/hello.sol`. 
    - You can use a text editor of your preference to do this, such as `vim`, `emacs`, `gedit`.
4. Compile the contract file using `solc` in the command below. You may also try `soljs` as the compiler.
```
solc -o . --bin --abi hello.sol
```

- After compilation, there should be two files generated: `hello.abi` and `hello.bin`. 
        - File `hello.bin` stores the compiled "binary" code. This is the code directly executed by miners.
        - File `hello.abi` defines the interface through which the compiled code interacts with the execution platform (or EVM). Like ABI, it defines how the binary code in `.bin` should be interpreted in EVM.

***hello.abi (original)***
```
[{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"greeter","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]
```

***hello.bin (original)***
```
608060405234801561001057600080fd5b506102d7806100206000396000f30060806040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063cfae321714610051578063faf27bca146100e1575b600080fd5b34801561005d57600080fd5b5061006661014a565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100a657808201518184015260208101905061008b565b50505050905090810190601f1680156100d35780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b3480156100ed57600080fd5b50610148600480360381019080803590602001908201803590602001908080601f01602080910402602001604051908101604052809392919081815260200183838082843782019150505050505091929192905050506101ec565b005b606060008054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156101e25780601f106101b7576101008083540402835291602001916101e2565b820191906000526020600020905b8154815290600101906020018083116101c557829003601f168201915b5050505050905090565b8060009080519060200190610202929190610206565b5050565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061024757805160ff1916838001178555610275565b82800160010185558215610275579182015b82811115610274578251825591602001919060010190610259565b5b5090506102829190610286565b5090565b6102a891905b808211156102a457600081600090555060010161028c565b5090565b905600a165627a7a72305820a06cc690f3e38c276b8c4e70ec8a61437d1c71e3779bdfbd2f8d12bc3601f20a0029
```

**Note**, If your `solc` compiler version is after 0.5.0, you may need to use the following **hello.sol** source code.
```bash
pragma solidity ^ 0.5.0;
contract hello { /* define variable greeting of the type string */  
  string greeting;
  function greeter(string memory _greeting) public {
    greeting = _greeting;
  } 
  function greet() public view returns(string memory) {
    return greeting;
  }
} 
```


5. To deploy the two compiled files, we need to first edit them as below.

***hello.abi (modified)***
```
var helloContract = eth.contract([{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"greeter","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}])
```
***hello.bin (modified)***
```
personal.unlockAccount(eth.accounts[0])
var helloVar = helloContract.new({from:eth.accounts[0],
data:"0x608060405234801561001057600080fd5b506102d7806100206000396000f30060806040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063cfae321714610051578063faf27bca146100e1575b600080fd5b34801561005d57600080fd5b5061006661014a565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100a657808201518184015260208101905061008b565b50505050905090810190601f1680156100d35780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b3480156100ed57600080fd5b50610148600480360381019080803590602001908201803590602001908080601f01602080910402602001604051908101604052809392919081815260200183838082843782019150505050505091929192905050506101ec565b005b606060008054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156101e25780601f106101b7576101008083540402835291602001916101e2565b820191906000526020600020905b8154815290600101906020018083116101c557829003601f168201915b5050505050905090565b8060009080519060200190610202929190610206565b5050565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061024757805160ff1916838001178555610275565b82800160010185558215610275579182015b82811115610274578251825591602001919060010190610259565b5b5090506102829190610286565b5090565b6102a891905b808211156102a457600081600090555060010161028c565b5090565b905600a165627a7a72305820a06cc690f3e38c276b8c4e70ec8a61437d1c71e3779bdfbd2f8d12bc3601f20a0029",gas:500000})
```

6. Deploy the smart contract by first connecting to the Ethereum network (these steps are the same as per the last lab)
```
$ geth --datadir bkc_data init ~/lab2/genesis.json # create a database that uses this genesis block
$ geth --datadir bkc_data --rpc --networkid 89992018 --bootnodes "enode://a3b871242d7e40dc517514f6a995c2514cbe4907827275e3164ff43fb95d1d977d77e66da2e992c94a0843337fdfb86c9a02254e414db8ff0d6dbba15f32eb22@128.230.210.231:30301" console 2>console.log  
```

7. Load and run the script to deploy smart contract
```
> loadScript("hello.abi")
> loadScript("hello.bin")
```

8. You will see the message below in console log file. For future use, take a note of both contract address and transaction hash value.
```
INFO [06-26|14:39:04] Submitted contract creation              fullhash=0x3a866d157afb43afaef5e33ef7ec61ab0dfe2edf36783f8a332ee8d622dadea9 contract=0x5dDd255aBa54b65595BB80dDd492Ea260bBA23a1
```

9. Execute the smart-contract program by running the following commands. They sequentially call two functions in the deployed contracts, `greeter` and `greet`. **Note:** in the below command, a `gas` amount of 700,000 is specified.

```
> helloVar.greeter.sendTransaction("Hello",{from:eth.accounts[0],gas:700000}) 
"0xae7ef314af8923baf12d93d17cbfc62ba93dab325fbae94c0a5d9bec4578aa62"
> helloVar.greet.call()
"Hello"
```

**Deliverable**: Finish the above commands to execute the hello-world contract. Submit the screenshot of contract-execution results.

