// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "src/FundMe.sol";

contract IntegrationTest is Test {
    FundMe public fundMe;

    uint256 public constant SEND_VALUE = 1 ether; // just a value to make sure we are sending enough!
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;

    string public constant USER_NAME = "user";
    address public USER = makeAddr(USER_NAME);

    // uint256 public constant SEND_VALUE = 1e18;
    // uint256 public constant SEND_VALUE = 1_000_000_000_000_000_000;
    // uint256 public constant SEND_VALUE = 1000000000000000000;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testUserCanFundInteractions() public {
        console.log("antes de fund");

        FundFundMe fundFundMe = new FundFundMe(address(fundMe));

        vm.deal(USER, STARTING_USER_BALANCE);
        vm.prank(USER);
        fundFundMe.fundFundMeWithoutBroadcast{value: SEND_VALUE}();

        console.log("antes de withdraw");

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe(address(fundMe));
        withdrawFundMe.withdrawFundMe();

        assert(address(fundMe).balance == 0);
    }

    // function testUserCanFundAndGetsAddedToFundersArray() public {
    //     FundFundMe fundFundMe = new FundFundMe(address(fundMe));

    //     vm.prank(USER);
    //     fundFundMe.fundFundMeWithoutBroadcast{value: SEND_VALUE}();
    // }
}
