# morpho-utils

Repository gathering useful libraries and contracts.

## Setup

After cloning this repository, run:

```bash
git submodule update --init --recursive
```

## Testing

For testing, run:

```bash
forge test
```

## Formal verification

To run the Certora formal verification tool, run (with a CERTORAKEY in your environment):

```bash
./certora/scripts/verifyAll.sh
```

## External contributors

We thank the MEP team for their help on code optimization:

- [@AtomicAzzaz](https://github.com/AtomicAzzaz)
- [@ewile](https://github.com/wile)
- [@makcandrov](https://github.com/makcandrov)

## Acknowledgements

This repository is inspired by several sources:

- [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Compound](https://github.com/compound-finance/compound-protocol)
- [Aave V2](https://github.com/aave/protocol-v2)
- [Aave V3](https://github.com/aave/aave-v3-core)
