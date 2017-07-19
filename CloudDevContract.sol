pragma solidity ^0.4.11;

contract CloudICO {

    struct ProjectPassport {
        string summary;                                             // краткое описание проета
        string description;                                         // полное описание проекта
        string edits;                                               // описание правок проекта
        uint price;                                                 // цена, за которую работа будет сделана
        uint minCashPart;                                           // минимальный порог для финансирования
        uint minCashVoting;                                         // минимальный порог для участия в голосовании
        string dueDate;                                             // срок выполнения проекта
        bytes32 filesHash;                                          // хэш файлов которые приложил 
        mapping (string => mapping (address => Shareholder)) users;  // акционеры проекта
    }

    struct Shareholder {
        uint cash;      // сумма внесенная акционером
        string name;    // имя/логин акционера, нужно ли?
        uint status;    // статус: 1 - основатель, 2 - голосующий, 3 - финансист
    }

    ProjectPassport project; // один проект на один блокчейн

    // Занесение паспорта проекта в БЧ
    function SetProjectPassport(string _summary, string _description, uint _price, string _dueDate) {

        project.summary = _summary;
        project.description = _description;
        project.dueDate = _dueDate;
        project.price = _price;
        project.minCashPart = _price * 0.05;    // Коэффициент 0.05 условный
        project.minCashVoting = _price * 0.1;   // Коэффициент 0.1 условный
    }

    // Добавление акционера к проекту 
    function AddShareholder(string _user, address _address, uint _cash, uint _status) {

        project.users[_user][_address].cash = _cash;
        project.users[_user][_address].status = _status;
    }

    // Получение статуса проекта: собранная сумма, участники, стоимость проекта, правки
    // Вопрос как венуть mapping?
    function GetProjectStatus() returns() {

        return (

                );
    }

    // Добоваление правок в проект
    function SetEdits(string _edits) {

        project.edits = _edits;
    }

}