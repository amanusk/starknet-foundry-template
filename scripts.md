# Declare

sncast --account **default** --network testnet --url http://192.168.1.45:5235 declare --contract-name TokenSender

## Deploy

sncast --account **default** --url http://192.168.1.45:5235 deploy --class-hash 0x142b07913180858f2739557eea3f5274969fb46813f3088ceed86ce640416a0 --constructor-calldata "1 1 1 1 1 0x0563b71ac29b54Ef78bbFDb3FBf0338441d3948C573621E7824f9dBc1Ce23d56"
