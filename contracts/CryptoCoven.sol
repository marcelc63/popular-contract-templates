//SPDX-License-Identifier: MIT
//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)

pragma solidity ^0.8.0;

/*
.・。.・゜✭・.・✫・゜・。..・。.・゜✭・.・✫・゜・。.✭・.・✫・゜・。..・✫・゜・。.・。.・゜✭・.・✫・゜・。..・。.・゜✭・.・✫・゜・。.✭・.・✫・゜・。..・✫・゜・。

                                                       s                                            _                                 
                         ..                           :8                                           u                                  
             .u    .    @L           .d``            .88           u.                       u.    88Nu.   u.                u.    u.  
      .    .d88B :@8c  9888i   .dL   @8Ne.   .u     :888ooo  ...ue888b           .    ...ue888b  '88888.o888c      .u     x@88k u@88c.
 .udR88N  ="8888f8888r `Y888k:*888.  %8888:u@88N  -*8888888  888R Y888r     .udR88N   888R Y888r  ^8888  8888   ud8888.  ^"8888""8888"
<888'888k   4888>'88"    888E  888I   `888I  888.   8888     888R I888>    <888'888k  888R I888>   8888  8888 :888'8888.   8888  888R 
9888 'Y"    4888> '      888E  888I    888I  888I   8888     888R I888>    9888 'Y"   888R I888>   8888  8888 d888 '88%"   8888  888R 
9888        4888>        888E  888I    888I  888I   8888     888R I888>    9888       888R I888>   8888  8888 8888.+"      8888  888R 
9888       .d888L .+     888E  888I  uW888L  888'  .8888Lu= u8888cJ888     9888      u8888cJ888   .8888b.888P 8888L        8888  888R 
?8888u../  ^"8888*"     x888N><888' '*88888Nu88P   ^%888*    "*888*P"      ?8888u../  "*888*P"     ^Y8888*""  '8888c. .+  "*88*" 8888"
 "8888P'      "Y"        "88"  888  ~ '88888F`       'Y"       'Y"          "8888P'     'Y"          `Y"       "88888%      ""   'Y"  
   "P'                         88F     888 ^                                  "P'                                "YP'                 
                              98"      *8E                                                                                            
                            ./"        '8>                                                                                            
                           ~`           "                                                                                             


.・。.・゜✭・.・✫・゜・。..・。.・゜✭・.・✫・゜・。.✭・.・✫・゜・。..・✫・゜・。.・。.・゜✭・.・✫・゜・。..・。.・゜✭・.・✫・゜・。.✭・.・✫・゜・。..・✫・゜・。
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CryptoCoven is ERC721, IERC2981, Ownable, ReentrancyGuard {
  using Counters for Counters.Counter;
  using Strings for uint256;

  Counters.Counter private tokenCounter;

  string private baseURI;
  string public verificationHash;
  address private openSeaProxyRegistryAddress;
  bool private isOpenSeaProxyActive = true;

  uint256 public constant MAX_WITCHES_PER_WALLET = 3;
  uint256 public maxWitches;

  uint256 public constant PUBLIC_SALE_PRICE = 0.07 ether;
  bool public isPublicSaleActive;

  uint256 public constant COMMUNITY_SALE_PRICE = 0.05 ether;
  uint256 public maxCommunitySaleWitches;
  bytes32 public communitySaleMerkleRoot;
  bool public isCommunitySaleActive;

  uint256 public maxGiftedWitches;
  uint256 public numGiftedWitches;
  bytes32 public claimListMerkleRoot;

  mapping(address => uint256) public communityMintCounts;
  mapping(address => bool) public claimed;

  // ============ ACCESS CONTROL/SANITY MODIFIERS ============

  modifier publicSaleActive() {
    require(isPublicSaleActive, "Public sale is not open");
    _;
  }

  modifier communitySaleActive() {
    require(isCommunitySaleActive, "Community sale is not open");
    _;
  }

  modifier maxWitchesPerWallet(uint256 numberOfTokens) {
    require(
      balanceOf(msg.sender) + numberOfTokens <= MAX_WITCHES_PER_WALLET,
      "Max witches to mint is three"
    );
    _;
  }

  modifier canMintWitches(uint256 numberOfTokens) {
    require(
      tokenCounter.current() + numberOfTokens <= maxWitches - maxGiftedWitches,
      "Not enough witches remaining to mint"
    );
    _;
  }

  modifier canGiftWitches(uint256 num) {
    require(
      numGiftedWitches + num <= maxGiftedWitches,
      "Not enough witches remaining to gift"
    );
    require(
      tokenCounter.current() + num <= maxWitches,
      "Not enough witches remaining to mint"
    );
    _;
  }

  modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
    require(price * numberOfTokens == msg.value, "Incorrect ETH value sent");
    _;
  }

  modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
    require(
      MerkleProof.verify(
        merkleProof,
        root,
        keccak256(abi.encodePacked(msg.sender))
      ),
      "Address does not exist in list"
    );
    _;
  }

  constructor(
    address _openSeaProxyRegistryAddress,
    uint256 _maxWitches,
    uint256 _maxCommunitySaleWitches,
    uint256 _maxGiftedWitches
  ) ERC721("Crypto Coven", "WITCH") {
    openSeaProxyRegistryAddress = _openSeaProxyRegistryAddress;
    maxWitches = _maxWitches;
    maxCommunitySaleWitches = _maxCommunitySaleWitches;
    maxGiftedWitches = _maxGiftedWitches;
  }

  // ============ PUBLIC FUNCTIONS FOR MINTING ============

  function mint(uint256 numberOfTokens)
    external
    payable
    nonReentrant
    isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
    publicSaleActive
    canMintWitches(numberOfTokens)
    maxWitchesPerWallet(numberOfTokens)
  {
    for (uint256 i = 0; i < numberOfTokens; i++) {
      _safeMint(msg.sender, nextTokenId());
    }
  }

  function mintCommunitySale(
    uint8 numberOfTokens,
    bytes32[] calldata merkleProof
  )
    external
    payable
    nonReentrant
    communitySaleActive
    canMintWitches(numberOfTokens)
    isCorrectPayment(COMMUNITY_SALE_PRICE, numberOfTokens)
    isValidMerkleProof(merkleProof, communitySaleMerkleRoot)
  {
    uint256 numAlreadyMinted = communityMintCounts[msg.sender];

    require(
      numAlreadyMinted + numberOfTokens <= MAX_WITCHES_PER_WALLET,
      "Max witches to mint in community sale is three"
    );

    require(
      tokenCounter.current() + numberOfTokens <= maxCommunitySaleWitches,
      "Not enough witches remaining to mint"
    );

    communityMintCounts[msg.sender] = numAlreadyMinted + numberOfTokens;

    for (uint256 i = 0; i < numberOfTokens; i++) {
      _safeMint(msg.sender, nextTokenId());
    }
  }

  function claim(bytes32[] calldata merkleProof)
    external
    isValidMerkleProof(merkleProof, claimListMerkleRoot)
    canGiftWitches(1)
  {
    require(!claimed[msg.sender], "Witch already claimed by this wallet");

    claimed[msg.sender] = true;
    numGiftedWitches += 1;

    _safeMint(msg.sender, nextTokenId());
  }

  // ============ PUBLIC READ-ONLY FUNCTIONS ============

  function getBaseURI() external view returns (string memory) {
    return baseURI;
  }

  function getLastTokenId() external view returns (uint256) {
    return tokenCounter.current();
  }

  // ============ OWNER-ONLY ADMIN FUNCTIONS ============

  function setBaseURI(string memory _baseURI) external onlyOwner {
    baseURI = _baseURI;
  }

  // function to disable gasless listings for security in case
  // opensea ever shuts down or is compromised
  function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
    external
    onlyOwner
  {
    isOpenSeaProxyActive = _isOpenSeaProxyActive;
  }

  function setVerificationHash(string memory _verificationHash)
    external
    onlyOwner
  {
    verificationHash = _verificationHash;
  }

  function setIsPublicSaleActive(bool _isPublicSaleActive) external onlyOwner {
    isPublicSaleActive = _isPublicSaleActive;
  }

  function setIsCommunitySaleActive(bool _isCommunitySaleActive)
    external
    onlyOwner
  {
    isCommunitySaleActive = _isCommunitySaleActive;
  }

  function setCommunityListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
    communitySaleMerkleRoot = merkleRoot;
  }

  function setClaimListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
    claimListMerkleRoot = merkleRoot;
  }

  function reserveForGifting(uint256 numToReserve)
    external
    nonReentrant
    onlyOwner
    canGiftWitches(numToReserve)
  {
    numGiftedWitches += numToReserve;

    for (uint256 i = 0; i < numToReserve; i++) {
      _safeMint(msg.sender, nextTokenId());
    }
  }

  function giftWitches(address[] calldata addresses)
    external
    nonReentrant
    onlyOwner
    canGiftWitches(addresses.length)
  {
    uint256 numToGift = addresses.length;
    numGiftedWitches += numToGift;

    for (uint256 i = 0; i < numToGift; i++) {
      _safeMint(addresses[i], nextTokenId());
    }
  }

  function withdraw() public onlyOwner {
    uint256 balance = address(this).balance;
    payable(msg.sender).transfer(balance);
  }

  function withdrawTokens(IERC20 token) public onlyOwner {
    uint256 balance = token.balanceOf(address(this));
    token.transfer(msg.sender, balance);
  }

  function rollOverWitches(address[] calldata addresses)
    external
    nonReentrant
    onlyOwner
  {
    require(
      tokenCounter.current() + addresses.length <= 128,
      "All witches are already rolled over"
    );

    for (uint256 i = 0; i < addresses.length; i++) {
      communityMintCounts[addresses[i]] += 1;
      // use mint rather than _safeMint here to reduce gas costs
      // and prevent this from failing in case of grief attempts
      _mint(addresses[i], nextTokenId());
    }
  }

  // ============ SUPPORTING FUNCTIONS ============

  function nextTokenId() private returns (uint256) {
    tokenCounter.increment();
    return tokenCounter.current();
  }

  // ============ FUNCTION OVERRIDES ============

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721, IERC165)
    returns (bool)
  {
    return
      interfaceId == type(IERC2981).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  /**
   * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
   */
  function isApprovedForAll(address owner, address operator)
    public
    view
    override
    returns (bool)
  {
    // Get a reference to OpenSea's proxy registry contract by instantiating
    // the contract using the already existing address.
    ProxyRegistry proxyRegistry = ProxyRegistry(openSeaProxyRegistryAddress);
    if (
      isOpenSeaProxyActive && address(proxyRegistry.proxies(owner)) == operator
    ) {
      return true;
    }

    return super.isApprovedForAll(owner, operator);
  }

  /**
   * @dev See {IERC721Metadata-tokenURI}.
   */
  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(_exists(tokenId), "Nonexistent token");

    return string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
  }

  /**
   * @dev See {IERC165-royaltyInfo}.
   */
  function royaltyInfo(uint256 tokenId, uint256 salePrice)
    external
    view
    override
    returns (address receiver, uint256 royaltyAmount)
  {
    require(_exists(tokenId), "Nonexistent token");

    return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
  }
}

// These contract definitions are used to create a reference to the OpenSea
// ProxyRegistry contract by using the registry's address (see isApprovedForAll).
contract OwnableDelegateProxy {

}

contract ProxyRegistry {
  mapping(address => OwnableDelegateProxy) public proxies;
}
