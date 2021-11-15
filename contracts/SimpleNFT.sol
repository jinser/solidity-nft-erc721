// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts@3.4.0/token/ERC721/ERC721.sol"; 

contract SimpleNFT is ERC721 {
    
    //counts total number of NFTs created
    uint256 public counter;
    
    //constructor class to include ERC721 
    constructor  (
        string memory name,
        string memory symbol
    ) public ERC721 (name,symbol) {
        counter = 0; 
        
    }
    
    //invocable function to mint and create new NFT tokens
    //tokenURI contains the underlying asset of the newly created NFT token
    //returns id of the NFT token
    function createNftToken(string memory tokenURI) public {
        uint256 newNftTokenId = counter;
        
        //function calls from the ERC721.sol 
        
        //safe minting where input parameters are the owner and the unique id of the token 
        _safeMint(msg.sender,newNftTokenId);
    
        //linking the underlying asset to the newly created token
        _setTokenURI(newNftTokenId, tokenURI);
        
        //increment the counter
        counter = counter + 1;
        
    }
    
    
}