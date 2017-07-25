/*
 * 
 *
 *
 */

pragma solidity ^0.4.10;

import "CloudDevLibrary.sol";

contract CloudDevContract {

    CloudProject.ProjectPassport project;

    function CloudDevContract(string _summary, string _description, uint _price, string _dueDate, address _address, uint _cash, uint _votersNumberMax) {

        project.CreateCloudProject( _summary, _description, _price, _dueDate, _address, _cash, _votersNumberMax);    
    }

    function AddInvestor(address _address, uint _cash) {

        project.AddShareholder(_address, _cash);
    }

    function AddInvestments(address _address, uint _cash) {

        project.AddShareholderInvestments(_address, _cash);
    }

    function GetProjectStatus() constant returns (address[] , string, string, string, uint, uint, uint) {
        
        return project.GetProjectStatus();
    }

    function GetInvestor(address _address) constant returns(uint, uint, uint) {

        return project.GetUser(_address);
    }

    function GetAllInvestorsAddress() constant returns(address[]) {
        
        return project.GetAllAddresses(); 
    }


}