## Lab 3.3: BLOCKCHAIN Applications: LOGGING REMOTE FILE STORAGE

### Lab Setup

Install `node.js`

```
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
sudo apt install nodejs
```


### Lab Description:

The Blockchain technology can be used in applications beyond cryptocurrency. In this lab, we explore the Blockchain application for logging the operation trace of a remote file-storage service. This features a common use of the Blockchain, that is, making the data about a third-party transparent to invite trusts.
The learning objective of this lab is for students to design and implement a simple service for secure distributed file system (SDFS) and use the Blockchain technology to log the service. The target system consists of a client supporting multiple file-system users and a server storing a file. 
 
#### Lab Environment:

The SDFS includes classic information-security protocols for permission-based access control and password authentication. For simplicity, in this project you only need to consider the concrete and specific execution sequence as below: Initially, a server stores a single file fileX. Two clients userA and userB can interact with the server in the following sequence: 

```
user_login("userA", "pwd123");  
user_login("userB", "pwd456");  
file_permission_set("userA");  
file_access("userA"); //success  
file_access("userB"); //failure  
file_delegate("userA", "userB");  
file_access("userB"); //success  
user_logout("userA");  
user_logout("userB");  
```

The operations used above are defined as below:
 
In the following, there are four exercises of this lab: User login/logout using password (authentication), access control using permission (authorization), Blockchain logging, tracing user login and access requests using Blockchain.

#### TUTORIAL ON USING GETH IN JAVASCRIPT/WEB3
To interact Ethereum blockchain through Javascript, you will need to use ‘web3’ object in the ‘web3.js’ library. The following sample code sends a transaction to Blockchain by Javascript: 

```
web3.eth.sendTransaction({from:var1,data:var2,to:var3},function(var4,var5) {
    if (var4)
      //Failed to send the transaction
    else 
      // The transaction is acknowledged successful by the Blockchain
  });
```

The arguments in sendTransaction() are explained below:

- `var1`: This argument is an account address of the sender. 
- `var2`: a byte string containing the associated data of the message.
- `var3`: The argument is an account address of receiver.
- `var4`: The argument is the error message if the request fails.
- `var5`: The argument is the result of the request after successful execution.

For more details, refer to the [[link](https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsendtransaction)]

#### INSTRUCTIONS FOR RUNNING THE PROVIDED PROGRAM

* This section requires you to know how to run a `geth` in a terminal which was covered in the Lab `Blockchain Storage and Mining on Campus` [[link](https://github.com/BlockchainLabSU/SUBlockchainLabs/blob/master/lab3.1/README.md)]. 

**Note: You can re-use all the data from your previous lab3. For example:**

```
$ mkdir -p sdfs_lab
$ cp -r lab3/bkc_data sdfs_ab
```

* In this lab, you need to enable RPC

```
> admin.startRPC()
```

* Assuming that you have connected to the Ethereum network, you can now open a new terminal and install the `web3` module
```
$ npm install web3@^0.20.0
```
* Copy the `SDFC_lab.js` file to your current working directory, and run the prgram

```
$ nodejs SDFC_lab.js
```

**Note: Make sure you have enough funds in your `eth.accounts[0]` and also make sure to unlock the account before running the program**


#### LAB EXERCISE 1: USER LOGIN/LOGOUT [GRADE 20%]

Implement the following two functions on the server, such that a client can call the functions remotely:

1. `int user_login(char* username, char* password)`: A new session between client username and the server starts by client username logging her account in with password. This establish a secure TLS communication channel.
2. `int user_logout(char* username)`: The session associated with username is terminated by client username logging her account out.

#### LAB EXERCISE 2: ACCESS CONTROL BY PERMISSION [GRADE 20%]

Implement the following two functions on the server, such that a client can call the functions remotely after the user login:

1. `char* file_access(char* username)`: Once logged in, a client of username can request to read the single file fileX stored in the server.
2. `int file_permission_set(char* username)`: In SDFS, fileX has a read permission bit for each user. For instance, if the permission bit for userA is set, userA is allowed to read the file. Function file_permission_set(char* username) sets the permission bit for username.

#### LAB EXERCISE 3: TRACING REMOTE REQUESTS [GRADE 10%]

Define an empty function, called `bkc_logging(event e)`. Insert the blogging calls to the server code such that the bkc_logging function is called whenever the execution enters any one of the four functions above (i.e., `user_login(), user_logout(), file_access(), file_permission_set()`).

#### LAB EXERCISE 4: BLOCKCHAIN LOGGING [GRADE 50%]

Implement the function of `bkc_logging(event e)`. In the implementation, the key is to translate the event description into some text that can be encoded in Ethereum transaction.

#### WHAT TO SUBMIT 

1. Source code along with README file and Makefile
2. A report describing your design in detail, implementation issues you encounter, and how you overcome them. 
