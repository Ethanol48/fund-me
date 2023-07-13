## Introduction

This repo contains contracts to develop a funding campaign, anyone can send funds to the contract if the funds sent surpass the value of 5 US$, everyone sending ether here will be registered via event logs and in a mapping called `s_funders`.

This contract gives the capacity only to the deployer to take the funds from the contract

This project uses a makefile to automate tasks

## Requiriments

For running this project you would need:

- [foundry](https://getfoundry.sh/) a framework for building and testing Smart Contracts

- [git](https://git-scm.com/) We would need it to install this repo

- A .env File to save the variables with these names:
  `PRIVATE_KEY` and `RPC_URL`

  - (Optional) A tool for loading the variables like [direnv](https://direnv.net/) to organize your environment variables

## Installing

To install this repo:

```bash
git clone https://github.com/Ethanol48/Foundry
```

<br></br>

And If you installed foundry correctly you will be able to run the following commands:

### Building

```
make build
```

### Testing

```
make test
```

<rb></br>

### Deploying

For deploying we have a script in script/HelperConfig.s.sol that helps us with the configurations, this project depends on a pricefeed, so I develop a 'mock' contract for local environment. Still, if we wanted to deploy to testnets we could add a real chainlink pricefeed, if we wanted to deploy per example, to mumbai, we will need to modify HelperConfig constructor to add the mumbai chainId and create a simple function that retuns the address of said pricefeed.

<br>

This architecture help us to only worry about the rpc-url endpoint and private key.

```
# load environment variables
sh .env


# available networks:  sepolia or local.

make deploy-<network>


# If the network that you want to deploy isn't listed

forge script script/DeployFundMe.s.sol --private-key $PRIVATE_KEY --rpc-url $RPC_URL
```
<br>
When using `forge script` if the parameter for `rpc-url` is not given, forge will automatically create a temporary instance of anvil.
