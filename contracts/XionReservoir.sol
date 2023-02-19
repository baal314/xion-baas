// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.0;

import "@openzeppelin/contracts@4.5.0/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/Math.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/SafeMath.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts@4.5.0/security/ReentrancyGuard.sol";

import "./ReservoirLockExample.sol";
import "../interfaces/IReservoir.sol";

contract XionReservoirExample is ReservoirLockExample {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /* ========== CONSTRUCTOR ========== */

    // Deploy with USDT address on Polygon or hardcode the address in the reservoir
    constructor(address _tokenAddress, uint256 _txLimit) ReservoirLockExample(_tokenAddress, _txLimit) {}

}
