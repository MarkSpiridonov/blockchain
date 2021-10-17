//3.1. "Очередь в магазине"
//Хранилище данных - массив строк (Где строки имена людей, которые встают в очередь).
//Должны быть доступны опции:
//встать в очередь (переданное имя встает в конец очереди - в конец массива)
//вызвать следующего (первый из очереди уходит - нулевой элемент массива пропадает)

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract QueueStore {

    string[] public queue;

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

    function addQueue(string s) public checkOwner {
        queue.push(s);
    }

    function callNext() public checkOwner {

        for (uint counter = 0; counter < queue.length - 1; counter++)
        {
            queue[counter] = queue[counter+1];
        }
        delete queue[queue.length - 1];
    }
}
