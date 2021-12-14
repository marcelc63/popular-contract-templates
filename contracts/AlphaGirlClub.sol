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

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./ERC721B.sol";

// File contracts/agc.sol

pragma solidity ^0.8.9;

/*
       .-""""-.        .-""""-.
      /        \      /        \
     /_        _\    /_        _\
    // \      / \\  // \      / \\
    |\__\    /__/|  |\__\    /__/|
     \    ||    /    \    ||    /
      \        /      \        /
       \  __  /        \  __  / 
        '.__.'          '.__.'
         |  |            |  |
         |  |            |  |
                                       
      Alpha Girl Club - @InvaderETH
*/

contract AlphaGirlClub is Ownable, ERC721B {
  using Strings for uint256;
  using ECDSA for bytes32;

  uint256 public constant AGC_PUBLIC = 9500;
  uint256 public constant AGC_MAX = 10000;
  uint256 public constant AGC_GIFT = 500;
  uint256 public constant AGC_PRICE = 0.08 ether;
  uint256 public constant AGC_PER_MINT = 4;
  uint256 public giftedAmount;

  string public provenance;
  string private _contractURI;
  string private _tokenBaseURI;
  address private _signerAddress = 0x079f1BaC0025ad71Ab16253271ceCA92b222C614;
  address private _vaultAddress = 0x6614748B04507b4D4C7182E07e759292C2758e2A;

  bool public presaleLive;
  bool public saleLive;

  mapping(address => uint256) public presalerListPurchases;

  constructor() ERC721B("Alpha Girl Club", "AGC") {}

  // ** - CORE - ** //

  function buy(
    bytes32 hash,
    bytes memory signature,
    uint256 tokenQuantity
  ) external payable {
    require(saleLive, "SALE_CLOSED");
    require(!presaleLive, "ONLY_PRESALE");
    require(matchAddressSigner(hash, signature), "DIRECT_MINT_DISALLOWED");
    require(tokenQuantity <= AGC_PER_MINT, "EXCEED_AGC_PER_MINT");
    require(AGC_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");

    uint256 supply = _owners.length;
    require(supply + tokenQuantity <= AGC_PUBLIC, "EXCEED_MAX_SALE_SUPPLY");
    for (uint256 i = 0; i < tokenQuantity; i++) {
      _mint(msg.sender, supply++);
    }
  }

  function presaleBuy(
    bytes32 hash,
    bytes memory signature,
    uint256 tokenQuantity
  ) external payable {
    require(!saleLive && presaleLive, "PRESALE_CLOSED");
    require(matchAddressSigner(hash, signature), "DIRECT_MINT_DISALLOWED");
    require(
      presalerListPurchases[msg.sender] + tokenQuantity <= AGC_PER_MINT,
      "EXCEED_ALLOC"
    );
    require(tokenQuantity <= AGC_PER_MINT, "EXCEED_AGC_PER_MINT");
    require(AGC_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");

    uint256 supply = _owners.length;
    require(supply + tokenQuantity <= AGC_PUBLIC, "EXCEED_MAX_SALE_SUPPLY");

    presalerListPurchases[msg.sender] += tokenQuantity;
    for (uint256 i = 0; i < tokenQuantity; i++) {
      _mint(msg.sender, supply++);
    }
  }

  // ** - ADMIN - ** //

  function withdraw() external onlyOwner {
    payable(_vaultAddress).transfer(address(this).balance);
  }

  function gift(address[] calldata receivers) external onlyOwner {
    uint256 supply = _owners.length;

    require(supply + receivers.length <= AGC_MAX, "MAX_MINT");
    require(giftedAmount + receivers.length <= AGC_GIFT, "NO_GIFTS");

    for (uint256 i = 0; i < receivers.length; i++) {
      giftedAmount++;
      _safeMint(receivers[i], supply++);
    }
  }

  function togglePresaleStatus() external onlyOwner {
    presaleLive = !presaleLive;
  }

  function toggleSaleStatus() external onlyOwner {
    saleLive = !saleLive;
  }

  // ** - SETTERS - ** //

  function setSignerAddress(address addr) external onlyOwner {
    _signerAddress = addr;
  }

  function setVaultAddress(address addr) external onlyOwner {
    _vaultAddress = addr;
  }

  function setContractURI(string calldata URI) external onlyOwner {
    _contractURI = URI;
  }

  function setBaseURI(string calldata URI) external onlyOwner {
    _tokenBaseURI = URI;
  }

  // ** - MISC - ** //

  function setProvenanceHash(string calldata hash) external onlyOwner {
    provenance = hash;
  }

  function contractURI() public view returns (string memory) {
    return _contractURI;
  }

  function tokenURI(uint256 tokenId)
    external
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
  }

  function presalePurchasedCount(address addr) external view returns (uint256) {
    return presalerListPurchases[addr];
  }

  function matchAddressSigner(bytes32 hash, bytes memory signature)
    private
    view
    returns (bool)
  {
    return _signerAddress == hash.recover(signature);
  }
}
