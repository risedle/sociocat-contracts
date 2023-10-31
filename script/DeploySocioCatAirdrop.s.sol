// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";

import {SocioCatToken} from "../src/SocioCatToken.sol";
import {SocioCatAirdrop} from "../src/SocioCatAirdrop.sol";

contract DeploySocioCatAirdrop is Script {
  address owner = 0x8b5f13F55f9dF6F3539f0683Df0BCD6C19D4e640;
  address treasury = 0x08B5C677f6BF699425Dd5594Dce28473F8EFF823;
  bytes32 root = 0xe4eaf9c0c461a2f5ec0074f2726ec473ecb327e59b32c0c60ca08a3f8f4a1544;
  uint256 claimEndTime = 1_701_388_800; // 01 December 2023 00:00
  SocioCatToken token = SocioCatToken(0x063D2DB6D348Fa5957b78B6141d144426486c68C);

  function run() public returns (SocioCatAirdrop airdrop) {
    uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
    vm.startBroadcast(deployerPrivateKey);
    airdrop = new SocioCatAirdrop(
      owner,
      token,
      root,
      treasury,
      claimEndTime
    );
  }
}
