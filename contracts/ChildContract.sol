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

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

abstract contract AdidasOriginalsInterface {
  function purchase(uint256 amount) external payable virtual;

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external virtual;
}

contract ChildContract {
  address transferAddress = 0xFABB0ac9d68B0B445fB7357272Ff202C5651694a; // Pretend this is the transfer address
  address adidasOriginals = 0x28472a58A490c5e09A238847F66A68a47cC76f0f;
  uint8 counter;

  // TODO: Update Constructor

  function mintAdidasOriginals() external payable {
    AdidasOriginalsInterface(adidasOriginals).purchase{ value: msg.value }(2);
  }

  function onERC1155Received(
    address operator,
    address from,
    uint256 id,
    uint256 value,
    bytes calldata data
  ) external returns (bytes4) {
    AdidasOriginalsInterface(adidasOriginals).safeTransferFrom(
      address(this),
      transferAddress,
      id
    );

    counter += 1;
    if (counter == 2) {
      address payable addr = payable(address(transferAddress));
      selfdestruct(addr);
    }

    return
      bytes4(
        keccak256(
          "onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"
        )
      );
  }
}
