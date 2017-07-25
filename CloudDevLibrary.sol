CloudDevLibrary CloudProject {

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
    
    function CreateCloudProject(ProjectPassport storage self, string _summary, string _description, uint _price, string _dueDate, address _address, uint _cash, uint _votersNumberMax) {

        self.summary = _summary;
        self.description = _description;
        self.dueDate = _dueDate;
        self.price = _price;
        self.minCashPart = _price / 50;      // Коэффициент 0.05 условный
        self.minCashVoting = _price / 10;    // Коэффициент 0.1 условный
        self.votersNumberMax = _votersNumberMax;
        self.votersNumberCurrent = 0;
        AddShareholder(self, _address, _cash);
     
    }

    // Занесение нового адреса 
    function AddUserAddress(ProjectPassport storage self, address _address) private {
        
        self.usersKey.length++;
        self.usersKey[self.usersKey.length-1] = _address;
    }    

    // Установление статуса акционеру
    function SetStatus(ProjectPassport storage self, address _address) private {
        
        if(self.votersNumberCurrent == 0) {

            self.users[_address].status = 1;
        }
        else if(self.votersNumberCurrent < self.votersNumberMax && self.users[_address].cash >= self.minCashVoting) {

            self.users[_address].status = 2;
        }
        else if(self.votersNumberCurrent >= self.votersNumberMax && self.users[_address].cash >= self.minCashVoting) {

            self.users[_address].status = 3;
        }
        else {

            throw;
        }
    }

    // Проверка адреса на его наличие в проекте
    function CheckUserUnique(ProjectPassport storage self, address _address) private returns (bool) {
        
        for(uint i=0; i<self.usersKey.length-1; i++) {

            if(self.usersKey[i] == _address) 
                return false;
        }
        return true;
    }

    // Добавление акционера к проекту
    function AddShareholder(ProjectPassport storage self, address _address, uint _cash) {

        if(CheckUserUnique(self, _address)) {

            AddUserAddress(self, _address);
            self.users[_address].cash = _cash;
            self.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetStatus(self, _address);
        }
        else {

            throw;
        }
    }

    // Совершение дополнительной инвестиции акционером
    // _cash - дополнительная инветиция 
    // _address - акционер
    function AddShareholderInvestments(ProjectPassport storage self, address _address, uint _cash) {

        if(CheckUserUnique(self, _address)) {

            throw;
        }
        else {
            
            self.users[_address].cash += _cash;
            self.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
            SetStatus(self, _address);
        }
    }

    function GetAllAddresses(ProjectPassport storage self) constant returns (address[]) {

        return self.usersKey;
    }

    function GetUser(ProjectPassport storage self, address _address) constant returns (uint, uint, uint) {

        return (
            self.users[_address].cash,
            self.users[_address].voicePower,
            self.users[_address].status
        );
    }

    // Получение статуса проекта: собранная сумма, участники, стоимость проекта, правки
    function GetProjectStatus(ProjectPassport storage self) constant returns(address[] , string, string, string, uint, uint, uint) {

        uint sum = 0; //Сколько собрали

        for (uint i=0; i<self.usersKey.length-1; i++ ) {
            sum += self.users[self.usersKey[i]].cash; 
        }
        return (self.usersKey,
                self.summary,
                self.description,
                self.dueDate,
                self.price,
                self.votersNumberMax,
                sum
                );
            
    }

    // Добоваление правок в проект
    function SetEdits(ProjectPassport storage self, string _edits) {
        self.edits = _edits;
    }
    

}