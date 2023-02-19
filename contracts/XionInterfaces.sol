// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.0;

interface IXGPurchases {

    function wallet() external returns (IXGWallet);

    function confirmDepositForPurchase(
        address user,
        address merchant,
        bytes32 purchaseId,
        bytes32 productId,
        bytes32 parentProductId,
        uint256 processID,
        uint256 price,
        address tokenAddress,
        uint256 tokenPayment,
        uint256 tokenPrice
    ) external;

}

struct XionMessage {
    bytes32 purchaseId;
    bytes32 productId;
    bytes32 parentProductId;
    uint256 processId;
    uint256 price;
    uint256 tokenPrice;
}

interface IXGWallet {

    function depositTokenOnBehalfOfUser(address user, address token, uint256 amount) external;

}
