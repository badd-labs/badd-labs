Lab 4.1: Smart Contract Programming
===

The learning objective of this lab is for students to acquire programming skills in smart contracts and to develop basic programs. The lab will consider an educational scenario of smart contract, that is, the rock-paper-scissors game. The lab will be developed on Ethereum/Solidity platform using existing programming platform such as Remix. There will be programming exercises for students to implement two-party computation (e.g., `max(x,y)`) and three-party rock-paper-scissors game.

**Lab Description**: This module consists of two lab exercises and a bonus exercise. This helps in getting the grip on the solidity language used to write smart contracts which can be deployed on the blockchain. This lab concentrates on using the Remix IDE which is available to write, test, compile and deploy the smart contract, without need to set up any blockchain. Bonus task requires you to deploy and run the smart contract on on-campus blockchain (Link to refer is given). The module is outlined below:

Execution Option 1: Remix
---

Remix is an online development platform that helps you write Solidity contracts straight from the browser. Written in JavaScript, Remix supports both usage in the browser or locally. Remix supports the full programming cycle of smart contracts, including testing, debugging and deployment. You can find more information about Remix IDE in [[link](https://remix.readthedocs.io/en/latest/)]

Execution Option 2: On-Campus Ethereum
---

Step 1: Install `Solc` 
----

```
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
```

Step 2: Create a smart contract program
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
2. Save	it	to	same	directory	from	which	you	are	running	your	geth console.	(i.e.	in	the	‘lab3’	directory	as	per the previous lab instructions).

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

Step 3: Deploy the smart contract
----

1. Connect to the Ethereum network (these steps are the same as per the last lab)

```
$ geth --datadir bkc_data init ~/lab3/genesis.json # create a database that uses this genesis block
$ geth --datadir bkc_data --networkid 89992018 --bootnodes enode://d3cd4e70fe7ad1dd7fb23539c53982e42816b4218cc370e8af13945f7b5e2b4a288f8b949dbdba6a998c9141266a0df61523de74490c91fc1e3d538b299bb8ab@128.230.208.73:30301 console 2>console.log 
```

```bash
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

Step 4: Run the smart contract program
----

Run the below commands to call the deployed functions, the first one is calling `greeter` function, the second one is calling `greet` function.

```
> helloVar.greeter.sendTransaction("Hello",{from:eth.accounts[0],gas:700000}) 
"0xae7ef314af8923baf12d93d17cbfc62ba93dab325fbae94c0a5d9bec4578aa62"
> helloVar.greet.call()
"Hello"
```

Solidity
---

Solidity is a object-oriented programming language for writing smart contracts mainly on Ethereuem. The language tutorial of solidity, including the languarnge syntax, can be found in the documentation [[link](https://solidity.readthedocs.io/en/v0.4.24/introduction-to-smart-contracts.html)]

To write a Solidity program, you have to have an account payable, which is used as the constructor. Otherwise, you will not be able to make deposits/transfers in the contract. 

LAB EXERCISE 1: EXECUTING A HELLOWORLD PROGRAM IN SOLIDITY
---

Below is the solidity code for a simple ‘HelloWorld’ program. Function ‘greeter’ takes string as the input and stores in the variable ‘greeting’ and Function ‘greet’ just returns the value of variable ‘greeting’.

```
pragma solidity ^ 0.4.13;
   contract hello { /* define variable greeting of the type string */  
    string greeting;
       function greeter(string _greeting) public {
              greeting = _greeting;
       } 
       /* main function */
       function greet() public constant returns(string) {
              return greeting;
       }
} 
```


1.1 Compile the code using `Start to Compile` button provided in the Remix IDE. Check for the errors (if any) and resolve them.

1.2 Deploy the contract using `Deploy` button provided under `Run` tab. You can see the deployed contracts and functions deployed on the right-bottom corner. Provide the input for ‘greeter’ function and click on ‘transact’ button. You can see transaction being successful in ‘Remix Transactions’ section. 

1.3 Click on ‘greet’ button/function, you can see the string value set for ‘greeting’ using ‘greeter’ function will be displayed. Submit the final screenshot of running this Solidity program.

LAB EXERCISE 2: FIND THE MAXIMUM OF X AND Y
---
In this exercise, you are asked to write a Solidity program to find the maximum of two values, x and y, and return that value.The Smart contact should have the following functionalities:	1. A function that takes x and y as input	2. Returns the maximum of x and y as outputDeploy the program and run the program in the Remix IDE [[link](https://remix.ethereum.org/)]

Once you deploy successfully, provide the values for x and y and see the output value in the `remix transactions` section of the page, in `decoded output` row.  

LAB EXERCISE 3: IMPLEMENT ROCK-PAPER-SCISSORS GAME
---

Write a Smart contract to implement the Rock-Paper-Scissors game in solidity. You can use variables to keep track of the deposit and player values.The contract should have the following functionalities:

1. There should be two players. Consider one specific address as the owner address (where both players will deposit their money).
2. Each player deposits an initial amount of 5 Ethers into the owner account.
3. Once both the players deposit the money, allow them to play. While depositing the money, make sure you keep track of who is depositing and make him/her the player1 or player2 accordingly.
4. Write a function `play` which takes the string parameter (Choice of the player - Rock, paper, scissors) and consider their choice only if they have deposited successfully.
5. Once both the players have input their choices, find the winner and transfer the money as below:
    - a. If player1 wins, send bid amount ie, 10 Ethers to player1.
    - b. If player2 wins, send bid amount ie, 10 Ethers to player2.
    - c. If both the players win, divide the bid amount and send to players equally. Once the game is finished, `Account` values (on the right-top corner of the IDE) of the designated player addresses should be updated. Make sure the player is depositing exactly 5 Ethers else the transaction should be rejected. While depositing the amount (5 Ethers in our case), `Value` on the right-top corner must be equivalent to 5 Ethers, in-order for the Remix to send the transaction successfully.
