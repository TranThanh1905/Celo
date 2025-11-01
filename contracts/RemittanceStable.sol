// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract RemittanceStable {
    address public owner;
    event Remitted(address indexed from, address indexed to, address token, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    /// @notice Send an ERC20 token (stablecoin) from sender to recipient via this contract.
    /// The sender MUST approve this contract beforehand (token.approve(contract, amount)).
    function sendStablecoin(address token, address to, uint256 amount) external {
        require(amount > 0, "Amount > 0");
        // check allowance for better UX (optional)
        uint256 allowed = IERC20(token).allowance(msg.sender, address(this));
        require(allowed >= amount, "Allowance too low");

        bool ok = IERC20(token).transferFrom(msg.sender, to, amount);
        require(ok, "Transfer failed");

        emit Remitted(msg.sender, to, token, amount);
    }
}
