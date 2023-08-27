# A Property Acquisition smart contract on Celo.

---

## Introduction

In blockchain technology, the usage of smart contracts has revolutionized various industries, including real estate. This article delves into the creation and implementation of a Property Acquisition Smart Contract on the Celo blockchain. We'll explore the contract's architecture, its features, and its application in facilitating property transactions.

<br>
This article also featured, a breakdown of the technical procedure required for deploying the smart contract and demonstration of the interaction


## Table of Contents

- [Property Acquisition smart contract on Celo](#Property-Acquisition-smart-contract-on-Celo)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Objective](#objective)
  - [Prerequisites](#prerequisites)
  - [Requirements](#requirements)
  - [Understanding Property Acquisition](#Understanding-Property-Acquisition)
    - [Benefits of Smart Contracts](#Benefits-of-Smart-Contracts)
    - [What is ERC1155?, And Why?](#What-is-ERC1155-?-And-Why?)
  - [Tutorial](#tutorial)
    - [STEP 1 - Set up Foundry Environment](#step-1---setup-foundry-environment)
    - [STEP 2 - Create your Smart contracts](#step-2---create-your-smart-contracts)
      - [ERC1155 Contract Explained](#ERC1155-Contract-contract-explained)
      - [Property Acquisition Contract Explained](#Property-Acquisition-contract-explained)
    - [STEP 3 - Deploying your contracts](#step-3---deploying-your-contracts)
    - [STEP 4 - Verifying your contracts](#step-4---verifying-your-contracts)
    - [STEP 5 - Interacting with the deployed contracts](#step-5---interacting-with-the-deployed-contracts)

    - [Conclusion](#conclusion)


    ## Objective
    This article aims to guide you through the process of creating and deploying a Property Acquisition Smart Contract on the Celo blockchain. By the end of this guide, you will have a solid understanding of how to utilize smart contracts for property transactions.


    ## Prerequisites

    - Understanding of Solidity: It is important to have a strong understanding of Solidity as it is the main programming language for creating smart contracts on Celo blockchain. solidity documentation.

    - Foundry: It is important to learn how to use Foundry, a tool that helps you write, test, and put your smart contracts on the Celo blockchain. FoundryBook.

    - Celo blockchain - Celo focus lies in fostering financial inclusion by enabling secure, fast, and low-cost transactions and smart contracts. Documentation.

    ## Requirements

    - Development Environment:

        Remix, VScode, and Truffle are some of the tools that can be used to write,test and deploy smart contracts on Celo. In this article, we will make use of; 

        Visual Studio Code (VS Code) with Solidity Extensions: A popular code editor with extensions that provide Solidity syntax highlighting, debugging, and more.

    - Ethereum Wallet and Testnets:

        MetaMask: A browser extension wallet that lets you interact with Ethereum-based applications and deploy contracts to testnets.

        Alfajores testnet: Celo testnet network where you can deploy and test your contracts without using real Ether.

    - Package Manager:
        node.js v10 or higher.

        npm (Node Package Manager): Often used to manage dependencies and packages for your development environment.

    - Blockchain Explorer:

        Alfajores Etherscan: A platform to explore and verify transactions, contracts, and addresses on the Celo testnet blockchain.


    ## Understanding Property Acquisition

    A Property Acquisition Smart Contract simplifies the process of purchasing real estate assets using blockchain technology. This contract automates and secures property transactions, offering various advantages to both buyers and sellers.


    ## Benefits of Smart Contracts

    Using smart contracts for property acquisition makes the process of buying property transparent, safe, and faster. Transactions happen according to rules set beforehand, reducing the need for intermediaries, the acquisition process happens smoothly and quickly.


    ## Tutorial
    Let us delve into the step-by-step tutorial for creating a Property Acquisition Smart Contract on the Celo blockchain.
    ### STEP 1 - Set up Foundry Environment

    To begin setting up the Foundry environment for your smart contract implementation, you will first need to create a new folder on your system. You can do this by using the ‘mkdir’ command in your terminal followed by the desired name of your folder. For example:

    ```
    mkdir property-acquistion
    ```

    Next, navigate to your project folder using the ‘cd’ command, like below:

    ```
    cd  property-acquistion
    ```

    Once you have cd into the folder, you can initialize a new foundry project inside it by running the following command:

    ```
    forge init 
    ```

    This will initialize foundry in your project folder with default settings, creating some default configuration files and folders required for building and testing smart contracts.

    Finally, open your project folder in VScode by running this command in your terminal:

    ```
    code .
    ```

    This will open up your project folder in Visual Studio Code, where you can start setting up your Foundry environment and writing your smart contract code.
    <br/>

    ### STEP 2 - Create your Smart Contracts

    In the root directory of your project, you'll find a folder called "contracts". To create a new TypeScript file, simply navigate to this folder and add your new files.
    <br/>

    For this tutorial, we'll be writing an ERC1155 Property Acquisition Contract. To create this contracts, we'll need to generate two files:

    - tradeAsset contract file
    - property contract file



    #### ERC1155 Token Contract Explained

    The PropertyAcquisition contract manages property transactions by automating the acquisition process. It includes functions for listing properties, acquiring properties, and more.

    ```solidity
    // SPDX-License-Identifier: MIT
        pragma solidity ^0.8.9;

        import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

        import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

        contract Assets is ERC1155, Ownable {
            constructor() ERC1155("") {}

            function setURI(string memory newuri) public onlyOwner {
                _setURI(newuri);
            }

            function mint(address account, uint256 id, uint256 amount)
                public
                onlyOwner
            {
                bytes memory _data = new bytes(4);
                _data[0] = 0x48;
                _data[1] = 0x65;
                _data[2] = 0x6C;
                _data[3] = 0x6C;
                
                _mint(account, id, amount, _data);
            }
        }
    
    ```


    #### Property Acquisition Contract Explained

    We will create the PropertyAcquisition smart contract, which enables property acquisitions using CELO tokens.

    ```solidity
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
            address _propertyNft,
            uint256 _propertyNftId
        ) public payable {

            require(msg.value >= 5000 gwei , "Invalid value");
            require(idUsed[_propertyId] == false, "ID already taken");
            idUsed[_propertyId] = true;

            //nftID or propertyID 
            listedPropertyIds.push(_propertyId);
            IERC1155(_propertyNft).safeTransferFrom(
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
            require(msg.value >= property.priceInCELO, "Insufficient amount for property purchase");
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



            

            emit PropertySold(_propertyId, newOwner);
        }

        function withdrawNFT(address _tokenAddress, address _recipientAddress, uint256 _propertyNftId, uint256 _propertyID) external {
            require(_recipientAddress != address(0), "Invalid recipient");
            require(idUsed[_propertyID], "Invalid PropertyID");
            Property storage property = properties[_propertyID];
            require(property.forSale == false, "Property for sale");
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

        function withdrawCelo(address _recipientAddress, uint _amount) external onlyOwner(){
            require(_recipientAddress != address(0), "Invalid address");
            payable(_recipientAddress).transfer(_amount);

        }

        receive() external payable {}

    }
    ```

    #### Contract Overview

    - The tradeAsset contract inherits from ERC1155Holder, which is part of the OpenZeppelin's ERC1155 library. This contract includes the following features:

        - Listing properties for sale.
        - Buying properties.
        - Withdrawing NFTs and CELO tokens.
        - Ownership management.
        - Event logging for key actions.

    - Structs (Property): The Property struct represents a listed property. It contains the following fields:

        - forSale: A boolean indicating if the property is for sale.
        - owner: The address of the current owner.
        - name: The name of the property.
        - nft: The address of the associated ERC-1155 NFT contract.
        - nftId: The ID of the associated NFT.
        - description: A description of the property.
        - location: The location of the property.
        - priceInCELO: The price of the property in CELO tokens.


    - Events: The contract emits several events to provide transparency and facilitate monitoring:

        - PropertyListed: Logged when a property is listed for sale.
        - PropertySold: Logged when a property is sold.
        - OnlyOwnerWithdrawal: Logged when the owner withdraws NFTs and CELO tokens.

    - Modifiers: The contract includes two modifiers:

        - onlyOwner: Restricts certain functions to be executed only by the contract - owner (moderator).
        - isValidID: Ensures that the provided property ID is valid.

    - Functions: The tradeAsset contract provides the following functions:

        - listProperty: Allows property owners to list properties for sale.
        - buyProperty: Enables buyers to purchase properties.
        - withdrawNFT: Allows property owners to withdraw NFTs associated with their  properties.
        - withdrawCelo: Allows the contract owner to withdraw CELO tokens.







