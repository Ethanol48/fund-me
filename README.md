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

## Installing

To install this repo:

```bash
git clone https://github.com/Ethanol48/Foundry
```

<br></br>

### _Disclaimer_

---

_For all the following commands asumes that the variables `PRIVATE_KEY` and `RPC_URL` were set, if not you will need to set them in every command when needed, per example:_

```
make test-chain PRIVATE_KEY=value RPC_URL=value
```

_or if the `PRIVATE_KEY` is set:_

```
make test-chain RPC_URL=value
```

---

<br></br>

### Load enviroment variables

```
# load environment variables
# with PRIVATE_KEY inside
sh .env
```

And If you installed foundry correctly you will be able to run the following commands:

### Building

```
make build
```

### Testing

```
make test
```

For simulating in different chains:

```
make test-chain
```

<rb></br>

### Deploying

For deploying we have a script in script/HelperConfig.s.sol that helps us with the configurations, this project depends on a pricefeed, so I develop a 'mock' contract for local environment.

Still, if we wanted to deploy to testnets we could add a real chainlink pricefeed, if we wanted to deploy per example, to mumbai, we will need to modify HelperConfig constructor to add the mumbai chainId and create a simple function that retuns the address of said pricefeed.

<br>

```
# available networks:  sepolia or local.

make deploy-<network>


# If the network that you want to deploy isn't listed

make deploy-chain rpc-url=<rpc-endpoint>

(or if you have already set the RPC_URL variable)

make deploy-chain
```

<br>
