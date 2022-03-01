// SPDX-License-Identifier: MIT
/*
-- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- -- -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - --
-                                                                                                                                                  -
-                                                                                                                                                  -
-                                                                                                                                                  -
-                                                                             .:-----:.                                                            -
-                                                                        :-=++== . . .=++==-                                                       -
-                                                                     :=+=. . . . . . . . . ++=                                                    -
-                                                                   -+=. . . . . . . . . . . . ++.                                                 -
-                                                                 :*= . . . . . . . . .  . . . . +=                                                -
-                                                                =+. . .. . .. . .. . .. . . . . .=*.                                              -
-                                                               ++. . . . . . . . . . . . . . . . . *.                                             -
-                                                              =+. . . . . . . . . . . . . . . . . . #.                                            -
-                                                              #. . . . . . . . . . . . . . . . . . . =+                                           -
-                                                             -+. . . . . . . . . . . . . . . . . . . #                                            -
-                                                             +=. . . . . . . . . . . . . . . . . . . *.                                           -
-                                                             +=. . . . . . . . . . . . . . . . . . . *.                                           -
-                                                             +=. . . . . . . . . . . . . . . . . . . *.                                           -
-                                ...::----.                   ==. . . . . . . . . . . . . . . . . . . *.                                           -
-                                :----------.                 =+. . . . . . . . . . . . . . . . . . . *.                                           -
-                         ....::----+++++++**=++=+*=**+++===*+*+......................................*=:.   ...::::-------------::..              -
-                        ---------++++++**::::==.""       :+::=*........................................-=**::...                  .:------.       -
-                         ------++++++**:::==""           #::::#......................................:::--*                               .=-     -
-                          .------+++**:::*:"             *:::::-==++++++++++=+==---::::::::::--------=++*%=.                             .:+-     -
-                            .:---++**:::*.                =+-:::::::::::::::::::::--------==+++===--:.    .:------.                  .:-=+=.      -
-                            .-----**:::*.      ..::::.._    :===+++=========++++++=====--:.                 .::--=+##*-        ..::-+==-          -
-                              .----*-:-*-------:        ++-.__      ........                       .:-===+===-........-===-.::-++**:              -
-                               .=*++=-:.                      "--_                            :-=++=-                 '""-=*#+==--*:              -
-                         :-----:.                                 ==-.                    :=++=.                           .=*+-++-+.             -
-                  .:----:"                                           :==:              .++=.                        ..........*. +--+             -
-             :----:                                                     .==.         :*+.                   ..................-#:+--"             -
-        :---:.                                                             -+      .++                 ......-=+*******+:::::..*#-*-              -
-     ---.                                                               ...:*    .:*-              ......+*****++:::::::::::::.+*+=               -
-    *                                                       .....:::::::-=++.   .:*-            ....-=***+:::::++**+::::::::::.+*:                -
-    ==.                                         .....:::::::::-==+++++++=-.....::++          .....-***::::+***++==-#+:::::::::.#'                 -
-      -+-                         .....:::::::::::--==++++++++*%-===============#.         .....-+#+::::+#+=------=#+::::::::.+-                  -
-        .=+=-:........:::::::::::::::--==+++++++++==**---------+#===============#.      .......-=#::::::#------=+**:::::::::.+=                   -
-            :--=================-----:.*===========**---=+==+---**==============#..............-**::::::#*******+::::::::..=*:                    -
-                                       ===========**---+-   .+--=#==============#..............-**::::::::::::::::::::...+=:                      -
-                                        *...======**---*     *=-=*-=+-==========-%..............=*:::::::::::::::-...=+=-                         -
-                                         +.    ..=**---*    .+--+#   :-=+========*=..............-=::::::::-.....=+=-:                            -
-                                          -=:     *+---=+:.-*---+*       .-=+=-===*%...............------...=++=-.                                -
-                                            :==.   ++----==----*:             -==+=+*=-...............=+===-.                                     -
-                                               :---.*+-------=*.                  .--++#==++++=====--:.                                           -
-                                                   --*+*+++*+-                                                                                    -
-                                                       ....                                                                                       -
-                                                                                                                                                  -
-                                                                                                                                                  -
-                                                                                                                                                  -
-- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- -- -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - --

/// @author: proteinNFT with WestCoastNFT

*/
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract SpaceDoodles is
  ERC721Enumerable,
  IERC721Receiver,
  VRFConsumerBaseV2,
  ReentrancyGuard,
  AccessControl
{
  struct Stats {
    uint8 rank;
    // traits
    uint8 piloting;
    uint8 mechanical;
    uint8 stamina;
    uint8 bladder;
    uint8 vibe;
  }

  event ChangedStats(uint256 indexed _tokenId);

  mapping(uint256 => Stats) public tokenStats; // token id => stats
  mapping(uint256 => uint256[]) public batches; // batch id => token ids
  mapping(uint256 => uint256) public requestIdToBatchId; // VRF request id => batch id

  uint256 public minBatchSize = 20;
  uint256 public maxBatchSize = 40;
  bool public launchingActive;
  bool public dockingActive;
  uint8[] public LOADED_DIE_LOOKUP;
  uint256 public batchCount;
  string private _baseURIOverride;

  IERC721 immutable DOODLES;
  VRFCoordinatorV2Interface immutable COORDINATOR;
  LinkTokenInterface immutable LINKTOKEN;

  struct RequestConfig {
    bytes32 keyHash;
    uint64 subId;
    uint32 callbackGasLimit;
    uint16 requestConfirmations;
  }
  RequestConfig public requestConfig;

  bytes32 public constant SUPPORT_ROLE = keccak256("SUPPORT");
  bytes32 public constant RANK_WRITER_ROLE = keccak256("RANK_WRITER");

  uint256 private _royaltyBps;
  address payable private _royaltyRecipient;
  bytes4 private constant _INTERFACE_ID_ROYALTIES_CREATORCORE = 0xbb3bafd6;
  bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;
  bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;

  modifier tokenExists(uint256 tokenId) {
    require(_exists(tokenId), "Token does not exist.");
    _;
  }

  constructor(
    address _Doodles,
    address _VRFCoordinator,
    address _LINKToken,
    bytes32 _keyHash,
    uint64 _subId
  ) ERC721("Space Doodles", "SDOODLE") VRFConsumerBaseV2(_VRFCoordinator) {
    DOODLES = IERC721(_Doodles);
    COORDINATOR = VRFCoordinatorV2Interface(_VRFCoordinator);
    LINKTOKEN = LinkTokenInterface(_LINKToken);

    requestConfig = RequestConfig({
      keyHash: _keyHash,
      subId: _subId,
      callbackGasLimit: 2500000,
      requestConfirmations: 3
    });

    // roll this 256-sided die to get a trait value
    LOADED_DIE_LOOKUP = [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      6,
      6,
      6,
      6,
      7,
      7,
      8
    ];

    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _setupRole(SUPPORT_ROLE, msg.sender);
  }

  // chainlink config setters

  function setSubId(uint64 _subId) external onlyRole(SUPPORT_ROLE) {
    requestConfig.subId = _subId;
  }

  function setCallbackGasLimit(uint32 _callbackGasLimit)
    external
    onlyRole(SUPPORT_ROLE)
  {
    requestConfig.callbackGasLimit = _callbackGasLimit;
  }

  function setRequestConfirmations(uint16 _requestConfirmations)
    external
    onlyRole(SUPPORT_ROLE)
  {
    requestConfig.requestConfirmations = _requestConfirmations;
  }

  function setKeyHash(bytes32 _keyHash) external onlyRole(SUPPORT_ROLE) {
    requestConfig.keyHash = _keyHash;
  }

  // more configuration

  function setMinBatchSize(uint256 _minBatchSize)
    external
    onlyRole(SUPPORT_ROLE)
  {
    minBatchSize = _minBatchSize;
    if (minBatchSize > maxBatchSize) {
      maxBatchSize = minBatchSize;
    }
  }

  function setMaxBatchSize(uint256 _maxBatchSize)
    external
    onlyRole(SUPPORT_ROLE)
  {
    maxBatchSize = _maxBatchSize;
    if (minBatchSize > maxBatchSize) {
      minBatchSize = maxBatchSize;
    }
  }

  function _baseURI() internal view override returns (string memory) {
    return _baseURIOverride;
  }

  function setBaseURI(string memory uri) external onlyRole(SUPPORT_ROLE) {
    _baseURIOverride = uri;
  }

  function setLaunchingActive(bool launchingActive_)
    external
    onlyRole(SUPPORT_ROLE)
  {
    launchingActive = launchingActive_;
  }

  function setDockingActive(bool dockingActive_)
    external
    onlyRole(SUPPORT_ROLE)
  {
    dockingActive = dockingActive_;
  }

  // getters and setters for stats

  function getStats(uint256 tokenId)
    external
    view
    tokenExists(tokenId)
    returns (Stats memory)
  {
    Stats memory sd = tokenStats[tokenId];
    require(sd.rank > 0, "Token traits have not been initialized.");
    return sd;
  }

  function setRank(uint256 tokenId, uint8 _rank)
    external
    onlyRole(RANK_WRITER_ROLE)
    tokenExists(tokenId)
  {
    tokenStats[tokenId].rank = _rank;
    emit ChangedStats(tokenId);
  }

  // batch processing

  function _ceil(uint256 a, uint256 m) internal pure returns (uint256) {
    return (a + m - 1) / m;
  }

  function _processBatch() internal returns (uint256) {
    RequestConfig memory rc = requestConfig;

    uint32 numWords = uint32(_ceil(batches[batchCount].length, SEEDS_PER_WORD));
    uint256 requestId = COORDINATOR.requestRandomWords(
      rc.keyHash,
      rc.subId,
      rc.requestConfirmations,
      rc.callbackGasLimit,
      numWords
    );

    requestIdToBatchId[requestId] = batchCount;
    batchCount++;
    return requestId;
  }

  function flushBatch()
    external
    nonReentrant
    onlyRole(SUPPORT_ROLE)
    returns (uint256)
  {
    return _processBatch();
  }

  function retryBatch(uint256 batchId)
    public
    onlyRole(SUPPORT_ROLE)
    returns (uint256)
  {
    uint256 batchSize = batches[batchId].length;

    // only allowed to retry if Stats haven't been set
    for (uint256 i; i < batchSize; i++) {
      require(
        tokenStats[batches[batchId][i]].rank == 0,
        "Traits have already been set."
      );
    }

    RequestConfig memory rc = requestConfig;

    uint32 numWords = uint32(_ceil(batches[batchId].length, SEEDS_PER_WORD));
    uint256 requestId = COORDINATOR.requestRandomWords(
      rc.keyHash,
      rc.subId,
      rc.requestConfirmations,
      rc.callbackGasLimit,
      numWords
    );

    requestIdToBatchId[requestId] = batchId;
    return requestId;
  }

  // trait assignment

  uint256 public constant BITS_PER_TRAIT = 8;
  uint256 public constant NUM_TRAITS = 5;
  uint256 public constant VRF_WORD_SIZE = 256;
  uint256 public constant BITS_PER_SEED = BITS_PER_TRAIT * NUM_TRAITS;
  uint256 public constant SEEDS_PER_WORD = VRF_WORD_SIZE / BITS_PER_SEED;
  uint256 public constant SEED_MASK = (1 << BITS_PER_SEED) - 1;

  function _selectTrait(uint8 seed) internal view returns (uint8) {
    return LOADED_DIE_LOOKUP[seed];
  }

  function _computeStats(uint256 seed) internal view returns (Stats memory) {
    return
      Stats({
        rank: 1,
        piloting: _selectTrait(uint8(seed)),
        mechanical: _selectTrait(uint8(seed >> BITS_PER_TRAIT)),
        stamina: _selectTrait(uint8(seed >> (BITS_PER_TRAIT * 2))),
        bladder: _selectTrait(uint8(seed >> (BITS_PER_TRAIT * 3))),
        vibe: _selectTrait(uint8(seed >> (BITS_PER_TRAIT * 4)))
      });
  }

  // VRF callback function

  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
    internal
    override
  {
    uint256 batchId = requestIdToBatchId[requestId];
    uint256 batchSize = batches[batchId].length;
    for (uint256 i; i < batchSize; i++) {
      uint256 j = i / SEEDS_PER_WORD;
      uint256 seed = randomWords[j] & SEED_MASK;
      uint256 tokenId = batches[batchId][i];
      tokenStats[tokenId] = _computeStats(seed);
      emit ChangedStats(tokenId);
      randomWords[j] >>= BITS_PER_SEED;
    }
  }

  // launching/docking
  // launch: transfer in a Doodle and transfer/mint out a Space Doodle
  // dock: transfer in a Space Doodle and transfer out a Doodle
  // onERC721Received handler lets you send a Doodle directly to the contract, saving a setAllowedForAll call

  function _createSpaceShip(address to, uint256 tokenId) internal {
    batches[batchCount].push(tokenId);
    _safeMint(to, tokenId);
  }

  function onERC721Received(
    address,
    address from,
    uint256 tokenId,
    bytes memory data
  ) public virtual override nonReentrant returns (bytes4) {
    if (msg.sender == address(DOODLES)) {
      require(launchingActive, "Launching is not allowed at this time.");

      if (!_exists(tokenId)) {
        _createSpaceShip(from, tokenId);
        if (
          (data.length == 0 && batches[batchCount].length >= minBatchSize) ||
          batches[batchCount].length >= maxBatchSize
        ) {
          _processBatch();
        }
      } else {
        _safeTransfer(address(this), from, tokenId, "");
      }
    } else if (msg.sender == address(this)) {
      require(dockingActive, "Docking is not allowed at this time.");
      DOODLES.safeTransferFrom(address(this), from, tokenId);
    } else {
      revert("Only Doodles and Space Doodles are supported.");
    }

    return this.onERC721Received.selector;
  }

  function launchMany(uint256[] calldata tokenIds) external {
    for (uint256 i = 0; i < tokenIds.length; i++) {
      DOODLES.safeTransferFrom(msg.sender, address(this), tokenIds[i], "skip"); // skip batch check in onERC721Received
    }

    if (batches[batchCount].length >= minBatchSize) {
      _processBatch();
    }
  }

  function dockMany(uint256[] calldata tokenIds) external {
    for (uint256 i = 0; i < tokenIds.length; i++) {
      safeTransferFrom(msg.sender, address(this), tokenIds[i]);
    }
  }

  function sendLostDoodleHome(address to, uint256 tokenId)
    external
    onlyRole(SUPPORT_ROLE)
  {
    if (!_exists(tokenId) || ownerOf(tokenId) == address(this)) {
      // doodle stuck in this contract
      DOODLES.safeTransferFrom(address(this), to, tokenId);
    } else if (ownerOf(tokenId) == address(DOODLES)) {
      // space doodle stuck in doodle contract
      _safeTransfer(address(DOODLES), to, tokenId, "");
    } else {
      revert("Only allowed in rescue scenarios.");
    }
  }

  function withdraw() external onlyRole(DEFAULT_ADMIN_ROLE) {
    (bool success, ) = msg.sender.call{ value: address(this).balance }("");
    require(success, "Transfer failed.");
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(AccessControl, ERC721Enumerable)
    returns (bool)
  {
    return
      super.supportsInterface(interfaceId) ||
      interfaceId == _INTERFACE_ID_ROYALTIES_CREATORCORE ||
      interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981 ||
      interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE;
  }

  // eip 2981: royalties

  function updateRoyalties(address payable recipient, uint256 bps)
    external
    onlyRole(DEFAULT_ADMIN_ROLE)
  {
    _royaltyRecipient = recipient;
    _royaltyBps = bps;
  }

  function getRoyalties(uint256)
    external
    view
    returns (address payable[] memory recipients, uint256[] memory bps)
  {
    if (_royaltyRecipient != address(0x0)) {
      recipients = new address payable[](1);
      recipients[0] = _royaltyRecipient;
      bps = new uint256[](1);
      bps[0] = _royaltyBps;
    }
    return (recipients, bps);
  }

  function getFeeRecipients(uint256)
    external
    view
    returns (address payable[] memory recipients)
  {
    if (_royaltyRecipient != address(0x0)) {
      recipients = new address payable[](1);
      recipients[0] = _royaltyRecipient;
    }
    return recipients;
  }

  function getFeeBps(uint256) external view returns (uint256[] memory bps) {
    if (_royaltyRecipient != address(0x0)) {
      bps = new uint256[](1);
      bps[0] = _royaltyBps;
    }
    return bps;
  }

  function royaltyInfo(uint256, uint256 value)
    external
    view
    returns (address, uint256)
  {
    return (_royaltyRecipient, (value * _royaltyBps) / 10000);
  }
}
