# Lab 6: Auctions

Excercise 1
----
In this exercise, you are expected to design an open auction smart contract **openAuction** using solidity programing language. In an open auction, every participant is able to see the highest bid in the current period. Your code should implement the following logic.

1. Your contract constructor function should specify how long the *bidding time* will be and who will be the *beneficiary*.

2. A function __submitBid()__ can accept bids from any pariticipants and accepts their deposits within the bidding time. After the bidding time elapsed, no one can submit bids. The function only accepts a bid that beats the current highest bid. Within the bidding time, each bidder can submit bids multiple times. 

3. A funcion __auctionEnd()__ can be called after the bidding time which will select the bidder who submits the **second highest** bid as the winner. His deposit is transfered to the beneficiary.

4. The other bidders losing the auction is able to call the __withdraw()__ function to take back their deposits.

Excersice 2
----
In this excercise, you are required to implement a blinded auction protocol and write a **blindAuction** smart contract. In a blinded auction, paritipants are not allowed to see other bidders' bids and the highest bid. There will be two time periods, the first one is called bidding period, within which each pariticipant can submit a hash string to represent their bids. The other is called reveal period, within which each pariticipant need to reveal their real bids (the preimage of submitted hash). The bidding period starts and ends strictly before the reveal period.

Your contract should implement the following logic.

1. The contract deployer specifies the *bidding time*, *reveal time*, and *beneficiary*.
2. The insterested bidders should hide their real bids by submitting a *hash* and transfer an arbitrary amount of value as the deposit. Specifically, the hash can be computed from a triplet of [fake (boolean), amount (int), secret(bytes32)]), each bidder needs to call this function multiple times to submit different hashes (computed from different triplets) to hide their real bids. 
3. The contract only accept bids during the bidding period, and after that no one can submit bids and the reveal timer ticker starts. 
4. During the reveal period, each bidder need to reveal each of their previous submitted hash by sending the raw triplets to the contract. The contract then check if the hash of each raw triplet equals to each previously submitted hash. If not, the contract do not allow the bidder to withdraw the corresponding deposits in that unmatched bid.
5. After the reveal period, the **second highest bidder** will be the winner and his deposit will be transfered to the beneficiary.
6. The other bidders losing the auction *withdraw* their deposits.

__Hints__:
1. You can implemment a pure function to compute the hash string for any given triplets and then submit the hash as a blinded bid.
2. The bidders' deposits should be sent to the contract during bidding period. No deposit will be allowed after bidding peroid.
3. During the reveal period, if two bids have the same amount of deposit that equal to the highest bid, then who submits the bid later will be the winner. Similarly, if there are three or more bidders, then who submits the bid in the second earlist timestamp will be the winner.
4. Similarly, during the reveal period, if the highest bid does not have two bidders but the second highest bid has, then who submits the second highest bid in the earlist timestamp will be the winner.

__FAQ__
1. If there is no valid bid, what should the smart contract do? 
   The auction will fail and there is no winner.
2. If there is only one valid bid, what should the smart contract do?
   The auction will fail and there is no winner.

Deliverable
----
1. For all exercises, you should show the screenshot that you can execute your program successfully. For instance, in Exercise 1, your screenshort should show the execution of that different bidders submiting bids of different amounts, and the second highest bid wins the auction. In Exercise 2, your screenshort should show the execution of that different bidders submiting different hashes and revealing the preimage of the submitted hashes. Then the second highest bid wins the auction. 
2. You should also submit the solidity program you wrote.
