// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe s_fundMe;
    DeployFundMe s_deployFundMe;
    uint256 immutable SEND_VALUE = 1 ether;
    uint256 immutable STARTING_BALANCE = 10 ether;

    address[] USERS;

    string[] users = [
        "ethan",
        "aidan",
        "steven",
        "spielberg",
        "darth",
        "vader"
    ];

    // modifiers
    modifier fundFirstAccount() {
        FundMe fundMe = s_fundMe;

        vm.prank(USERS[0]);
        fundMe.fund{value: SEND_VALUE}(); // funds
        _;
    }

    modifier fundMultipleUsers() {
        FundMe fundMe = s_fundMe;

        for (uint8 i = 0; i < USERS.length; i++) {
            // user calls fund in contract
            vm.prank(USERS[i]);
            fundMe.fund{value: SEND_VALUE}(); // funds
        }
        _;
    }

    // setup before each test
    function setUp() external {
        s_deployFundMe = new DeployFundMe();
        s_fundMe = s_deployFundMe.run();

        address[] memory emptyArray;

        USERS = emptyArray;

        for (uint8 i = 0; i < users.length; i++) {
            USERS.push(makeAddr(users[i]));
            vm.deal(USERS[i], STARTING_BALANCE);
        }
    }

    // tests
    function testOwnerIsDeployFundMe() external {
        FundMe fundMe = s_fundMe;

        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testMinimumDollarsIsFive() external {
        FundMe fundMe = s_fundMe;

        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testPriceFeedVersion() external {
        FundMe fundMe = s_fundMe;

        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundCeroEth() external {
        FundMe fundMe = s_fundMe;

        vm.expectRevert();
        fundMe.fund(); // funds 0 ETH
    }

    function testFundOneEth() external {
        FundMe fundMe = s_fundMe;

        fundMe.fund{value: SEND_VALUE}(); // funds
    }

    function testReceiveFail() external {
        FundMe fundMe = s_fundMe;

        vm.expectRevert();
        (bool sent, ) = address(fundMe).call{value: 1}(""); // funds
        require(sent, "Failed to send Ether");
    }

    function testReceivePass() external {
        FundMe fundMe = s_fundMe;

        vm.prank(USERS[0]);
        (bool sent, ) = address(fundMe).call{value: SEND_VALUE}(""); // funds
        require(sent, "Failed to send Ether");

        assertEq(fundMe.getAddressToAmountFunded(USERS[0]), SEND_VALUE);
    }

    function testCorrectPriceFeedAddress() external {
        address priceFeedAddress = address(s_fundMe.getPriceFeed());
        console.log("priceFeedAddress: ", priceFeedAddress);

        address priceFeedAddressConfig = s_deployFundMe.ethUsdPriceFeed();
        console.log("priceFeedAddressConfig: ", priceFeedAddressConfig);

        assertEq(priceFeedAddress, priceFeedAddressConfig);
    }

    function testFallbackFail() external {
        vm.expectRevert();
        (bool sent, ) = address(s_fundMe).call{value: 0}(
            abi.encodeWithSignature("nonexisting", "no leas")
        ); // funds
        require(sent, "Failed to send Ether");
    }

    function testDepositChange() external fundFirstAccount {
        console.log("balance of the contract", address(this).balance);
        console.log("balance of the user", address(USERS[0]).balance);

        assertEq(s_fundMe.getAddressToAmountFunded(USERS[0]), SEND_VALUE);
    }

    function testWithdrawNotOwner() external {
        FundMe fundMe = s_fundMe;

        vm.expectRevert();
        vm.prank(USERS[0]);
        fundMe.withdraw(); // funds
    }

    function testWithdrawOwner() external fundFirstAccount {
        FundMe fundMe = s_fundMe;

        uint256 balanceOwnerBefore = address(msg.sender).balance;

        // changing the msg.sender
        vm.prank(msg.sender);
        fundMe.withdraw(); // funds

        uint256 balanceOwnerAfter = address(msg.sender).balance;

        assertApproxEqAbsDecimal(
            balanceOwnerAfter,
            (balanceOwnerBefore + SEND_VALUE),
            30000,
            18
        );
    }

    function testGetFunder() external fundMultipleUsers {
        FundMe fundMe = s_fundMe;

        for (uint8 i = 0; i < USERS.length; i++) {
            assertEq(fundMe.getFunder(i), address(USERS[i]));
        }
    }

    function testWithdrawOwnerWithMultipleFunds() external fundMultipleUsers {
        FundMe fundMe = s_fundMe;

        uint256 balanceOwnerBefore = address(msg.sender).balance;

        // changing the msg.sender to owner
        vm.prank(msg.sender);

        fundMe.withdraw(); // funds

        uint256 balanceOwnerAfter = address(msg.sender).balance;

        assertApproxEqAbsDecimal(
            balanceOwnerAfter,
            (balanceOwnerBefore + (SEND_VALUE * USERS.length)),
            30000,
            18
        );
    }
}
