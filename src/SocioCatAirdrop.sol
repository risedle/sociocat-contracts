// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SocioCatAirdrop is Ownable, ReentrancyGuard {
  using SafeERC20 for ERC20;

  ERC20 public immutable token;
  bytes32 public root;
  mapping(address => bool) public claimed;
  address public immutable treasury;
  uint256 public immutable claimEndTime;

  event Claimed(address indexed receiver, uint256 amount);
  event Recovered(address indexed receiver, uint256 amount);

  error InvalidProof();
  error AlreadyClaimed();
  error HasNotEnded();

  constructor(
    address owner,
    ERC20 _token,
    bytes32 _root,
    address _treasury,
    uint256 _claimEndTime
  ) Ownable(owner) {
    token = _token;
    root = _root;
    treasury = _treasury;
    claimEndTime = _claimEndTime;
  }

  function setRoot(bytes32 _root) external onlyOwner {
    root = _root;
  }

  function claim(uint256 amount, bytes32[] calldata proof) external nonReentrant {
    bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, amount))));
    if (!MerkleProof.verify(proof, root, leaf)) {
      revert InvalidProof();
    }
    if (claimed[msg.sender]) {
      revert AlreadyClaimed();
    }

    claimed[msg.sender] = true;
    token.safeTransfer(msg.sender, amount);
    emit Claimed(msg.sender, amount);
  }

  function recover() external {
    if (block.timestamp < claimEndTime) {
      revert HasNotEnded();
    }

    uint256 balance = token.balanceOf(address(this));
    token.safeTransfer(treasury, balance);
    emit Recovered(treasury, balance);
  }
}
