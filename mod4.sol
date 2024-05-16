// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    mapping(address => bool) private _frozenAccounts;

    event AccountFrozen(address indexed account);
    event AccountUnfrozen(address indexed account);

    constructor(address initialOwner) ERC20("DegenGamingToken", "DGT") Ownable(initialOwner) {
    }


    // Mint new tokens
    function mint(address to, uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        _mint(to, amount);
    }

    // Freeze an account
    function freezeAccount(address account) public onlyOwner {
        _frozenAccounts[account] = true;
        emit AccountFrozen(account);
    }

    // Unfreeze an account
    function unfreezeAccount(address account) public onlyOwner {
        _frozenAccounts[account] = false;
        emit AccountUnfrozen(account);
    }

    // Check if an account is frozen
    function isAccountFrozen(address account) public view returns (bool) {
        return _frozenAccounts[account];
    }

    // Transfer tokens, with additional check for frozen accounts
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(to != address(0), "Transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(!_frozenAccounts[msg.sender] && !_frozenAccounts[to], "Sender or recipient account is frozen");

        _transfer(msg.sender, to, amount);
        return true;
    }

    // Redeem tokens for items
    function redeem(uint256 amount) public {
        require(amount > 0, "Redeem amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _burn(msg.sender, amount);
        // Add code to provide items to the player based on `amount`
    }

    // Burn tokens
    function burn(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _burn(msg.sender, amount);
    }
}
