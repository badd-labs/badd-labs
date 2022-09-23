Lab A2: Smart-Contract Programming: Ether Bank
===

The learning objective is to be able to execute given solidity program and to develop solidity program under given requirements.

Solidity is an object-oriented programming language for writing smart contracts mainly on Ethereum. In addition to our lecture on Solidity programming, there are other online tutorials [[here](https://solidity.readthedocs.io/en/v0.4.24/introduction-to-smart-contracts.html)].

You will use `remix`, a web-based IDE for solidity development, including writing, deploying and executing solidity programs. Detail about the Remix IDE can be found in [[link](https://remix.readthedocs.io/en/latest/)].

To write a Solidity program, you have to have an account payable, which is used as the constructor. Otherwise, you will not be able to make deposits/transfers. 


| Exercises | Points | CS student | Finance student
| --- | --- | --- | --- |
|  1  | 15 |  Required | Required |
|  2  | 25 | Required | Required |
|  3  | 25 | Required | Required |
|  4  | 35 | Required | Bonus |

Exercise 1: Execute the hello-world SC
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

Exercise 2: Write SC to output max
---

In this exercise, you are asked to write a Solidity program to find the maximum of two values, x and y, and return that value. The Smart contact should have the following functionalities:

1. A function that takes integers `x` and `y` as input
2. Returns the bigger integer between  `x` and `y` as output. Deploy and run the program in Remix [[link](https://remix.ethereum.org/)]

Exercise 3: Execute SC for single-account Ether bank 
---

```
pragma solidity ^ 0.4.13;
contract bank {
  uint256 EtherBalance_Alice = 0;
  function deposit() public payable {
    EtherBalance_Alice = EtherBalance_Alice + msg.value;
  }
  function withdraw(uint256 ethers) public payable {
    msg.sender.transfer(ethers * 1000000000000000000);
    EtherBalance_Alice = EtherBalance_Alice - ethers;
  }
  function relay(address Bob) public payable {
     Bob.transfer(msg.value);
  }
  function getBalanceCA() public constant returns(uint256){
    return EtherBalance_Alice;
  }
  function getBalanceEOA() public view returns(uint256) {
    return 0x0000000000000000000000000000000000000000.balance;
  }}
```

1. Compile and deploy the above smart contract in Remix. 
2. After deployment, click the 'getBalanceCA' button to show the balance and take a screenshot. 
3. Select an account, say `Alice`. Make `Alice` send a transaction to call the 'deposit' function with Ether value `10` (on the left panel in Remix, type `10` in the 'value' field and select the unit 'ether'; by default it is 'wei'; then , click 'pay' button to execute the transaction). 
4. Click 'getBalanceCA' button again to show the balance and take another screenshot.
5. Select Alice to send a transaction to call the 'relay' function with argument `0x0000000000000000000000000000000000000000` and Ether value `20`. 
6. Click 'getBalanceEOA' button  to show the balance and take another screenshot.

<!--
Modify the given SC program to implement the following rule: The updated `payrelay` smart contract should only relay payment when the value is above `12` Ether.
-->

Exercise 4: Write SC for 2-account Ether bank
---

```
contract bank_multiaccount {
    function bank(address Alice, address Bob) public {}
    function deposit() public payable {}
    function withdraw(uint amount){}
}
```

Extend the above SC using the same function signature to implement a two-account Ether bank. The correctness of your bank SC will be graded based on the following criteria:

Suppose your SC is deployed to the blockchain running constructor `bank(Alice, Bob)`, `Alice` deposits $a$ Ether, and `Bob` deposits $b$ Ether. Suppose `Alice` attempts to withdraw $a'$ Ether and `Bob` attempts to withdraw $b'$ Ether. It is required that **`Alice`'s withdrawal always succeeds if and only if $a'\leq{}a$.** The same applies to `Bob`'s withdrawal, that is,  **`Bob`'s withdrawal always succeeds if and only if $b'\leq{}b$.** For instance, we may grade student solutions by testing the following cases:

| `a` | `a'` | `b` | `b'` | Correct result |
| --- | --- | --- | --- | --- |
| 5 | 3 | 4 | 2 | Success |
| 5 | 6 | 4 | 2 | Fail |
| 5 | 3 | 4 | 6 | Fail |
| 5 | 6 | 4 | 6 | Fail |

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

1. For exercise 1/2/3/4, submit the screenshot that runs the crawler code on your computer.
    - If there are too many results that cannot fit into a single screen, you can randomly choose two screens and do two screenshots. 
2. For exercise 2/4, submit your modified Solidity file and the screenshot that runs the code on your computer. The Solidity program need to be stored in a `.sol` file in plaintext format.
