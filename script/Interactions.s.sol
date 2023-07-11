// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "src/FundMe.sol";

contract FundFundMe is Script {
    uint constant SEND_VALUE = 1 ether;
    address fundMeAddress;

    /// @notice funds FundMe contract passed in constructor
    /// @dev funds SEND_VALUE (1 ether) to FundMe
    function fundFundMe() public {
        vm.startBroadcast();
        FundMe(payable(fundMeAddress)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe with ", SEND_VALUE);

        vm.stopBroadcast();
    }

    function fundFundMeWithoutBroadcast() public payable {
        FundMe(payable(fundMeAddress)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe with ", SEND_VALUE);
    }

    constructor(address _fundMeAddress) {
        fundMeAddress = _fundMeAddress;
    }

    function run() external {
        vm.startBroadcast();
        fundFundMe();
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    address fundMeAddress;

    function withdrawFundMe() public {
        vm.startBroadcast();
        FundMe(payable(fundMeAddress)).withdraw();
        vm.stopBroadcast();
    }

    constructor(address _fundMeAddress) {
        fundMeAddress = _fundMeAddress;
    }

    function run() external {
        vm.startBroadcast();
        withdrawFundMe();
        vm.stopBroadcast();
    }
}
