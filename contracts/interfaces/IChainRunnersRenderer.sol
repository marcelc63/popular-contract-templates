// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../core/ChainRunnersTypes.sol";

interface IChainRunnersRenderer {
  function tokenURI(
    uint256 tokenId,
    ChainRunnersTypes.ChainRunner memory runnerData
  ) external view returns (string memory);
}
