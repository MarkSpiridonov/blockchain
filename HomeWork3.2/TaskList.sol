
/**
 3.2. "Список задач"
Структура (см лекцию по типам данных)
- название дела
- время добавления (см helloWorld)
- флаг выполненности дела (bool)
Структуру размещаем в сопоставление int8 => struct (см лекцию по типам данных)
должны быть доступны опции:
- добавить задачу (должен в сопоставление заполняться последовательный целочисленный ключ)
- получить количество открытых задач (возвращает число)
- получить список задач
- получить описание задачи по ключу
- удалить задачу по ключу
- отметить задачу как выполненную по ключу
 */

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract QueueStore {

    struct Task {
        string nameCase;   
        uint32 time;  
        bool   isDoneCase;      
    }

    mapping (uint8 => Task) mapTasks;

    uint8 public mapKey;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();

    }

    modifier checkOwner 
    {
        require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
    }

    // добавить задачу 
    function addTask(string _nameCase) public checkOwner {

        Task tasks = Task(_nameCase, now, false);
        mapKey++;
        mapTasks[mapKey] = tasks;

    }
    // получить количество открытых задач
    function getQtyOpenTasks() public checkOwner returns (uint8){
        uint8 openTasks = 0;
        
        if (!mapTasks.empty())
        {
            for(uint8 counter = 1; counter < mapKey; counter++)
            {
                if (mapTasks[counter].isDoneCase)
                {
                    openTasks++;         
                }
            }
        }
        
        return openTasks;
    }
    // получить список задач
    function getListTasks() public checkOwner returns (string){
        string ret;

        if (!mapTasks.empty())
        {
            for(uint8 counter = 1; counter <= mapKey; counter++)
            {
                ret += "Задача: " + mapTasks[counter].nameCase + "; ";
            }
        }

        return ret;
    }

    //получить описание задачи по ключу
    function getDescriptionTasks(uint8 key) public checkOwner returns (string){
        return mapTasks[key].nameCase;
    }

    //удалить задачу по ключу
    function deleteTask(uint8 key) public checkOwner {
        for (uint8 counter = 1; counter <= mapKey; counter++)
        {
            mapTasks[counter] = mapTasks[counter + 1];
        }
        delete mapTasks[mapKey];
        mapKey--;
    }

    //отметить задачу как выполненную по ключу
    function markOpenTask(uint8 key) public checkOwner {
        mapTasks[key].isDoneCase = true;
    }
}
