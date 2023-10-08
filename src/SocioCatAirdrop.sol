// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {SafeERC20} from
  "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from
  "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {ReentrancyGuard} from
  "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SocioCatAirdrop is ReentrancyGuard {
  SafeERC20 public token;
  bytes32 public root;
  mapping(address => bool) public claimed;

  event Claimed(address indexed receiver, uint256 amount);

  error InvalidProof();
  error AlreadyClaimed();
  error InvalidParams();

  constructor(SafeERC20 _token, bytes32 _root) {
    token = _token;
    root = _root;
  }

  function claim(uint256 amount, bytes32[] calldata proof)
    external
    nonReentrant
  {
    bytes32 leaf =
      keccak256(bytes.concat(keccak256(abi.encode(msg.sender, amount))));
    if (!MerkleProof.verify(proof, root, leaf)) {
      revert InvalidProof();
    }
    if (claimed[msg.sender]) {
      revert AlreadyClaimed();
    }

    claimed[msg.sender] = true;
    token.transfer(msg.sender, amount);
    emit Claimed(msg.sender, amount);
  }
}
