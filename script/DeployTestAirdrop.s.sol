// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import {SocioCatToken} from "../src/SocioCatToken.sol";
import {SocioCatAirdrop} from "../src/SocioCatAirdrop.sol";

contract DeployTestAirdrop is Script {
  address owner = 0x8b5f13F55f9dF6F3539f0683Df0BCD6C19D4e640;
  address treasury = 0x8b5f13F55f9dF6F3539f0683Df0BCD6C19D4e640;
  // TODO SET REAL VALUE
  uint256 claimEndTime = 1_701_277_200; // 30 November 2023

  function run() public returns (SocioCatToken token, SocioCatAirdrop airdrop) {
    uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
    vm.startBroadcast(deployerPrivateKey);

    token = new SocioCatToken(treasury, "Test Airdrop", "TEST");
    airdrop = new SocioCatAirdrop(
      token,
      0xdd9d071d0ae3c1e1e55dd4865b8a6d3f72f08af272fe0831fa6ead525d6ad710,
      treasury,
      claimEndTime
    );
  }
}
