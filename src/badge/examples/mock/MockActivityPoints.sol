// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract MockActivityPoints {
  function getPoints(address user_) external pure returns (uint256) {
    if (user_ == address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)) {
      return 1843041647869850000000;
    } else if (user_ == address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8)) {
      return 650301247771830000000;
    } else if (user_ == address(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC)) {
      return 1100229365079355000000;
    } else {
      return 0;
    }
  }
}