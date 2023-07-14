-include .env

.PHONY: help build format test deploy-local deploy-mumbai deploy-mainnet deploy-sepolia 

build:; forge build

format:; forge fmt 


# Optional variables for deployment
privateKey ?= $(PRIVATE_KEY)
rpc_url ?= $(RPC_URL)
etherscanApiKey ?=
chainId ?=
contractAddress ?=

enforce-rpc_url:
ifndef rpc_url
	$(error rpc_url is not set)
endif

enforce-chainId:
ifndef chainId
	$(error chainId is not set)
endif

enforce-contractAddress:
ifndef contractAddress
	$(error contractAddress is not set)
endif

enforce-etherscanApiKey:
ifndef etherscanApiKey
	$(error to verify contracts you need to set ETHERSCAN_API_KEY in your environment)
endif

enforce-privateKey:
ifndef privateKey
	$(error PRIVATE_KEY is not set)
endif


test: 
	@echo "#############################"
	@echo "##### Running tests ... #####"
	@echo "#############################"
	@echo 

	@forge test

test-chain: enforce-rpc_url
	@echo "##################################"
	@echo "##### Running tests in chain #####"
	@echo "##################################"
	@echo 

	@forge test --fork-url $(rpc_url)


deploy-local: enforce-privateKey
	@echo "############################"
	@echo "## Deploying to Anvil ... ##"
	@echo "############################"
	@echo 

	@forge script script/DeployFundMe.s.sol:DeployFundMe --broadcast -vv


deploy-sepolia: enforce-rpc_url enforce-privateKey
	@echo "#############################"
	@echo "## Deploying to sepolia... ##"
	@echo "#############################"
	@echo 

	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(rpc_url) --private-key $(privateKey) --broadcast  -vv

deploy-chain: enforce-rpc_url enforce-privateKey

	@echo "#############################"
	@echo "## Deploying to custom ... ##"
	@echo "#############################"
	@echo 

	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(rpc_url) --private-key $(privateKey) --broadcast  -vv

verify-sepolia: enforce-etherscanApiKey enforce-contractAddress
	@echo "#############################"
	@echo "## Verifying on sepolia... ##"
	@echo "#############################"
	@echo 

	forge verify-contract $(contractAddress) "FundMe" -c 11155111


verify-chain: enforce-etherscanApiKey enforce-chainId enforce-contractAddress

	@echo "###################################"
	@echo "## Verifying on chainId: $(chainId) ##"
	@echo "###################################"
	@echo 

	forge verify-contract $(contractAddress) "FundMe" -c $(chainId) --etherscan-api-key $(ETHERSCAN_API_KEY)


