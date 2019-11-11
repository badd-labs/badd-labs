# Lab 2.3.3: Supply Chain with DeviceBlockchain Integration


In this lab, you are given the initial state that a custom Blockchain network of several miners is hosted on an on-campus machine which has been running for several days before the class. The Blockchain machine also runs a daemon that periodically instructs some miner to conduct transactions with other miners.

Create 3 accounts and Mine few Ethers in to all the accounts. Refer Lab 3.1 for more details.

In this lab, you will create a contract for part of the Supply chain transaction system given the System Design for the contract and call the functions on on-campus blockchain. Refer [[link](https://github.com/BlockchainLabSU/SUBlockchainLabs/blob/master/lab4.1/README_solc.md)] to know more about how to deploy simple contract and call its functions.


## Supply Chain Transaction System and Contract understanding

In commerce, supply chain management (SCM), the management of the flow of goods and services, involves the movement and storage of raw materials, of work-in-process inventory, and of finished goods from point of origin to point of consumption.
Supply-chain management has been defined as the "design, planning, execution, control, and monitoring of supply chain activities with the objective of creating net value, building a competitive infrastructure, leveraging worldwide logistics, synchronizing supply with demand and measuring performance globally."

We will be implementing the part of supply-chain where the seller wants to sell the product and buyer wants to buy the product. Transaction will be settled once we receive the approval of both the parties.

The following describes the protocol of a typical "supply Blockchain":

1. buyer first deposits her payments (e.g., $100) to the smart contract ( Deposit(100)).
2. supplier gets notified of buyer's deposit.
3. supplier starts to ship the product to the buyer.
4. when the good reaches the destination, a transaction is generated (e.g., agreed by both buyer and supplier) and is sent to the Blockchain. This triggers the payment to execute (DeliveredAndTransfer()).


## Contract Design

Create at least 3 accounts (one for Bank to collect the deposited amount by buyer and other two for buyer and seller) and mine few ethers, before you deploy the contract.

You can verify if the variables are updated using functions to get the value of the variable (and can make function as public view - consumes less gas value)

Variable list and functions mentioned below are just for reference. You can design the solution for this lab, provided all the functionalities are covered.

### Variables
1. variable of type struct to keep all the information about the product encapsulated.
2. we should be able to keep track of the products using variables (price, isDeliverd, inTransit, isDelivered etc). These can be changed during each sale.
3. product inventory to store all the products. 



## Lab Tasks

***Note: For task 1,2 and 3, you can deploy and run your smart contract using Remix***

### Lab Task 1: Create the products
you should be able to add the products, store all the products and should be able to handle the shipment of each product. 

### Lab Task 2: Shipment of the Product
Buyer deposits the amount to the contract address (status and price of the product can be updated). Once only the deposit is successful, Seller ships the product, not otherwise. Now, other users should not be able to initiate the shipment for this specific product.\
You can make two different functions to handle deposit and shipment.\
You should make sure that the shipping takes place only if the initial deposit is made by the buyer for the price of the product. Settlement of the transaction should happen only if both the parties approve the transaction.

### Lab Task 3: Delivery and Transfer
Assuming that good has reached the destination, a transaction will be initiated (check if price of product decided at deposit time is equal to msg.value before proceeding with transaction). If both the seller and buyer sign values are true, payment will be initiated. 

Make sure your contract is able to handle multiple shipments.


As we are trying to handle one product at a time in the work-flow, try to come up with the conditions which can be violated (like some other buyer tries to buy the product when it is in transit, transaction to settle is invoked when the deposit is not successful etc.) and try to resolve those conflicts in code.


### Bonus Task (20%): 

Deploy and run the code of Task 1,2,3 on our on-campus Blockchain. Include screenshots of the results in your report. You can use [[this tutorial](https://github.com/BlockchainLabSU/SUBlockchainLabs/blob/master/lab4.1/README_solc.md)] as a reference of how to deploy smart contracts on a on-campus Blockchain.

## Reference
https://en.wikipedia.org/wiki/Supply_chain_management


