pragma solidity ^0.4.11;

contract CloudICO {

    struct ProjectPassport {
        string summary;                         // краткое описание проета
        string description;                     // полное описание проекта
        uint price;                             // цена, за которую работа будет сделана
        uint minCashPart;                       // минимальный порог для финансирования
        uint minCashVoting;                     // минимальный порог для участия в голосовании
        string dueDate;                         // срок выполнения проекта
        bytes32 filesHash;                      // хэш файлов которые приложил 
        mapping (address => Shareholder) users; // акционеры проекта
    }

    struct Shareholder {
        uint cash;      // сумма внесенная акционером
        string name;    // имя/логин акционера, нужно ли?
        uint status;    // статус: 1 - основатель, 2 - голосующий, 3 - финансист
    }

    ProjectPassport project; // один проект на один блокчейн

    // Занесение паспорта проекта в БЧ
    function SetProjectPassport(string _summary, string _description, uint _price, string _dueDate) {
        
    }

    // Добавление акционера к проекту 
    function AddShareholder(address _address, uint _cash, uint _status) {
        
    }

    // Получение статуса проекта: собранная сумма, участники, стоимость проекта, актуальное ТЗ (description?)
    function GetProjectStatus() returns() {

    }


}