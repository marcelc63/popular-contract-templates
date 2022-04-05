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
  mapping(address => uint256) _diamondHand;

  function reserveDiamondHand() external payable {
    require(msg.value >= _price, "Not enough ETH");

    // Increment reserved token, no token minted
    _diamondHand[msg.sender]++;
  }

  function revealAndUnlock(string memory baseTokenURI) external onlyOwner {
    lockupPeriod = false;
    _baseTokenURI = baseTokenURI;
  }

  function claimDiamondHand() external {
    require(_diamondHand[msg.sender] > 0, "No NFTs reserved");

    // Mint reserved tokens
    for (uint256 i; i < _diamondHand[msg.sender]; i++) {
      _tokenSupply++;
      _mint(msg.sender, _tokenSupply);
    }
  }
}
