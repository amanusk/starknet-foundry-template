# Run script with sncast

```
sncast --profile devnet-rs script token_sender_script
```

# Manually with sncast

## Declare

```
sncast --account __default__ --network testnet --url http://192.168.1.45:5235 declare --contract-name TokenSender
```

## Deploy

```
sncast --account __default__ --url http://192.168.1.45:5235 deploy --class-hash 0x142b07913180858f2739557eea3f5274969fb46813f3088ceed86ce640416a0 --constructor-calldata "1 1 1 1 1 0x0563b71ac29b54Ef78bbFDb3FBf0338441d3948C573621E7824f9dBc1Ce23d56"
```
