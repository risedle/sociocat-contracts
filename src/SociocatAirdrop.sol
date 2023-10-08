// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

error SociocatAirdrop_InvalidProof();

contract SociocatAirdrop {
    IERC20 public token;
    bytes32 public root;

    event Claimed(address indexed receiver, uint256 amount);

    constructor(IERC20 _token, bytes32 _root) {
        token = _token;
        root = _root;
    }

    function claim(uint256 amount, bytes32[] calldata proof) external {
        bytes32 leaf = keccak256(
            bytes.concat(keccak256(abi.encode(msg.sender, amount)))
        );
        if (!MerkleProof.verify(proof, root, leaf)) {
            revert SociocatAirdrop_InvalidProof();
        }
        token.transfer(msg.sender, amount);
        emit Claimed(msg.sender, amount);
    }
}
