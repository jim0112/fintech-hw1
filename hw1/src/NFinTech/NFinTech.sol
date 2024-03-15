// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    // function safeTransferFrom1(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}

interface IERC721TokenReceiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4);
}

contract NFinTech is IERC721 {
    // Note: I have declared all variables you need to complete this challenge
    string private _name;
    string private _symbol;

    uint256 private _tokenId;

    mapping(uint256 => address) private _owner;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApproval;
    mapping(address => bool) private isClaim;
    mapping(address => mapping(address => bool)) _operatorApproval;

    error ZeroAddress();

    constructor(string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
    }

    function claim() public {
        if (isClaim[msg.sender] == false) {
            uint256 id = _tokenId;
            _owner[id] = msg.sender;

            _balances[msg.sender] += 1;
            isClaim[msg.sender] = true;

            _tokenId += 1;
        }
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function balanceOf(address owner) public view returns (uint256) {
        if (owner == address(0)) revert ZeroAddress();
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owner[tokenId];
        if (owner == address(0)) revert ZeroAddress();
        return owner;
    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        if (owner == address(0)) revert ZeroAddress();
        if (operator == address(0)) revert ZeroAddress();
        _operatorApproval[owner][operator] = approved;

        emit ApprovalForAll(owner, operator, approved);
    }

    function _approve(address to, uint256 tokenId, address auth) internal virtual {
        address owner = ownerOf(tokenId);
        require(owner == auth || _operatorApproval[owner][auth], "Not the owner of the token");

        emit Approval(owner, to, tokenId);
        _tokenApproval[tokenId] = to;
    }

    function _getApproved(uint256 tokenId) internal view virtual returns (address) {
        return _tokenApproval[tokenId];
    }

    function _update(address to, uint256 tokenId) internal virtual returns (address) {
        address from = ownerOf(tokenId);

        // Execute the update
        if (from != address(0)) {
            // Clear approval. No need to re-authorize or emit the Approval event
            _tokenApproval[tokenId] = to;
            _balances[from] -= 1;
        }
        if (to != address(0)) {
            _balances[to] += 1;
        }

        _owner[tokenId] = to;
        emit Transfer(from, to, tokenId);
        return from;
    }

    function setApprovalForAll(address operator, bool approved) external {
        // TODO: please add your implementaiton here
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        // TODO: please add your implementaiton here
        return _operatorApproval[owner][operator];
    }

    function approve(address to, uint256 tokenId) external {
        // TODO: please add your implementaiton here
        _approve(to, tokenId, msg.sender);
    }

    function getApproved(uint256 tokenId) public view returns (address operator) {
        // TODO: please add your implementaiton here
        ownerOf(tokenId);
        return _getApproved(tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        // TODO: please add your implementaiton here
        if (from == address(0)) revert ZeroAddress();
        if (to == address(0)) revert ZeroAddress();
        address previousOwner = _update(to, tokenId);
        require(previousOwner == from, "Not the correct owner");
    }

    // function safeTransferFrom1(address from, address to, uint256 tokenId) public {
    //     // TODO: please add your implementaiton here
    //     transferFrom(from, to, tokenId);
    //     require(IERC721TokenReceiver(address(to)).onERC721Received(from, to, tokenId, "") == IERC721TokenReceiver.onERC721Received.selector, "Wrong selector");
    // }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        // TODO: please add your implementaiton here
        transferFrom(from, to, tokenId);
        require(IERC721TokenReceiver(address(to)).onERC721Received(from, to, tokenId, "") == IERC721TokenReceiver.onERC721Received.selector, "Wrong selector");
    }
}
