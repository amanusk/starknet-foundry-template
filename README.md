# Starknet-Foundry template

# Starknet-Foundry template ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/amanusk/starknet-foundry-template/blob/main/LICENSE) ![example workflow](https://github.com/amanusk/starknet-foundry-template/actions/workflows/scarb.yml/badge.svg)

Simple template of a Cairo contract built using Starknet-Foundry
The example shows a simple multi-send contract, receiving an ERC20 address, and a list of recipients, and sends tokens to recipients according to the list

This repo requires `Scarb 2.6.4`
This repo requires `sn-foundery 0.23.0`

Install Scarb with:

```
asdf plugin add scarb
asdf install scarb latest
```

(See more instructions for [asdf-scarb](https://github.com/software-mansion/asdf-scarb) installation

Install Starknet-Foundry with:

```
asdf plugin add starknet-foundry
asdf install starknet-foundry latest

```

(More instructions for [snforge](https://github.com/foundry-rs/starknet-foundry))

### Disclaimer

This is just an example, more features will be added as the language is improved while keeping it minimal

## Building

```
scarb build
```

## Testing

```
snforge test
```

## Deployment

Deployment is handled by `sncast`. See `scripts.md` for examples

### Thanks

If you like it then you shoulda put a ⭐ on it
