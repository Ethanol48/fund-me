## Requiriments

For running this project you would need:

- [foundry](https://getfoundry.sh/) a framework to building and testing smart contracts

- [git](https://git-scm.com/) we would need it to install this repo

## Installing

To install this repo:

```bash

git clone https://github.com/Ethanol48/Foundry

```

#### 'cd' to directory:

```bash
cd fund-me
```

<br></br>

And If you installed foundry properly you will be able to run the following commands:

### Building

```

forge build

```

### Testing

```

forge test

```

<rb></br>

### Deploying

For deploying is a bit different, in this project we have a script in script/HelperConfig.s.sol that helps us with the configurations, this project is dependent on a pricefeed, I develop a 'mock' contract for local envirioment, but if we wanted to deploy to testnets we could add a real chainlink pricefeed, if we wnated to deply per example, mumbai, we will need to modify HelperConfig constructor to add the mumbai chainId and create a simple function.

This achitecture help us to only worry about the rpc-url endpoint and private key.

```
forge script --private-key <your-private-key> --rpc-url <rpc-endpoint>
```

if the parameter for `rpc-url` is not given, forge will automaticly cretae a temporary instance of anvil.
