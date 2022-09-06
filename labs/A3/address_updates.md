genesis.json

```
{
"config": {
"chainId": 89992018,
"homesteadBlock": 0,
"eip150Block": 0,
"eip155Block": 0,
"eip158Block": 0
},
"alloc" : {},
"difficulty" : "0x200",
"gasLimit" : "0x2fefd8"
}
```

script 2.1: 4th line

```
geth --datadir bkc_data --networkid 89992018 --bootnodes enode://7320559847736145843099b94c6c67d52c3abd4af42200dde25557d58da3f36358b6a029ff37058461ee5e627aed6fb55386c3e334b54fa35480aee4ea73eb61@128.230.208.73:30301 console 2>console.log 
```

script 2.2

```
admin.addPeer("enode://7320559847736145843099b94c6c67d52c3abd4af42200dde25557d58da3f36358b6a029ff37058461ee5e627aed6fb55386c3e334b54fa35480aee4ea73eb61@128.230.208.73:30303")
```


