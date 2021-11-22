// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC20/ERC20.sol";

contract PaymentToken is ERC20 {

    //override constructor class
    constructor (
        string memory name,
        string memory symbol
        ) ERC20(name,symbol) {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals()))); 
    } 
}