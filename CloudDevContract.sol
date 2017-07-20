pragma solidity ^0.4.11;

//import "https://github.com/ethereum/dapp-bin/library/iterable_mapping.sol"; // пока не нужно

contract CloudDevContract {

    struct ProjectPassport {
        string summary;                          // краткое описание проета
        string description;                      // полное описание проекта
        string edits;                            // описание правок проекта
        uint price;                              // цена, за которую работа будет сделана
        uint minCashPart;                        // минимальный порог для финансирования
        uint minCashVoting;                      // минимальный порог для участия в голосовании
        string dueDate;                          // срок выполнения проекта
        bytes32 filesHash;                       // хэш файлов которые приложил
        uint votersNumberMax;                    // максимальное число голосующих
        uint votersNumberCurrent;                // текущее число голосующих
        address[] usersKey;                      // массив уникальных адресов
        mapping (address => Shareholder) users;  // акционеры проекта
    }

    struct Shareholder {
        uint cash;          // сумма внесенная акционером
        uint voicePower;    // сила голоса участника 
        uint status;        // статус: 1 - основатель, 2 - голосующий, 3 - финансист
    }

    ProjectPassport project; // один проект на один блокчейн

    // Занесение паспорта проекта в БЧ
    // На этапе создания БЧ основатель согласился внести требуемую сумму
    // test: 
    function CloudDevContract(string _summary, string _description, uint _price, string _dueDate, address _address, uint _cash, uint _votersNumberMax) {

        project.summary = _summary;
        project.description = _description;
        project.dueDate = _dueDate;
        project.price = _price;
        project.minCashPart = _price / 50;      // Коэффициент 0.05 условный
        project.minCashVoting = _price / 10;    // Коэффициент 0.1 условный
        project.votersNumberMax = _votersNumberMax;
        project.votersNumberCurrent = 0;
        AddShareholder(_address, _cash);
     
    }

    // Добавление акционера к проекту 
    function AddShareholder(address _address, uint _cash) {

        if(CheckUserUnique(_address)) {
        
            throw;
        }
        else {

            project.users[_address].cash = _cash;
            project.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetStatus(_address, _cash);
        }
    }

    function SetStatus(address _address, uint _cash) {
        
        if(project.votersNumberCurrent == 0) {

            project.users[_address].status = 1;
        }
        else if(project.votersNumberCurrent < project.votersNumberMax && project.users[_address].cash >= project.minCashVoting) {

            project.users[_address].status = 2;
        }
        else if(project.votersNumberCurrent >= project.votersNumberMax && project.users[_address].cash >= project.minCashVoting) {

            project.users[_address].status = 3;
        }
        else if(project.users[_address].cash < project.minCashVoting) {

            project.users[_address].status = 3;
        }
        else {

            throw;
        }
    }

    // Совершение дополнительной инвестиции акционером
    // _cash - дополнительная инветиция 
    // _address - акционер
    function AddShareholderInvestments(address _address, uint _cash) {

        if(CheckUserUnique(_address)) {

            project.users[_address].cash += _cash;
            project.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetStatus(_address, project.users[_address].cash);
        }
        else {

            throw;
        }
    }

    // Проверка адреса на его наличие в проекте
    function CheckUserUnique(address _address) returns (bool) {
        
        for(uint i=0; i<project.usersKey.length-1; i++) {

            if(project.usersKey[i] == _address) 
                return false;
        }
        return true;
    }


    // Получение статуса проекта: собранная сумма, участники, стоимость проекта, правки
    // Вопрос как венуть mapping? return Shareholder[] 
    /*
    function GetProjectStatus() returns() {

        return (

                );
    }

    // Добоваление правок в проект
    function SetEdits(string _edits) {
        project.edits = _edits;
    }
    */
}