Lab B0. Bank and tokens (temporary)
===

Excercise 3: Payment relay in smart contract
---

This exercise consists two steps.

Step 3F1. You will need to compile and deploy the following smart contract in Remix. When running it, you need to call function `pay` with argument `0x0000000000000000000000000000000000000000`. Before you call the 'pay' function, click the 'showBalance' button to display the balance and take a screenshot. Then you should send a transaction to execute the 'pay' function, you need to specify the value to be `10` Ether (on the left panel of Remix IDE, there is a 'value' field, in the blank below, type 10 and select the unit to be 'ether', by default it is 'wei'), then click 'pay' button to execute the transaction. After that, click 'showBalance' button to show the balance again and take and submit your screenshot.

```
pragma solidity ^ 0.4.25;
contract payrelay {
    
  function pay(address receiver) public payable {
    receiver.transfer(msg.value);
  }
  
  function showBalance() public view returns (uint256) {
      return 0x0000000000000000000000000000000000000000.balance;
  }
  
}
```

Step 3F2. In the above step, you send `10` Ether to account `0x0000000000000000000000000000000000000000` through the smart contract `payrelay`. In this exercise, you are required to add a few lines of code in the above program to implement the following rule: The updated `payrelay` smart contract should only relay payment when the value is above `12` Ether.

