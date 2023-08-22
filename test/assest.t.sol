// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import "forge-std/Test.sol";
import "../src/trade.sol";
import "../src/property.sol";

contract AssetTest is Test{
    uint256 celoMmainnetFork;
    Assets public property;
    tradeAsset public tradeContract;



    address Bob = vm.addr(0x1);
    address Alice = vm.addr(0x2);
    address Idogwu = vm.addr(0x3);
    address Faith = vm.addr(0x4);
    address Femi = vm.addr(0x5);
    address Nonso = vm.addr(0x6);

    function setUp() public {
        //celoMmainnetFork = vm.createFork();
        property = new Assets();
        property.mint(Bob, 1, 20);
        property.balanceOf(Bob, 1);
        tradeContract = new tradeAsset();
    }


    function testlistProperty() public {
        setUp();
        vm.startPrank(Bob);        
        property.setApprovalForAll(address(tradeContract), true);
        
        tradeContract.listProperty(901, "The Genesis", "A house", "The moon", 20, address(property), 1);

    }

    function testBuy() public {


    }

}
