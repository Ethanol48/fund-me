-include .env

.PHONY: help build format test deploy-local deploy-mumbai deploy-mainnet deploy-sepolia

build:; forge build

format:; forge fmt 

test: 
	@echo "#############################"
	@echo "##### Running tests ... #####"
	@echo "#############################"

	forge test


deploy-local:
	@echo "############################"
	@echo "## Deploying to Mumbai... ##"
	@echo "############################"

	forge script script/DeployFundMe.s.sol:DeployFundMe --broadcast -vv


deploy-sepolia:
	@echo "#############################"
	@echo "## Deploying to sepolia... ##"
	@echo "#############################"

	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify $(ETHERSCAN_API_KEY) -vv
