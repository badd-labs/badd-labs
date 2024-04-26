Lab B6: Zero-Knowledge Proofs and their Blockchain Applications 
===

Zero-knowledge proofs (zk-proofs) play a crucial role in enabling novel and practical application of blockchains. In zk-proof, one party (the prover) proves to another party (the verifier) that a certain statement is true without revealing any information about the statement itself except for its validity. For instance, such a statement can be “Prover Alice knows a secret key SK that maps to a public key PK“. zkproof would convince the verifier that the prover Alice knows SK yet without disclosing SK itself to the verifier.

In blockchain, zkproof can run between an offchain prover holding a certain secret and an on-chain verifier (e.g., running inside a smart contract). The verified statement can be used to safeguard a variety of blockchain applications, such as user authentication, preserving user privacy, etc.

In this lab, we will program a series of privacy-sensitive statements and run zkproof provided by zokrates .

Exercise 1: Run helloworld zk program
---

Install [[ZoKrates](https://zokrates.github.io/gettingstarted.html)] from source:

```bash
git clone https://github.com/ZoKrates/ZoKrates
cd ZoKrates
export ZOKRATES_STDLIB=$PWD/zokrates_stdlib/stdlib
cargo build -p zokrates_cli --release
cd target/release
```

Alternatively, if you are on MacOS or Linux:

```bash
curl -LSfs get.zokrat.es | sh
```

Create a file `root.zok` by copying the following content:

```
def main(private field a, field b) {
    assert(a * a == b);
    return;
}
```

Run the following commands in a terminal. Here, we consider three parties, Alice the prover, Bob the verifier on blockchain, Charlie the trusted party to set up the platform.

```bash
# Charlie performs the following:
# 1. compile
zokrates compile -i root.zok
# 2. perform the setup phase
zokrates setup
# 3. export a solidity verifier 
zokrates export-verifier
# 4. deploy verifier.sol to blockchain

# Alice
# 5. execute the program where 337 is a and 113569 is b
zokrates compute-witness -a 337 113569
# 6. generate a proof of computation
zokrates generate-proof

# Bob
# 7. get proof.json from Alice, and embed proof.json in tx to be sent to blockchain.
```

After executing `zokrates export-verifier`, you will find a `verifier.sol` generated, deploy it to Remix IDE.

Inspect the `verifier.sol` file and send a transaction to verify the zokrates-generated proof in Remix.

- Hints 1: add ZoKrates to PATH as suggested 
    ```bash
    >>> export PATH=$PATH:/YOUR DIR/.zokrates/bin
    ```
- Hint 2: You can find `a`, `b`, `c`, and input values required for `verifier.verifyTx()` in generated `proof.json` file, which follows the format below:
    ```python
    proof: [[a[0],a[1]], [[b[0][0],b[0][1]],[b[1][0],b[1][1]]], [c[0],c[1]]]
    ```

Exercise 2. Prove Your Age 
---

Imagine an online liquor store selling wine and requiring proof of age from customers. Consider David, the liquor store, Alice, a customer, and Bob the blockchain. Alice generates zero-knowledge proof of her age verifiable on-chain. David observes the verification result from Bob on-chain and can proceed to sell the wine in Alice's cart.

Implement the proof of age program and run the above procedure.


<!--


In this exercise, we simulate a scenario where you are a prover who tries to prove that your age is bigger than a given number(21, in this case). You will submit your proof to a smart contract deployed by a verifier, while your age is not included in the proof. 

You should use a common .zok [file](https://github.com/ZhouYuxuan97/zk-demo/blob/main/comp.zok) to compile, and use a given setup ([proving.key](https://github.com/ZhouYuxuan97/zk-demo/blob/main/proving.key)) to replace the command of `zokrates setup`. 

Using the given [verifier.sol](https://github.com/ZhouYuxuan97/zk-demo/blob/main/verifier.sol) smart contract to Remix IDE and put your proof arguments to `verifyTx` function. 


Steps to finish the Exercise for your reference:
- Compile the .zok program:
```bash
>>> zokrates compile -i comp.zok
```
- Perform the setup phase using the given `proving.key` file
- Execute the program with specified arguments, the format of arguments can be referred to the definition in `comp.zok`
- Generate a proof of computation:
```bash
>>> zokrates generate-proof
```
- Note: Stop at this step and proceed with the provided Solidity file for further instructions.

Hint:
1. You could use this command to download the files to avoid font/format issues, replace the link to adjust other files  
    ```bash
    >>> wget -O proving.key https://github.com/ZhouYuxuan97/zk-demo/blob/main/proving.key?raw=true
    ```
-->

Exercise 3. Prove Your Knowledge of Hash Preimage 
---

A more common way of using zk-proof is to prove the knowledge of a hash preimage. That is, given hash $y=H(x)$, Alice tries to prove to Bob that she knows the preimage $x$ under the hash digest $y$, without revealing $x$ to Bob.

Complete the following template program to implement the zk-proof of knowledge of hash preimage.

```
import "hashes/sha256/512bitPacked" as sha256packed;

def main(private field a, private field b, private field c, private field d) -> field[2] {
    field[2] h = sha256packed([a, b, c, d]);
//implement your code below

    return h;
}
```

The first line imports the `sha256packed` function from the `ZoKrates` standard library.

<!--

Exercise 3. Prove Your Knowledge of Hash Preimage 
---

In this exercise, we simulate a scenario where Alice tries to prove she knows a hash preimage for a digest chosen by Bob. Similarly, the preimage wouldn’t be revealed when Bob verifies the proof.

To start with, you can create a new file named `generate-hash.zok` to learn about how to generate hash in `.zok`:
```
import "hashes/sha256/512bitPacked" as sha256packed;

def main(private field a, private field b, private field c, private field d) -> field[2] {
    field[2] h = sha256packed([a, b, c, d]);
    return h;
}
```

The first line imports the `sha256packed` function from the ZoKrates standard library.

`sha256packed` is a SHA256 implementation that is optimized for the use in the ZoKrates DSL. Here is how it works: We want to pass 512 bits of input to SHA256. However, a `field` value can only hold 254 bits due to the size of the underlying prime field we are using. As a consequence, we use four field elements, each one encoding 128 bits, to represent our input. The four elements are then concatenated in ZoKrates and passed to SHA256. Given that the resulting hash is 256 bit long, we split it in two and return each value as a 128 bit number.

Then compile generate-hash.zok and create a witness file, record the output.

Now, based on the code snippet in `generate-hash.zok` and witness output, Bob needs to design a `prove-preimage.zok`, compile it, make a setup and export `verifier.sol`, and deploy `verifier.sol` to Remix IDE. Alice is going to compile the `prove-preimage.zok` as well, enter her preimage to generate witness, using Bob's `proving.key` to construct the proof, then put the arguments in proof to `verifier.verifyTx()` to show her knowledge of that hash preimage to Bob.
 
Help Bob to design `prove-preimage.zok` and follow these steps to finish the demo.
 
 Hints:
1. You could use this command to generate witness of `generate-hash`
    ```bash
    >>> zokrates compute-witness -a 0 1 2 4 --verbose
    ```
 
Deliverable
---

1. You should create separate folders for all exercises. 
2. Submission should be a pdf file.
3. For all exercises, you should submit the screenshots of what files remain in your folder; the screenshots of the terminal showing what commands are executed and their outputs; the screenshots of your contract executing inputs and results in Remix IDE.
4. For all exercises, copy your code in `.zok` files and proofs in `proof.json` to the pdf submission.
5. For Exercise 3, create two folders called `Alice` and `Bob` individually, follow the instructions and understand the scenario(difference in roles' duties), and submit the screenshots of what files remain in `Alice` and `Bob` folders.

-->


