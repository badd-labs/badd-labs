Lab A2: Smart-Contract Programming
===

The learning objective is to be able to execute given solidity program and to develop solidity program under given requirements.

Solidity is an object-oriented programming language for writing smart contracts mainly on Ethereum. In addition to our lecture on Solidity programming, there are other online tutorials [[here](https://solidity.readthedocs.io/en/v0.4.24/introduction-to-smart-contracts.html)].

You will use `remix`, a web-based IDE for solidity development, including writing, deploying and executing solidity programs. Detail about the Remix IDE can be found in [[link](https://remix.readthedocs.io/en/latest/)].

To write a Solidity program, you have to have an account payable, which is used as the constructor. Otherwise, you will not be able to make deposits/transfers. 


| Exercises | Points | CS student | Finance student
| --- | --- | --- | --- |
|  1  | 10 |  Required | Required |
|  2  | 10 | Required | Required |
|  3  | 10 | Required | Required |
|  4  | 20 | Required | Bonus |
|  5  | 30 | Required | Bonus |
|  6  | 20 | Required | Bonus |

Exercise 1: Hello-world contract with Remix
---

In Exercises 1, you will compile and execute a given Solidity program, listed below. Function `greeter` takes a string argument and stores it in Variable `greeting`. Function `greet` take no argument and returns the value of Variable `greeting`.

```
pragma solidity ^ 0.4.25;
contract hello { /* define variable greeting of the type string */  
  string greeting;
  function greeter(string _greeting) public {
    greeting = _greeting;
  } 
  function greet() public constant returns(string) {
    return greeting;
  }
} 
```

You can use Remix to compile, deploy and execute the above solidity code. 

- Compile the code using `Start to Compile` button provided in the Remix IDE. Check for the errors (if any) and resolve them.
- Deploy the contract using `Deploy` button provided under `Run` tab. You can see the deployed contracts and functions deployed on the right-bottom corner. Provide the input for `greeter` function and click on "transact" button. You can see transaction being successful in the "Remix Transactions" section. 
- Click on "greet" button/function, you can see the string value set for "greeting" using "greeter" function will be displayed. Submit the final screenshot of running this Solidity program.

Exercise 2: Find the Maximum 
---

In this exercise, you are asked to write a Solidity program to find the maximum of two values, x and y, and return that value. The Smart contact should have the following functionalities:

1. A function that takes integers `x` and `y` as input
2. Returns the bigger integer between  `x` and `y` as output. Deploy and run the program in Remix [[link](https://remix.ethereum.org/)]

<!--

Exercise 3: Rock-paper-scissors game
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
-->

Deliverable
---

- For all exercises, you should show the screenshot of you executing the program successfully. For instance, in Exercise 1, your screenshort should show the execution of a sequence such as `greeter("X")` and `greet()` which prints the value of `X`.
- In Exercise 2,3, you should also submit the solidity program you wrote.

For exercise 1a, 1b, 2, if you did not submit the screenshot of successful executions of your program, you will get 5 points deducted, and 10 points deducted for exercise 3.
In addition, in exercise 3, you have to demostrate your program executed successfully for cases of one winner and two winners. Missing one case will result in 5 points deduction. 
For exercise 3F,  you have to demostrate your program executed successfully for cases of paying more than 12 Ether, and paying less than 12 Ether. Missing one case will result in 5 points deduction.
