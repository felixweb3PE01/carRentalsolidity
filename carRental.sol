// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;


error Insufficientfund();
error Rented();
error UnauthorizedAccess();
error PriceNotAdded();

contract carRental {

    uint256 public balance ;
    address owner;
    bool public  isrented ;
    uint256 public immutable  rentalprice;
    address [] renters;
    address currentRenter;

    constructor(uint256 _rentalprice)payable{
        owner = msg.sender;
        rentalprice= _rentalprice;
        if(_rentalprice == 0){
            revert PriceNotAdded();
        }
        balance = msg.value;
    }

    function rentalAddressbook() public view returns (address[] memory) {
        return renters;

    }

    

    function rentCar() public payable  returns(string memory){
        if(msg.value < rentalprice){
            revert Insufficientfund();
        }
        if(isrented==true){
            revert Rented();
        }
        isrented = true;
        renters.push(msg.sender);
        currentRenter = msg.sender;

        return string( "Car Rental Succesful");

    }
    function returnCar()public {
        if (currentRenter != msg.sender){
            revert UnauthorizedAccess();
        }
        isrented = false;
    }

    function withdraw()public restrict{
        (bool callSuccess, ) =payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send Failed");
    }

    modifier restrict(){
         if(msg.sender != owner){
            revert UnauthorizedAccess();
        }
        _;
    }

    }
