// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Vault {
    IERC20 public immutable token;
    
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    address public admin; // Made public for easier testing
    uint256 public feePercent = 2; // Example: 2% fee

    // Governance Membership data structures
    uint256 private _membershipTokenId;
    mapping(uint256 => address) public _ownerOfmembershipToken;
    mapping(address => uint256) public _balanceOfmembershipToken;
    mapping(address => uint256) public _membershipTokenOf;

    // Task 3: Complete Mint Membership logic
    function _mintMembership(address to) internal {
        // Mint membership token if not already owned 
        if (_balanceOfmembershipToken[to] == 0) {
            _membershipTokenId++;
            uint256 newTokenId = _membershipTokenId;
            
            _ownerOfmembershipToken[newTokenId] = to;
            _balanceOfmembershipToken[to] = 1;
            _membershipTokenOf[to] = newTokenId;
        }
    }

    constructor(address _token) {
        token = IERC20(_token);
        admin = msg.sender; // The deployer is the admin who receives fees
    }

    function _mint(address _to, uint256 _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;

        // Automatically minting a membership on deposit
        _mintMembership(_to);
    }

    function _burn(address _from, uint256 _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function deposit(uint256 _amount) external {
        uint256 shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _shares) external {
        uint256 grossAmount = (_shares * token.balanceOf(address(this))) / totalSupply;
        
        // Task 2: Implement Withdrawal Fee (10% of grade)
        uint256 fee = (grossAmount * feePercent) / 100;
        uint256 netAmount = grossAmount - fee;

        _burn(msg.sender, _shares);

        // Perform transfers
        token.transfer(msg.sender, netAmount); // User gets net
        token.transfer(admin, fee);           // Admin gets fee

        // Task 4: Implement revoking of governance membership (5% of grade)
        // If the user has withdrawn everything, they lose membership
        if (balanceOf[msg.sender] == 0) {
            uint256 tokenId = _membershipTokenOf[msg.sender];
            delete _ownerOfmembershipToken[tokenId];
            delete _balanceOfmembershipToken[msg.sender];
            delete _membershipTokenOf[msg.sender];
        }
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}