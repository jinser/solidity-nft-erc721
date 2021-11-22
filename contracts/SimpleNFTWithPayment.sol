// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts@3.4.0/token/ERC721/ERC721.sol"; 
 
//defines the functions of ERC20 that are used in this contract code 
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/**
 * This is an ERC-721 NFT example that provides a simple way for payment of NFTs. 
 * Payment is conducted via an ERC-20 Token while ownership of the NFT changes hands.
*/
contract SimpleNFTWithPayment is ERC721 {
    
    //simple method for creating unique identifiers for NFTs which also acts to track the total number of NFTs created as well
    uint256 public counter;
    
    //Mapping of unique identifier of NFT to the latest minimum price
    mapping(uint256 => uint256) private _minPrice;
    
    //payment token (ERC20) 
    IERC20 private _paymentToken;
    
    //constructor class to include ERC721 
    //define the payment token using the contract address before launch
    constructor  (
        string memory name,
        string memory symbol,
        address paymentToken
    ) ERC721 (name,symbol) {
        counter = 0; 
        _paymentToken = IERC20(paymentToken);
    }
    
    //invocable function to mint and create new NFT tokens
    //tokenURI points to the underlying asset of the newly created NFT token
    //returns unique identifier of the newly created NFT token
    function createNftToken(string memory tokenURI) public {
        //using a simple method for creating unique identifiers of the NFT token
        uint256 newNftTokenId = counter;
        
        //internal ERC721.sol function call
        //safe minting where input parameters are the owner (sender of this function) and the unique id of the token 
        _safeMint(msg.sender,newNftTokenId);
    
        //internal ERC721.sol function call
        //linking the underlying asset to the newly created token
        _setTokenURI(newNftTokenId, tokenURI);
        
        //increment the counter to preserve uniqueness
        counter = counter + 1;
        
    }
    
    //puchase NFT with an ERC-20 payment token preset during the initial deployment
    //requires the current owner of the NFT to grant permission to the buyer's address to take over the NFT ownership via the approve() function
    function purchaseNftToken(uint256 tokenId, uint256 paymentAmount) public returns (bool) {
        //get the address of the current owner of the NFT based on tokenId 
        address currentOwner = ownerOf(tokenId);
        
        //address 0 is used as an address where tokens are sent to when they are being "burnt"
        require(msg.sender != address(0), "purchase cannot be conducted by the zero address.");
        
        //check that the price exceeds the set minimum price
        require(paymentAmount >= _minPrice[tokenId], "payment amount is less than the minimum price. ");
        
        //transfer payment tokens from buyer to the current owner of the NFT
        //if payment fails, abort the purchase operation
        require(_paymentToken.transferFrom(msg.sender, currentOwner, paymentAmount),"payment failed" );

        //requires the original message sender to be approved by currentOwner, otherwise this will fail
        transferFrom(currentOwner,msg.sender,tokenId);
        
        //ensure that the transfer of NFT was successful 
        //if this fails, all state changes even before this line will be reverted such as the payment token transfer
        //ensures transaction is atomic
        require(ownerOf(tokenId) == msg.sender, "transfer of NFT failed");
        return true;
    }
    
    //owner of the token is able to set a minimum price for their NFT
    //tokenId is the unique identifier of the NFT whose minimum price will be set
    //tokenAmount represents the amount of payment tokens needed to purchase the NFT
    function setMinimumPrice(uint256 tokenId, uint256 paymentAmount) public returns (bool) {
        //verification check that the minimum price is only set by the owner of the token
        require(msg.sender == ownerOf(tokenId), "price can only be set by the owner");
        //map the minimum price to the unique token identifer
        _minPrice[tokenId] = paymentAmount;
        return true;
    }
    
    //anyone is eligible to retrieve the minimum price previously set 
    function getMinimumPrice(uint256 tokenId) public view returns (uint256)  {
        return _minPrice[tokenId]; 
    }


}