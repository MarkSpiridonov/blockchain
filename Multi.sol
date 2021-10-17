//2.1. Написать смарт-контракт и задеплоить его локально. Суть контракта:
//-контракт должен хранить произведение чисел. Изначально инициализирован единицей.
//-Иметь функцию "умножить".  Функция очевидно должна умножать сохраненное число на переданный в нее параметр.
//-Дополнительным моментом является то, что функция должна умножать только на числа от 1 до 10 включительно. В противном случае прерывать выполнение. Используем require

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Multiplication {

	uint public prod = 1;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		_;
	}

	function add(uint value) public checkOwnerAndAccept {
        	require(value >= 1 && value <= 10, 103, "Number from 1 to 10.");
        	tvm.accept();
		prod *= value;
	}
}
