// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MerkleProof} from
  "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {ReentrancyGuard} from
  "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error SociocatAirdrop_InvalidProof();
error SociocatAirdrop_AlreadyClaimed();
error SociocatAirdrop_InvalidParams();

contract SociocatAirdrop is ReentrancyGuard {
  IERC20 public token;
  bytes32 public root;
  mapping(address => bool) public claimed;

  event Claimed(address indexed receiver, uint256 amount);

  constructor(IERC20 _token, bytes32 _root) {
    if (address(_token) == address(0) || _root == 0) {
      revert SociocatAirdrop_InvalidParams();
    }

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
      revert SociocatAirdrop_InvalidProof();
    }
    if (claimed[msg.sender]) {
      revert SociocatAirdrop_AlreadyClaimed();
    }

    claimed[msg.sender] = true;
    token.transfer(msg.sender, amount);
    emit Claimed(msg.sender, amount);
  }
}
