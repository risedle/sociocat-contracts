// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";

import {SocioCatToken} from "../src/SocioCatToken.sol";
import {SocioCatAirdrop} from "../src/SocioCatAirdrop.sol";

contract DeployTestAirdrop is Script {
  address treasury = 0x08B5C677f6BF699425Dd5594Dce28473F8EFF823;
  bytes32 root = 0xe4eaf9c0c461a2f5ec0074f2726ec473ecb327e59b32c0c60ca08a3f8f4a1544;
  // TODO SET REAL VALUE
  uint256 claimEndTime = 1_701_277_200; // 30 November 2023

  function run() public returns (SocioCatToken token, SocioCatAirdrop airdrop) {
    uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
    vm.startBroadcast(deployerPrivateKey);

    token = new SocioCatToken(treasury, "SocioCat", "CAT");
    airdrop = new SocioCatAirdrop(
      token,
      root,
      treasury,
      claimEndTime
    );
  }
}
