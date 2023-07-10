// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    address public ethUsdPriceFeed;

    function run() external returns (FundMe) {
        // Not "real" tx
        HelperConfig helperConfig = new HelperConfig();
        ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        // After startbroadcast, tx are REAL!!
        vm.startBroadcast();
        // Mock
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();

        return fundMe;
    }
}
