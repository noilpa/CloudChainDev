pragma solidity ^0.4.10;


contract Investor {

    struct User{    
        uint cash;          // сумма внесенная акционером
        uint voicePower;    // сила голоса участника 
        uint8 status;       // статус: 1 - основатель, 2 - голосующий, 3 - финансист
    }

    mapping (address=>User) private MUser;
    address[] private AUser;

    // Инициализация
    function Investor() {
    }
    

    // Проверка адреса на его наличие в проекте
    function CheckUserUnique(address _address) private returns (bool) {
        
        for(uint i=0; i<AUser.length-1; i++) {

            if(AUser[i] == _address) 
                return false;
        }
        return true;
    }


    // Установка роли пользователя
    function SetUserStatus(address _address, uint _votersNumberCurrent, uint _votersNumberMax, uint _minCashVoting) private {
        
        if(_votersNumberCurrent == 0) {

            MUser[_address].status = 1;
        }
        else if(_votersNumberCurrent < _votersNumberMax && MUser[_address].cash >= _minCashVoting) {

            MUser[_address].status = 2;
        }
        else if(_votersNumberCurrent >= _votersNumberMax && MUser[_address].cash >= _minCashVoting) {

            MUser[_address].status = 3;
        }
        else {

            throw;
        }
    }


   // Занесение нового адреса 
    function AddUserAddress(address _address) private {
        
        AUser.length++;
        AUser[AUser.length-1] = _address;
    }    
    

    // Добавление инвестора
    function AddUser(address _address, uint _cash, uint _votersNumberCurrent, uint _votersNumberMax, uint _minCashVoting) public {

        if(CheckUserUnique(_address)) {

            AddUserAddress(_address);
            MUser[_address].cash = _cash;
            MUser[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetUserStatus(_address, _votersNumberCurrent, _votersNumberMax, _minCashVoting);
        }
        else {

            throw;
        }
    }

    // Дополнительные инвестиции
    function AddUserInvestments(address _address, uint _cash,  uint _votersNumberCurrent, uint _votersNumberMax, uint _minCashVoting) public {
        
        if(CheckUserUnique(_address)) {

            throw;
        }
        else {
            
            MUser[_address].cash += _cash;
            MUser[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetUserStatus(_address, _votersNumberCurrent, _votersNumberMax, _minCashVoting);
        }
    }

    // Получить все адреса пользователей
    function GetAllUsers() constant returns (address[]) {
        return AUser;
    }
    
}
