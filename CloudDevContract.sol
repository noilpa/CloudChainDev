pragma solidity ^0.4.10;


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
        uint votersNumberMax;                    // максимальное число голосующих в проекте
        uint votersNumberCurrent;                // текущее число голосующих в проекте
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
    // test data string: "sum", "descr", 100, "17.10.1994", "0xa28b9f0cf273e0aef6db14ce13c0979e03c0c20d", 40, 2
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

    // Занесение нового адреса 
    function AddUserAddress(address _address) {
        
        project.usersKey.length++;
        project.usersKey[project.usersKey.length-1] = _address;
    }

    // Добавление акционера к проекту 
    function AddShareholder(address _address, uint _cash) {

        if(CheckUserUnique(_address)) {

            AddUserAddress(_address);
            project.users[_address].cash = _cash;
            project.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetStatus(_address);
        }
        else {

            throw;
        }
    }

    // Установление статуса акционеру
    function SetStatus(address _address) {
        
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

            throw;
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

            throw;
        }
        else {
            
            project.users[_address].cash += _cash;
            project.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetStatus(_address);
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

    function GetAllAddresses() returns (address[]) {

        return project.usersKey;
    }

    function GetUser(address _address) returns (uint, uint, uint) {

        return (
            project.users[_address].cash,
            project.users[_address].voicePower,
            project.users[_address].status
        );
    }


    // Получение статуса проекта: собранная сумма, участники, стоимость проекта, правки
    function GetProjectStatus() constant returns(address[] , string, string, string, uint, uint, uint) {

        uint sum = 0; //Сколько собрали

        for (uint i=0; i<project.usersKey.length-1; i++ ) {
            sum += project.users[project.usersKey[i]].cash; 
        }
        return (project.usersKey,
                project.summary,
                project.description,
                project.dueDate,
                project.price,
                project.votersNumberMax,
                sum
                );
            
}

    // Добоваление правок в проект
    function SetEdits(string _edits) {
        project.edits = _edits;
    }
    
}