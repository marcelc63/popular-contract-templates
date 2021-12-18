// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Solidity Contract Template based on
 * Source: https://etherscan.io/address/
 *
 * Add Introduction Here
 *
 * Add Summary Here
 *
 * Curated by @marcelc63 - marcelchristianis.com
 * Each functions have been annotated based on my own research.
 *
 * Feel free to use and modify as you see appropriate
 */

import "./ChildContract.sol";

contract ParentContract {
  uint256 price = 0.2 ether;

  ChildContract public childContract;

  function execute(uint256 totalMint) external payable {
    require(msg.value >= totalMint * price);
    for (uint256 i = 0; i < totalMint; i++) {
      childContract = new ChildContract();
      childContract.mintAdidasOriginals{ value: 0.4 ether }();
    }
  }
}
