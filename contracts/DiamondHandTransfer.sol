// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

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

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./library/Base64.sol";

contract Template is ERC721, ReentrancyGuard, Ownable {
  constructor() ERC721("Template", "TEMPLATE") Ownable() {}

  uint256 _tokenSupply;
  uint256 _price = 0.1 ether;
  string _baseTokenURI;

  bool lockupPeriod = true;
  mapping(uint256 => bool) _diamondHand;

  function mintDiamonHand() external payable {
    require(msg.value >= _price, "Not enough ETH");

    // Record token as Diamond Hand
    _diamondHand[_tokenSupply] = true;

    // Mint Token
    _mint(msg.sender, _tokenSupply);
  }

  error DiamondHandLockup();

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal view override {
    if (lockupPeriod && _diamondHand[_tokenSupply]) {
      revert DiamondHandLockup();
    }
  }

  function revealAndUnlock(string memory baseTokenURI) external onlyOwner {
    lockupPeriod = false;
    _baseTokenURI = baseTokenURI;
  }
}
