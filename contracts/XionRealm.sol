// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.0;

import "@openzeppelin/contracts@4.5.0/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/Math.sol";
import "@openzeppelin/contracts@4.5.0/utils/math/SafeMath.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts@4.5.0/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";

import "@elklabs/baas/lib/ERC20Realm.sol";
import "./XionInterfaces.sol";

contract XionRealm is ERC20Realm {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /* ========== STATE VARIABLES ========== */

    IXGPurchases public immutable purchases;

    /* ========== CONSTRUCTOR ========== */

    constructor(address _reservoir, address _bifrost, address _xgPurchases, bool _enabled) ERC20Realm(_reservoir, _bifrost, _enabled) {
        purchases = IXGPurchases(_xgPurchases);
    }

    /* ========== HOOKS ========== */

    function _beforeEnter(bytes32 _id, XTransfer memory _xt) internal virtual override {
        (address sender, address receiver, uint256 amount, bytes memory message) = deserialize(_xt.data);
        XionMessage memory xmsg = abi.decode(message, (XionMessage));
        // XXX: add some validation code
        // Get the funds out of the reservoir (using this contract to hold them -- probably best to use a dedicated contract in prod)
        address tmpFundsHolder = address(this);
        reservoir.withdraw(tmpFundsHolder, amount, _id);
        // XXX: approve the purchases contract so it can spend funds from the funds holder
        // Call the purchasing function (check that the code pulls the funds from msg.sender and credits them to sender)
        purchases.processPurchase(sender, receiver, xmsg.purchaseId, xmsg.productId, xmsg.parentProductId, xmsg.processId, xmsg.price, reservoir.tokenAddress(), amount, xmsg.tokenPrice);
        // Note: another way to do this is to use the sender's address on the current chain to hold the funds (avoiding a dedicated 3rd party contract to hold funds).
        // In that case, the sender has to sign a permit to spend the funds on the target chain and the permit must be transmitted as an extra payload.
        // Note2: yet another way is to write a custom reservoir where withdraw is overriden to call the appropriate function on purchases directly.
    }

    function _beforeComplete(bytes32 _id, XTransfer calldata _xt) internal virtual override {
        // XXX: handle completion (mark as paid in the backend)
    }

    function _beforeAbort(bytes32 _id, XTransfer calldata _xt, string calldata _message) internal virtual override {
        // XXX: handle abortion (retry?)
    }

}
