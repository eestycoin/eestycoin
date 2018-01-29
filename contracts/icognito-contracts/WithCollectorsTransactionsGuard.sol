pragma solidity ^0.4.18;

/**
 * @dev Mixin to guard collectors from double participation with a same transaction
 */
contract WithCollectorsTransactionsGuard {
    // used transactions hashes by collector
    mapping (uint8 => mapping (uint256 => bool)) public collectorsTransactions;
}
