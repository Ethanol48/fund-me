// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on local chain (anvil), we deploy Mock contract
    // Otherwise, grab the existing address from the live network
    NetworkConfig public activeNetworkConfig;

    uint8 public immutable DECIMALS = 8;
    int256 public immutable INITIAL_ANSWER = 2000e8;

    struct NetworkConfig {
        address priceFeed; // ETH/USD
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory config = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});

        return config;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // price feed address
        // NetworkConfig memory config = NetworkConfig(address(0), 1);

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator({
            _decimals: DECIMALS,
            _initialAnswer: INITIAL_ANSWER
        });
        vm.stopBroadcast();

        NetworkConfig memory config = NetworkConfig({priceFeed: address(mockV3Aggregator)});

        return config;
    }
}
