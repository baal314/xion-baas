// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.0;

import "@openzeppelin/contracts@4.5.0/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/Math.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/SafeMath.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts@4.5.0/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";

import "../lib/ERC20Realm.sol";
import "./XionInterfaces.sol";

contract XionRealmExample is ERC20Realm {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /* ========== STATE VARIABLES ========== */

    IXGPurchases public immutable purchases;

    /* ========== CONSTRUCTOR ========== */

    constructor(address _reservoir, address _bifrost, address _xgPurchases, bool _enabled) ERC20Realm(_reservoir, _bifrost, _enabled) {
        purchases = IXGPurchases(_xgPurchases);
    }

    /* ========== HOOKS ========== */

    function _beforeExit(bytes32 _id, XTransfer memory _xt) internal virtual override {
        (address sender, address receiver, uint256 amount, bytes memory message) = deserialize(_xt.data);
        XionMessage memory xmsg = abi.decode(message, (XionMessage));
        // XXX: add some validation code
        // Get the funds out of the reservoir (using this contract to hold them temporarily)
        address tmpFundsHolder = address(this);
        reservoir.withdraw(tmpFundsHolder, amount, _id);
        // Approve the xgWallet contract so it can spend our funds
        IERC20(reservoir.tokenAddress()).approve(address(purchases.wallet()), amount);
        // Deposit tokens on behalf of user
        IXGWallet(address(purchases.wallet())).depositTokenOnBehalfOfUser(receiver, reservoir.tokenAddress(), amount);
        // Confirm the deposit
        purchases.confirmDepositForPurchase(sender, receiver, xmsg.purchaseId, xmsg.productId, xmsg.parentProductId, xmsg.processId, xmsg.price, reservoir.tokenAddress(), amount, xmsg.tokenPrice);
    }

}
