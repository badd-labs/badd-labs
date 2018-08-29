Lab 4.1: Smart Contract Programming
===

The learning objective of this lab is for students to acquire programming skills in smart contracts and to develop basic programs. The lab will consider an educational scenario of smart contract, that is, the rock-paper-scissors game. The lab will be developed on Ethereum/Solidity platform using existing programming platform such as Remix. There will be programming exercises for students to implement two-party computation (e.g., `max(x,y)`) and three-party rock-paper-scissors game.

**Lab Description**: This module consists of two lab exercises and a bonus exercise. This helps in getting the grip on the solidity language used to write smart contracts which can be deployed on the blockchain. This lab concentrates on using the Remix IDE which is available to write, test, compile and deploy the smart contract, without need to set up any blockchain. Bonus task requires you to deploy and run the smart contract on on-campus blockchain (Link to refer is given). The module is outlined below:

Remix
---

Remix is an online development platform that helps you write Solidity contracts straight from the browser. Written in JavaScript, Remix supports both usage in the browser or locally. Remix supports the full programming cycle of smart contracts, including testing, debugging and deployment. You can find more information about Remix IDE in [[link](https://remix.readthedocs.io/en/latest/)]

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
