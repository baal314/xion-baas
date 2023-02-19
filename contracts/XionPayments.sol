// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.0;

import "@openzeppelin/contracts@4.5.0/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/Math.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/SafeMath.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts@4.5.0/security/ReentrancyGuard.sol";

import "../interfaces/IBifrost.sol";
import "./XionInterfaces.sol";

struct PaymentInfo {
    address sender;
    address token;
    uint256 amount;
    XionMessage xmsg;
}

contract XionPaymentExample {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /* ========== STATE VARIABLES ========== */

    IBifrost public bifrost;

    uint256 public constant REALM_ID = 1;
    uint32 public constant POLYGON_CHAIN_ID = 137;
    address public constant PAYMENTS_CONTRACT = address(0);

    mapping(bytes32 => PaymentInfo) public payments;

    /* ========== CONSTRUCTOR ========== */

    constructor(address _bifrost) {
        bifrost = IBifrost(_bifrost);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    function makePayment(address _token, uint256 _amount, XionMessage calldata _xmsg) external {
        uint256 usdtAmount = swap(_token, _amount);
        bytes memory data = abi.encode(msg.sender, PAYMENTS_CONTRACT, usdtAmount, _xmsg);
        bytes32 id = bifrost.xTransfer(REALM_ID, POLYGON_CHAIN_ID, data);
        payments[id] = PaymentInfo(msg.sender, _token, _amount, _xmsg);
    }

    /* ========== PRIVATE FUNCTIONS ========== */

    function swap(address _token, uint256 _amount) private returns (uint256) {
        // Execute swap from token to USDT
        return 0;
    }

}
