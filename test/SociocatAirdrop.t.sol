// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "../src/SociocatAirdrop.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/Test.sol";

// Test tree
//
// Generated from @openzeppelin/merkle-tree
// ```
// const values = [
//   ["0xf38AA28118cAfe28799daC04C3d9B80C0fBD8343", parseEther("1")],
//   ["0xf01DAF98111E7dcA39AB93e0085f7E26f382D3Ff", parseEther("1")],
//   ["0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045", parseEther("1")],
// ];
// const tree = StandardMerkleTree.of(values, ["address", "uint256"]);
// ```
bytes32 constant root = 0xdd9d071d0ae3c1e1e55dd4865b8a6d3f72f08af272fe0831fa6ead525d6ad710;

contract SociocatAirdropTest is Test {
    SociocatAirdrop airdrop;
    ERC20 token;

    function setUp() public {
        token = new TestToken();
        airdrop = new SociocatAirdrop(token, root);
    }

    function test_rejectsInvalidToken() public {
        vm.expectRevert(SociocatAirdrop_InvalidParams.selector);
        new SociocatAirdrop(IERC20(address(0)), root);
    }

    function test_rejectsInvalidRoot() public {
        vm.expectRevert(SociocatAirdrop_InvalidParams.selector);
        new SociocatAirdrop(token, 0x0);
    }
}

contract TestToken is ERC20 {
    constructor() ERC20("Test Token", "TEST") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
