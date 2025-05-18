use core::num::traits::Pow;
use openzeppelin_token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
use snforge_std::{
    CheatSpan, ContractClassTrait, DeclareResultTrait, EventSpyAssertionsTrait,
    cheat_caller_address, declare, spy_events,
};
use starknet::ContractAddress;
use token_sender::token_sender::{
    ITokenSenderDispatcher, ITokenSenderDispatcherTrait, TokenSender, TransferRequest,
};

const account: ContractAddress = 1.try_into().unwrap();
const dest1: ContractAddress = 2.try_into().unwrap();
const dest2: ContractAddress = 3.try_into().unwrap();

const INITIAL_SUPPLY: u256 = 10_u256.pow(9);

fn setup() -> (ContractAddress, ContractAddress) {
    let erc20_class_hash = declare("MockERC20").unwrap().contract_class();

    let mut calldata = ArrayTrait::new();
    INITIAL_SUPPLY.serialize(ref calldata);
    account.serialize(ref calldata);

    let (erc20_address, _) = erc20_class_hash.deploy(@calldata).unwrap();

    let token_sender_class_hash = declare("TokenSender").unwrap().contract_class();

    let mut calldata = ArrayTrait::new();

    let (token_sender_address, _) = token_sender_class_hash.deploy(@calldata).unwrap();

    (erc20_address, token_sender_address)
}

#[test]
fn test_single_send() {
    let (erc20_address, token_sender_address) = setup();
    let erc20 = ERC20ABIDispatcher { contract_address: erc20_address };

    assert!(erc20.balance_of(account) == INITIAL_SUPPLY, "Balance should be > 0");

    cheat_caller_address(erc20_address, account, CheatSpan::TargetCalls(1));

    let transfer_value: u256 = 100;
    erc20.approve(token_sender_address, transfer_value * 2);

    assert!(
        erc20.allowance(account, token_sender_address) == transfer_value * 2, "Allowance not set",
    );

    let balance_before = erc20.balance_of(account);
    println!("Balance {}", balance_before);

    // Send tokens via multisend
    let token_sender = ITokenSenderDispatcher { contract_address: token_sender_address };
    let request1 = TransferRequest { recipient: dest1, amount: transfer_value };

    let mut transfer_list = ArrayTrait::<TransferRequest>::new();
    transfer_list.append(request1);

    // need to also prang the token sender
    cheat_caller_address(token_sender_address, account, CheatSpan::TargetCalls(1));
    token_sender.multisend(erc20_address, transfer_list);

    let balance_after = erc20.balance_of(dest1);
    assert!(balance_after == transfer_value, "Balance should be > 0");
}

#[test]
#[fuzzer]
fn test_single_send_fuzz(transfer_value: u256) {
    let (erc20_address, token_sender_address) = setup();
    let erc20 = ERC20ABIDispatcher { contract_address: erc20_address };

    assert!(erc20.balance_of(account) == INITIAL_SUPPLY, "Balance should be > 0");

    cheat_caller_address(erc20_address, account, CheatSpan::TargetCalls(1));

    let transfer_value: u256 = 100;
    erc20.approve(token_sender_address, transfer_value * 2);

    assert!(
        erc20.allowance(account, token_sender_address) == transfer_value * 2, "Allowance not set",
    );

    // Send tokens via multisend
    let token_sender = ITokenSenderDispatcher { contract_address: token_sender_address };
    let request1 = TransferRequest { recipient: dest1, amount: transfer_value };

    let mut transfer_list = ArrayTrait::<TransferRequest>::new();
    transfer_list.append(request1);

    let mut spy = spy_events();

    // need to also prang the token sender
    cheat_caller_address(token_sender_address, account, CheatSpan::TargetCalls(1));
    token_sender.multisend(erc20_address, transfer_list);

    spy
        .assert_emitted(
            @array![
                (
                    token_sender_address,
                    TokenSender::Event::TokensSent(
                        TokenSender::TokensSent {
                            recipient: dest1, token_address: erc20_address, amount: transfer_value,
                        },
                    ),
                ),
            ],
        );

    let balance_after = erc20.balance_of(dest1);
    assert!(balance_after == transfer_value, "Balance should be > 0");
}

#[test]
fn test_multisend() {
    let (erc20_address, token_sender_address) = setup();
    let erc20 = ERC20ABIDispatcher { contract_address: erc20_address };

    assert!(erc20.balance_of(account) == INITIAL_SUPPLY, "Balance should be > 0");

    cheat_caller_address(erc20_address, account, CheatSpan::TargetCalls(1));

    let transfer_value: u256 = 100;
    erc20.approve(token_sender_address, transfer_value * 2);

    assert!(
        erc20.allowance(account, token_sender_address) == transfer_value * 2, "Allowance not set",
    );

    let balance = erc20.balance_of(account);
    println!("Balance {}", balance);

    // Send tokens via multisend
    let token_sender = ITokenSenderDispatcher { contract_address: token_sender_address };
    let request1 = TransferRequest { recipient: dest1, amount: transfer_value };
    let request2 = TransferRequest { recipient: dest2, amount: transfer_value };

    let mut transfer_list = ArrayTrait::<TransferRequest>::new();
    transfer_list.append(request1);
    transfer_list.append(request2);

    // need to also cheat the token sender
    cheat_caller_address(token_sender_address, account, CheatSpan::TargetCalls(1));
    token_sender.multisend(erc20_address, transfer_list);
    let balance_after = erc20.balance_of(dest1);
    assert!(balance_after == transfer_value, "Balance should be > 0");
    let balance_after = erc20.balance_of(dest2);
    assert!(balance_after == transfer_value, "Balance should be > 0");
}

