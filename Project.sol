pragma solidity ^0.4.10;


struct Project {
        
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
    }

    ProjectPassport private project;

    function CreateProject(string _summary, string _description) public {
        
        project.summary = _summary;
        project.description = _description;
        project.votersNumberCurrent = 0;
    }

    function ApproveProject(string _dueDate, uint _price, uint _votersNumberMax, uint _minCashVoting, uint _minCashPart) public {
        
        project.dueDate = _dueDate;
        project.price = _price;
        project.votersNumberMax = _votersNumberMax;
        project.minCashVoting = _minCashVoting;
        project.minCashPart = _minCashPart;
    }

    function GetProjectStatus() public constant returns (string, string, uint, uint, uint, string, uint, uint) {
        
        return (
            project.summary,
            project.description,
            project.price,
            project.minCashPart,
            project.minCashVoting,
            project.dueDate,
            project.votersNumberMax,
            project.votersNumberCurrent
        )
    }

}