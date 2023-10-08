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
    TestToken token;

    function setUp() public {
        token = new TestToken();
        airdrop = new SociocatAirdrop(token, root);
        token.mint(address(airdrop), 3 ether);
    }

    /** ——— constructor() */

    function test_rejectsInvalidToken() public {
        vm.expectRevert(SociocatAirdrop_InvalidParams.selector);
        new SociocatAirdrop(IERC20(address(0)), root);
    }

    function test_rejectsInvalidRoot() public {
        vm.expectRevert(SociocatAirdrop_InvalidParams.selector);
        new SociocatAirdrop(token, 0x0);
    }

    /** ——— claim() */

    function test_rejectsInvalidProof() public {
        vm.expectRevert(SociocatAirdrop_InvalidProof.selector);
        airdrop.claim(1, new bytes32[](0));
    }

    function test_claims() public {
        address vitalik = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
        bytes32[] memory proof = new bytes32[](2);
        proof[
            0
        ] = 0xb7790ece4442bbc8f93fc4b7b6aa37bb39d2971048f98e64a3190c76c82e2381;
        proof[
            1
        ] = 0xebecbbb383635879d8415e0628c3d0b82dcee85319864be9aead45d0d120f5cb;

        assertEq(token.balanceOf(vitalik), 0); // Check initial balance

        vm.prank(vitalik);
        airdrop.claim(1 ether, proof);

        assertEq(token.balanceOf(vitalik), 1 ether); // Should receive the token
    }

    function test_rejectsDoubleClaim() public {
        address vitalik = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
        bytes32[] memory proof = new bytes32[](2);
        proof[
            0
        ] = 0xb7790ece4442bbc8f93fc4b7b6aa37bb39d2971048f98e64a3190c76c82e2381;
        proof[
            1
        ] = 0xebecbbb383635879d8415e0628c3d0b82dcee85319864be9aead45d0d120f5cb;

        // First claim
        vm.prank(vitalik);
        airdrop.claim(1 ether, proof);

        // Second claim
        vm.expectRevert(SociocatAirdrop_AlreadyClaimed.selector);
        vm.prank(vitalik);
        airdrop.claim(1 ether, proof);
    }
}

contract TestToken is ERC20 {
    constructor() ERC20("Test Token", "TEST") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
