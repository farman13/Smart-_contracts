// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Event{

    struct events{
      address organiser;
      string NameofEvent;
      uint date;
      string location;
      string imgLink;
      uint price;
      uint TotalTickets;
      uint TicketsRemain;
    }

    mapping (uint=>events) public  EventsAccess;
    uint public nextid;
    mapping (address=> mapping(uint=>uint)) public BuyerticketsDetails;

    function CreateEvent(string memory name, uint date ,string memory location,string memory imgLink,uint price , uint TotalTickets) external {
        require(date > block.timestamp);
        require(TotalTickets>0);
       EventsAccess[nextid] = events(msg.sender , name , date ,location,imgLink,price , TotalTickets,TotalTickets); 
       nextid++;
       
    }

    function BuyTickets(uint eventid , uint ticketQuantity) payable external {
        
        events storage _event = EventsAccess[eventid];
        require(_event.date!=0);
        require(ticketQuantity < _event.TotalTickets);
        require(msg.value == _event.price * ticketQuantity);
        require(_event.date > block.timestamp);
        require(ticketQuantity < _event.TicketsRemain);
        BuyerticketsDetails[msg.sender][eventid] += ticketQuantity;
        _event.TicketsRemain -= ticketQuantity; 

    }
   
    function TransferTIckets( uint eventid ,address To , uint ticketQuantity) public {
        events storage _event = EventsAccess[eventid];
        require(_event.date!=0);
        require(ticketQuantity <= BuyerticketsDetails[msg.sender][eventid]);
        require(_event.date > block.timestamp);
       
       BuyerticketsDetails[msg.sender][eventid]-=ticketQuantity;
       BuyerticketsDetails[To][eventid]+=ticketQuantity;
    }
}