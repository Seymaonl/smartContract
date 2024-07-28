// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EscrowService {
    address public buyer;
    address public seller;
    uint256 public amount;
    bool public isDelivered;
    bool public isRefunded;

    constructor(address _seller) {
        buyer = msg.sender;
        seller = _seller;
        isDelivered = false;
        isRefunded = false;
    }

    // Ödemeyi akıllı sözleşmeye yatır
    function depositPayment() public payable {
        require(msg.sender == buyer, "Only the buyer can make a payment");
        require(msg.value > 0, "Payment must be greater than zero.");
        amount = msg.value;
    }

    // Teslimatı onayla ve ödemeyi satıcıya aktar
    function confirmDelivery() public {
        require(msg.sender == buyer, "Only the buyer can confirm delivery.");
        require(amount > 0, "No payment to transfer.");
        require(!isDelivered, "Delivery already confirmed.");
        
        isDelivered = true;
        payable(seller).transfer(amount);
    }

    // Ödemeyi iade et
    function refundPayment() public {
        require(msg.sender == buyer, "Only the buyer can request a refund.");
        require(amount > 0, "No payment to refund.");
        require(!isDelivered, "Delivery already confirmed.");
        require(!isRefunded, "Payment already refunded.");
        
        isRefunded = true;
        payable(buyer).transfer(amount);
    }

    // Sözleşme bakiyesini kontrol et
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
