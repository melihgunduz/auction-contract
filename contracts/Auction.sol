// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.2 <0.9.0;


import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract Auction is ReentrancyGuard {

    address public owner;
    address private highestPayer;
    uint256 private highestPayment;
    uint256 public startTime;
    uint256 public stopTime;


    mapping(address => uint256) private payments;

     event RefundLog(address, uint, bool);
     event BidLog(address,uint);
     event OffersClosed(string);


    constructor() {
        owner = msg.sender;
        highestPayment = 0;
        startTime = block.timestamp;
        stopTime = startTime + 30 seconds;
    }

    //checks the caller is only owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call this function");
        _;
    }

    //checks the caller had enough balance (or you can say that, did user made bid before)
    modifier refundTerms() {
        require(block.timestamp > stopTime, "This auction has not end yet");
        require(payments[msg.sender] > 0, "User do not have balance for get refund");
        require(msg.sender != highestPayer, "Highest payer cannot request refund");
        _;
    }

    //user gets refund his payments if he has the criterias
    function refundBid() external refundTerms() payable nonReentrant {
        (bool ok,) = payable(msg.sender).call{value: payments[msg.sender]}("");
        require(ok,"Transaction failed");
        payments[msg.sender] = 0;
        emit RefundLog(msg.sender, payments[msg.sender], ok);
    }

    //user makes pay to the contract
    receive() external payable nonReentrant {
        require(block.timestamp < stopTime, "Payment not accepted now");
        if (block.timestamp >= stopTime) { //checking the time for is auction active
            highestPayment = 0;
            highestPayer = address(0);
            emit OffersClosed("This auction has ended");
        } else {
        payments[msg.sender] += msg.value;
        if (msg.value > highestPayment) { //checking the bid for highest bid
            highestPayment = msg.value;
            highestPayer = msg.sender;
        }
        emit BidLog(msg.sender,msg.value);
        }
    }


}
