//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "../lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";

contract tradeAsset is ERC1155Holder {
    //function events
    event PropertyListed(
        uint256 indexed propertyId,
        uint256 indexed nftId,
        address indexed oldOwner
    );
    event PropertySold(
        uint256 indexed propertyId, 
        address indexed newOwner
    );
    event OnlyOwnerWithdrawal(
        address indexed moderator, 
        uint256 indexed propertyNftId, 
        address indexed recipientAddress, 
        address  tokenAddress
    );

    struct Property {
        bool forSale;
        address owner;
        string name;
        address nft;
        uint256 nftId;
        string description;
        string location;
        uint256 priceInCELO;
    }
    address public moderator;

    //mapping of property ID to struct that contains property info
    mapping(uint256 => Property) public properties;
    mapping(uint256 => bool) idUsed;

    //Array of listed property IDs
    uint256[] public listedPropertyIds;

    uint256[] public soldProperties;


    constructor() {
        
        moderator = msg.sender;
    }



    modifier onlyOwner() {
        require(msg.sender == moderator, "Not a moderator");
        _;
    }

    modifier isValidID(uint _propertyId) {
        require((idUsed[_propertyId]), "INVALID ID");
        _;
    }



     function listProperty(
        uint256 _propertyId,
        string memory _propertyName,
        string memory _propertyDescription,
        string memory _propertyLocation,
        uint256 _priceInCelo,
        IERC1155 _propertyNft,
        uint256 _propertyNftId
    ) public payable {

        require(msg.value > 5, "Invalid value");
        require(idUsed[_propertyId] == false, "ID already taken");
        idUsed[_propertyId] = true;

        //nftID or propertyID 
        listedPropertyIds.push(_propertyId);
        _propertyNft.safeTransferFrom(
            msg.sender,
            address(this),
            _propertyNftId,
            1,
            "0x0"
        );

        Property memory newProperty = Property({
            forSale: true,
            priceInCELO: _priceInCelo,
            owner: msg.sender,
            name: _propertyName,
            description: _propertyDescription,
            location: _propertyLocation,
            nft: address(_propertyNft),
            nftId: _propertyNftId
        });

        properties[_propertyId] = newProperty;

        emit PropertyListed(_propertyId, _propertyNftId, msg.sender);

    }


    function buyProperty(
        uint256 _propertyId
    ) external isValidID(_propertyId) payable {
        Property storage property = properties[_propertyId];
        require(msg.value >= property.priceInCELO, "Insufficient balance for property purchase");
        require(property.forSale == true, "Property sold out");
        
        address newOwner = msg.sender;

        IERC1155(property.nft).safeTransferFrom(
            address(this),
            newOwner,
            property.nftId,
            1,
            "0x0"
        );

        //send the seller the price for his property.
        payable(property.owner).transfer(property.priceInCELO);
        
        property.forSale = false;
        property.owner = newOwner;



        //Removing the sold property from listed properties

        emit PropertySold(_propertyId, newOwner);
    }


    function withdrawNFT(address _tokenAddress, address _recipientAddress, uint256 _propertyNftId, uint256 _propertyID) external {
        require(_recipientAddress != address(0), "Invalid recipient");
        require(idUsed[_propertyID], "Invalid PropertyID");
        Property storage property = properties[_propertyID];
        require(property.owner == msg.sender, "Not owner!");
        require(property.nftId == _propertyNftId, "Invalid _propertyNftId");
        IERC1155(_tokenAddress).safeTransferFrom(
            address(this),
            _recipientAddress,
            _propertyNftId,
            1,
            "0x0"
        );

        emit OnlyOwnerWithdrawal(msg.sender, _propertyNftId, _recipientAddress, address(_tokenAddress));
    }



    function withdrawCelo(address payable _recipientAddress, uint _amount) external onlyOwner(){
        require(_recipientAddress != address(0), "Invalid address");
        _recipientAddress.transfer(_amount);

    }







    receive() external payable {}



}


