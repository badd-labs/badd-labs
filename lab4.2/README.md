# Module 4.2: Deploying Financial Derivatives Contract on Blockchain
---

In this lab, you are given the initial state that a custom Blockchain network of several miners is hosted on an on-campus machine which has been running for several days before the class. The Blockchain machine also runs a daemon that periodically instructs some miner to conduct transactions with other miners.

Create 3 accounts and Mine few Ethers in to all the accounts. Refer Lab 3.1 for more details.

In this lab, you will create a contract for Financial Derivative given the System Design for the contract and call the functions. Refer Lab 4.1 to know more about how to deploy simple contract and call its functions.


## Financial Derivatives and Contract understanding
---
In finance, a derivative is a contract that derives its value from the performance of an underlying entity. This underlying entity can be an asset, index, or interest rate, and is often simply called the "underlying".

Main challenge in implementing derivative is keeping track of the changes in the values between ethers (or other cryptocurrency) and other currencies (Ex USD). 

Financial Derivatives mainly follows below simple 4 steps
The hedging contract would look as below:
1. Let party A deposit 1000 ethers to bank account
2. Let party B deposit 1000 ethers to bank account
3. Get the USD value of 1000 ethers by querying the data feed (internal mappings in our case) and store the value(let it be $x). 
4. After 30 days, A or B can 'reactivate' the contract and send $x equivalent of ether (query the data feed at that time to get new price) to A and rest to B.

Here the term 'reactivate' financially can be considered as the set of actions that needs to be executed on the day of contract execution (actions will be pre-decided by both the parties involved in the contract). A Date will also be decided by the parties involved, here for lab purpose this can be considered as 30th day from the date of contract creation. Actions for lab purpose is to send $x equivalent ethers to one party and rest to the one who initiated reactivation of contract.   

Below is the more descriptive representation of the above 4 steps.

Let us consider the conversion rate as below for 1st and 30th day of the contract. 1st is contract creation date and 30th is contract execution date.

| Currency/Date | Ethers - e | USD - $|
|---------------|--------|-----|
| 1st Jan       | 1000   | 20  |
| 30th Jan      | 1500   | 20  |


1. Initially, A deposits 1000 Ethers in to Bank Account on 1st Jan (You can Consider less Ethers for convenience purpose)
    - B deposits 1000 ethers in to Bank Account on 1st Jan
    - Bank Account will now have 2000 Ethers
2. Let 1000 Ethers be Equivalent to $20 on 1st Jan.
3. Once both the parties have deposited the required amount of the hedging contract, payment of equivalent $x USD (20 in this case) is registered in database for this transaction.
4. A or B reactivates the contract after 30 days, in order to send $x ($20 in our case) worth of ethers to another account involved in the hedging contract
5. Let us consider for example, B reactivates the contract in order to send $20 worth of Ethers to account A and rest to his own account on 30th Jan. Hence,
Send 1500 to A (On 30th, $20 = 1500e)
And 500 to B (2000e-1500e = 500e)
Bank account should be deducted by total Ethers invested by both A and B (2000 Ethers in this case). Bank account now will have 0 Ethers

## Contract Design
---
Create at least 3 accounts (one for Bank to collect the deposited amount and two for A and B who deposits the amount) and mine few ethers, before you deploy the contract.

Variable list and functions mentioned below are just for reference. You can design the solution for this lab as you please.

### 1 - Variable List
1. Create a variable of type address called owner which holds the Bank account address (Bank address can be hard-coded for this contract).
2. counter - To keep track of each payment/hedge contract, a has a unique identifier
3. prevcounter - a variable to keep track of recent payment/transaction recorded, based on the requirement (variable counter can be used directly instead). 
4. Below are the mappings required for this contract
    - mapping 'balances' keep track of the account balance
    - mapping 'isDeposited' keep track of deposit status of two accounts A and B, returns true or false
    - mapping 'paymentrec' keep track of payment records with their equivalent USD rate with the incremented counter value(This is the variable used to keep track of the hedge contract value once both the parties have deposited - contract number/counter along with its USD equivalent). For example, once both the parties deposit, if the next counter value is 5 and USD equivalent is $10, make an entry of 5 -> 10
    - mapping 'currencyEthertoUSD' conversion rate from Ether to USD
    - mapping 'currencyUSDtoEther' conversion rate from USD to Ether


### 2 - Constructor of the contract
Please make sure that Constructor of the contract is payable else, you will not be able to make deposits/transfers in the contract.
Initiate the variable 'balances' with the account addresses and load the accounts with few Ethers (This will avoid the negative balances which could lead to abnormal account balances)
Initiate variables 'currencyEthertoUSD' and 'currencyUSDtoEther' with dummy values.
Ex, currencyEthertoUSD[10] = 5;
		currencyUSDtoEther[5] = 15;

### 3 - Functions
1. 'deposit' which takes sender address, receiver address and amount to transfer as parameters. Please make sure that this function is payable. This function should make sure that the required amount is sent by the party (A or B). Send the deposit amount to Bank account and update balances and isDeposited variable. Main account (eth.getBalance(eth.accounts[n])) balance should also be updated.
2. 'checkBothAccountDeposit' can be used to send the status (true or false) of deposit of both the parties (A and B)
3. 'getCounter' returns the latest counter/unique identifier on which the transaction was recorded i.e, prevCounter
4. 'recordpay' should make an entry in variable 'paymentrec' by incrementing the 'counter' and equivalent USD rate of this transaction should be stored. Update prevCounter. Entry should only happen if both the parties have deposited their share in the bank account.
5. 'reactivateContract' should be called after 30 days. Account which triggers reactivation of contract, other account in the hedge contract, Number of days and Total Ethers invested can be passed as the parameters. All the steps in the function should only be executed if days variable is 30. Get the 'paymentrec' of this transaction using 'prevCounter'. Get the Ether value of this transaction using 'currencyUSDtoEther'. Send obtained amount of ethers to other account and rest to triggered account. Update the 'balances' variable for A, B and Bank account.




