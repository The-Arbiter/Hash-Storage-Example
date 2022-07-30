// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

/// @dev Uses hashes to retrieve info and store info on chain. Uses a hash (32 bytes) in storage.

contract HashStore is Test{

    // Error if hashes don't match
    error IncorrectHash();

    mapping (uint256 => bytes32) Hashes;

    /// @dev Nonce for tracking items in mapping (like a txId or tokenId or similar)
    uint256 nonce; 

    /// @notice We are pretending to write a two-way token splitter for an arbitrary number of tokens
    /// @dev This can be anything you want, this is a proof of concept
    /// @param a_ is recipient 1
    /// @param b_ is recipient 2
    /// @param c_ is the token addresses
    /// @param d_ is the token amounts
    /// @param e_ is some arbitrary number for functionality (like a splitter expiry)
    /// @return storedHash - the resulting hash in storage
    function storeStructAsHash(address a_, address b_, address[] calldata c_, uint256[] calldata d_, uint64 e_) public returns(bytes32 storedHash){

        /// @dev [Optional] Perform checks on params:
        // Addresses should be ordered
        // Anything that can be reordered should be ordered
        // Other things such that the same params all produce the same hash
        
        // Hash the object
        storedHash = keccak256(abi.encodePacked(a_,b_,c_,d_,e_));
        // Store the hash
        Hashes[nonce] = storedHash;
        // Iterate nonce
        ++nonce;
    }


    /// @notice Validates the hash at some nonce using passed in params
    /// @param nonce_ is the nonce of the hash being validated
    /// @param a_ is recipient 1
    /// @param b_ is recipient 2
    /// @param c_ is the token addresses
    /// @param d_ is the token amounts
    /// @param e_ is some arbitrary number for functionality (like a splitter expiry)
    /// @return valid - bool or if it is valid or not
    function validateHash(
        uint256 nonce_, 
        address a_, 
        address b_, 
        address[] calldata c_, 
        uint256[] calldata d_, 
        uint64 e_) 
        public returns (bool valid){

        // Hash the inputs
        bytes32 parameterHash = keccak256(abi.encodePacked(a_,b_,c_,d_,e_));
        // Compare against hash in state
        if(parameterHash != Hashes[nonce_]){
            revert IncorrectHash();
        }
        // Return true if it doesn't revert
        valid = true;
        
    }


}
