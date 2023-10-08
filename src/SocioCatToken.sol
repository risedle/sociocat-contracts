// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IUniswapV2Router02} from "./interfaces/IUniswapV2Router02.sol";
import {IuniswapV2Factory} from "./interfaces/IuniswapV2Factory.sol";

contract SocioCatToken is ERC20 {
  /// @notice Treasury wallet
  address public treasury;

  /// @notice Uniswap V2 Router02
  /// https://basescan.org/address/0x6bded42c6da8fbf0d2ba55b2fa120c5e0c8d7891
  IUniswapV2Router02 public router = 0x6BDED42c6DA8FBf0d2bA55B2fa120C5e0c8D7891;

  /// @notice Uniswap V2 CAT/WETH pair address
  address public pair;

  /// @notice SocioCatToken constructor
  constructor(address _treasury) ERC20("SocioCat", "CAT") {
    // Set treasury wallet
    treasury = _treasury;

    // Get pair address
    IUniswapV2Factory factory = IUniswapV2Factory(router.factory());
    pair = factory.createPair(address(this), factory.WETH());

    // Mint to treasury wallet
    _mint(treasury, 1_000_000_000 ether);
  }

  /**
   * @dev Add buy and sell tax
   */
  function _update(address from, address to, uint256 value) internal virtual {
    // Tax on buy; if from is pair and to is not treasury
    if (from == pair && to != treasury) {
      // tax on buy
    }

    // Tax on sell

    // Add
    super._update(from, to, value);
  }
}
