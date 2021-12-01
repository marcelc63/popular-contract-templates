// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

interface IBarn {
  function addManyToBarnAndPack(address account, uint16[] calldata tokenIds)
    external;

  function randomWolfOwner(uint256 seed) external view returns (address);
}
