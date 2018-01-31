pragma solidity ^0.4.16;

contract Donating {
    struct Donation {
        uint id;
        string title;
        string description;
        uint needToCollect;
        address walletAuthor;
        address walletReceiver;
        uint begin;
        uint end;
        bool isActive;
    }

    uint currId = 1;    
    mapping(uint => Donation) public donations;
    mapping(uint => mapping(address => uint)) public donates;

    function createDonation(string title, string description, uint needToCollect, 
        address walletReceiver, uint begin, uint end) 
    public
    returns (uint) {
        uint id = currId++;
        Donation storage donation = donations[id];
        donation.id = id;
        donation.title = title;
        donation.description = description;
        donation.needToCollect = needToCollect;
        donation.walletAuthor = msg.sender;
        donation.walletReceiver = walletReceiver;
        donation.begin = begin;        
        donation.end = end;
        donation.isActive = true;

        return id;
    }

    function donate(uint donationId, uint currTime)
    payable
    public {
        require(donations[donationId].id != 0);
        require(donations[donationId].isActive);
        require(donations[donationId].end >= currTime);
        require(msg.sender.balance >= msg.value);
        donates[donationId][msg.sender] += msg.value;
        if (this.balance >= donations[donationId].needToCollect) {
            donations[donationId].isActive = false;
            donations[donationId].walletReceiver.transfer(this.balance);
        }
    }
}