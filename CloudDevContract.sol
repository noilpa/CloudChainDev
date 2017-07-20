pragma solidity ^0.4.11;

import "github.com/ethereum/dapp-bin/blob/master/library/iterable_mapping.sol";

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
        mapping (address => Shareholder) users;  // акционеры проекта
    }

    struct Shareholder {
        uint cash;          // сумма внесенная акционером
        uint voicePower;    // сила голоса участника 
        uint status;        // статус: 1 - основатель, 2 - голосующий, 3 - финансист
    }

    ProjectPassport project; // один проект на один блокчейн

    // Занесение паспорта проекта в БЧ
    function CloudDevContract(string _summary, string _description, uint _price, string _dueDate, address _address, uint _cash, uint _status) {

        project.summary = _summary;
        project.description = _description;
        project.dueDate = _dueDate;
        project.price = _price;
        project.minCashPart = _price / 50;      // Коэффициент 0.05 условный
        project.minCashVoting = _price / 10;    // Коэффициент 0.1 условный
        if(_cash >= project.minCashVoting)      // Может быть эту проверку вынести
            AddShareholder(_address, _cash, 1);
        else 
            throw;     
    }

    // Добавление акционера к проекту 
    function AddShareholder(address _address, uint _cash, uint _status) {

        project.users[_address].cash = _cash;
        project.users[_address].status = _status;
        project.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
    }

    function ExtendVoicePower(address _address, uint _cash) {

        project.users[_address].cash = _cash;
        project.users[_address].voicePower = _cash / 100; // формулу для голоса выберем позже
    }

    // Получение статуса проекта: собранная сумма, участники, стоимость проекта, правки
    // Вопрос как венуть mapping? return Shareholder[] 
    /*
    function GetProjectStatus() returns() {

        return (

                );
    }
    */
    
    // Добоваление правок в проект
    function SetEdits(string _edits) {

        project.edits = _edits;
    }

}