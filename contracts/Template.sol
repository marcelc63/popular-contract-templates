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

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title Curious Addys' Trading Club Contract
 * @author Mai Akiyoshi & Ben Yu (https://twitter.com/mai_on_chain & https://twitter.com/intenex)
 * @notice This contract handles minting and refunding of First Edition Curious Addys' Trading Club tokens.
 */
contract CuriousAddys is ERC721Enumerable, ReentrancyGuard, Ownable, Pausable {
  using ECDSA for bytes32;
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string public baseTokenURI;

  uint256 public constant price = 0.08 ether;
  uint256 public immutable maxSupply;
  uint256 public immutable firstSaleSupply;
  uint256 public immutable reserveSupply;

  /**
   * @notice Construct a Curious Addys instance
   * @param name Token name
   * @param symbol Token symbol
   * @param baseTokenURI_ Base URI for all tokens
   */
  constructor(
    string memory name,
    string memory symbol,
    string memory baseTokenURI_,
    uint256 maxSupply_,
    uint256 firstSaleSupply_,
    uint256 reserveSupply_
  ) ERC721(name, symbol) {
    require(maxSupply_ > 0, "INVALID_SUPPLY");
    baseTokenURI = baseTokenURI_;
    maxSupply = maxSupply_;
    firstSaleSupply = firstSaleSupply_;
    reserveSupply = reserveSupply_;

    // Start token IDs at 1
    _tokenIds.increment();
  }

  // Used to validate authorized mint addresses
  address private signerAddress = 0xabcB40408a94E94f563d64ded69A75a3098cBf59;
  // The address where refunded tokens are returned to
  address private refundAddress = 0x52EA5F96f004d174470901Ba3F1984D349f0D3eF;

  mapping(address => uint256) public totalMintsPerAddress;

  uint256 public saleEndTime = block.timestamp;

  bool public isFirstSaleActive = false;
  bool public isSecondSaleActive = false;
  bool public reserveMintCompleted = false;

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(_exists(tokenId), "URI query for nonexistent token");

    return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  /**
   * To be updated by contract owner to allow for the first tranche of members to mint
   */
  function setFirstSaleState(bool _firstSaleActiveState) public onlyOwner {
    require(
      isFirstSaleActive != _firstSaleActiveState,
      "NEW_STATE_IDENTICAL_TO_OLD_STATE"
    );
    isFirstSaleActive = _firstSaleActiveState;
  }

  /**
   * To be updated once maxSupply equals totalSupply. This will deactivate minting.
   * Can also be activated by contract owner to begin public sale
   */
  function setSecondSaleState(bool _secondSaleActiveState) public onlyOwner {
    require(
      isSecondSaleActive != _secondSaleActiveState,
      "NEW_STATE_IDENTICAL_TO_OLD_STATE"
    );
    isSecondSaleActive = _secondSaleActiveState;
    if (!isSecondSaleActive) {
      saleEndTime = block.timestamp;
    }
  }

  function setSignerAddress(address _signerAddress) external onlyOwner {
    require(_signerAddress != address(0));
    signerAddress = _signerAddress;
  }

  function setRefundAddress(address _refundAddress) external onlyOwner {
    require(_refundAddress != address(0));
    refundAddress = _refundAddress;
  }

  /**
   * Returns all the token ids owned by a given address
   */
  function ownedTokensByAddress(address owner)
    external
    view
    returns (uint256[] memory)
  {
    uint256 totalTokensOwned = balanceOf(owner);
    uint256[] memory allTokenIds = new uint256[](totalTokensOwned);
    for (uint256 i = 0; i < totalTokensOwned; i++) {
      allTokenIds[i] = (tokenOfOwnerByIndex(owner, i));
    }
    return allTokenIds;
  }

  /**
   * Update the base token URI
   */
  function setBaseURI(string calldata _newBaseURI) external onlyOwner {
    baseTokenURI = _newBaseURI;
  }

  function pause() public onlyOwner {
    _pause();
  }

  function unpause() public onlyOwner {
    _unpause();
  }

  /**
   * When the contract is paused, all token transfers are prevented in case of emergency.
   */
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override whenNotPaused {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  /**
   * Will return true if token holders can still return their tokens for a full mint price refund
   */
  function refundGuaranteeActive() public view returns (bool) {
    return (block.timestamp < (saleEndTime + 100 days));
  }

  function verifyAddressSigner(bytes32 messageHash, bytes memory signature)
    private
    view
    returns (bool)
  {
    return
      signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
  }

  function hashMessage(address sender, uint256 maximumAllowedMints)
    private
    pure
    returns (bytes32)
  {
    return keccak256(abi.encode(sender, maximumAllowedMints));
  }

  /**
   * @notice Allow for minting of tokens up to the maximum allowed for a given address.
   * The address of the sender and the number of mints allowed are hashed and signed
   * with the server's private key and verified here to prove whitelisting status.
   */
  function mint(
    bytes32 messageHash,
    bytes calldata signature,
    uint256 mintNumber,
    uint256 maximumAllowedMints
  ) external payable virtual nonReentrant {
    require(isFirstSaleActive || isSecondSaleActive, "SALE_IS_NOT_ACTIVE");
    require(
      totalMintsPerAddress[msg.sender] + mintNumber <= maximumAllowedMints,
      "MINT_TOO_LARGE"
    );
    require(
      hashMessage(msg.sender, maximumAllowedMints) == messageHash,
      "MESSAGE_INVALID"
    );
    require(
      verifyAddressSigner(messageHash, signature),
      "SIGNATURE_VALIDATION_FAILED"
    );
    // Imprecise floats are scary. Front-end should utilize BigNumber for safe precision, but adding margin just to be safe to not fail txs
    require(
      msg.value >= ((price * mintNumber) - 0.0001 ether) &&
        msg.value <= ((price * mintNumber) + 0.0001 ether),
      "INVALID_PRICE"
    );

    uint256 currentSupply = totalSupply();

    if (isFirstSaleActive) {
      require(
        currentSupply + mintNumber <= firstSaleSupply,
        "NOT_ENOUGH_MINTS_AVAILABLE"
      );
    } else {
      require(
        currentSupply + mintNumber <= maxSupply,
        "NOT_ENOUGH_MINTS_AVAILABLE"
      );
    }

    totalMintsPerAddress[msg.sender] += mintNumber;

    for (uint256 i = 0; i < mintNumber; i++) {
      _safeMint(msg.sender, _tokenIds.current());
      _tokenIds.increment();
    }

    // Update the saleEndTime at the end of the second sale so the refund guarantee starts from now
    if (isFirstSaleActive && (currentSupply + mintNumber >= firstSaleSupply)) {
      isFirstSaleActive = false;
    } else if (
      isSecondSaleActive && (currentSupply + mintNumber >= maxSupply)
    ) {
      isSecondSaleActive = false;
      saleEndTime = block.timestamp;
    }
  }

  /**
   * @notice Allow owner to send `mintNumber` tokens without cost to multiple addresses
   */
  function gift(address[] calldata receivers, uint256 mintNumber)
    external
    onlyOwner
  {
    require(
      (totalSupply() + (receivers.length * mintNumber)) <= maxSupply,
      "MINT_TOO_LARGE"
    );

    for (uint256 i = 0; i < receivers.length; i++) {
      for (uint256 j = 0; j < mintNumber; j++) {
        _safeMint(receivers[i], _tokenIds.current());
        _tokenIds.increment();
      }
    }
  }

  /**
   * @notice Allow the owner to mint their reserved supply
   */
  function mintReserveSupply() external virtual onlyOwner {
    require(!reserveMintCompleted, "RESERVE_MINT_ALREADY_COMPLETED");

    // Start at first token after the public supply
    uint256 start = (maxSupply - reserveSupply) + 1;

    for (uint256 tokenId = start; tokenId <= maxSupply; tokenId++) {
      _safeMint(owner(), tokenId);
    }

    reserveMintCompleted = true;
  }

  /**
   * @notice Refund token and return the mint price to the token owner.
   * @param _tokenId The id of the token to refund.
   */
  function refund(uint256 _tokenId) external nonReentrant {
    require(refundGuaranteeActive(), "REFUND_GUARANTEE_EXPIRED");
    require(ownerOf(_tokenId) == msg.sender, "MUST_OWN_TOKEN");

    // Transfer token to CATC wallet
    _transfer(msg.sender, refundAddress, _tokenId);

    // Refund the token owner 100% of the mint price.
    payable(msg.sender).transfer(price);
  }

  /**
   * @notice Allow contract owner to withdraw funds after the refund guarantee ends.
   */
  function withdrawFundsAfterRefundExpires() external onlyOwner {
    require(!refundGuaranteeActive(), "REFUND_GUARANTEE_STILL_ACTIVE");
    payable(owner()).transfer(address(this).balance);
  }
}
