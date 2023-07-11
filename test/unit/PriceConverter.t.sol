pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract testPriceConverter is Test {
    using PriceConverter for uint256;

    function setUp() external {}
}
