use cheatcodes::PreparedContract;
use starknet::{
    contract_address_const, get_block_info, ContractAddress, Felt252TryIntoContractAddress, TryInto,
    Into, OptionTrait, class_hash::Felt252TryIntoClassHash, get_caller_address,
    get_contract_address,
};
use starknet::storage_read_syscall;
// use token_sender::tests::test_utils::{assert_eq};

use array::{ArrayTrait, SpanTrait, ArrayTCloneImpl};
use result::ResultTrait;
use serde::Serde;

use box::BoxTrait;
use integer::u256;

use token_sender::erc20::mock_erc20::MockERC20;
use token_sender::erc20::mock_erc20::MockERC20::{Event, Transfer};
use token_sender::erc20::erc20::{IERC20Dispatcher, IERC20DispatcherTrait};

const NAME: felt252 = 111;
const SYMBOL: felt252 = 222;


fn setup() -> ContractAddress {
    let class_hash = declare('MockERC20');
    // let account: ContractAddress = get_contract_address();

    let account: ContractAddress = contract_address_const::<1>();
    // let account: ContractAddress = get_contract_address();
    let INITIAL_SUPPLY: u256 = 1000000000;

    let mut calldata = ArrayTrait::new();
    NAME.serialize(ref calldata);
    SYMBOL.serialize(ref calldata);
    18.serialize(ref calldata);
    INITIAL_SUPPLY.serialize(ref calldata);
    account.serialize(ref calldata);

    let prepared = PreparedContract { class_hash: class_hash, constructor_calldata: @calldata };
    let contract_address = deploy(prepared).unwrap();

    contract_address
}

#[test]
fn test_get_balance() {
    let contract_address = setup();
    let erc20 = IERC20Dispatcher { contract_address };

    let INITIAL_SUPPLY: u256 = 1000000000;
    let account: ContractAddress = contract_address_const::<1>();
    // let account: ContractAddress = get_contract_address();

    assert(erc20.balance_of(account) == INITIAL_SUPPLY, 'Balance should be > 0');
}

#[test]
fn test_transfer() {
    let contract_address = setup();
    let erc20 = IERC20Dispatcher { contract_address };

    let target_account: ContractAddress = contract_address_const::<2>();

    let balance_before = erc20.balance_of(target_account);
    assert(balance_before == 0, 'Invalid balance');

    start_prank(contract_address, 1.try_into().unwrap());

    let transfer_value: u256 = 100;
    erc20.transfer(target_account, transfer_value);

    let balance_after = erc20.balance_of(target_account);
    assert(balance_after == transfer_value, 'No value transfered');
}

#[test]
#[should_panic(expected: ('u256_sub Overflow', ''))]
fn test_should_panic_transfer() {
    let contract_address = setup();
    let erc20 = IERC20Dispatcher { contract_address };

    let target_account: ContractAddress = contract_address_const::<2>();

    let balance_before = erc20.balance_of(target_account);
    assert(balance_before == 0, 'Invalid balance');

    start_prank(contract_address, 1.try_into().unwrap());

    let transfer_value: u256 = 1000000001;

    erc20.transfer(target_account, transfer_value);
}

