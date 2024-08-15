use starknet::{
    get_caller_address, contract_address_const, ContractAddress, get_contract_address, Into
};
use array::{ArrayTrait, SpanTrait};

use debug::PrintTrait;

use token_sender::erc20::erc20::{IERC20, IERC20Dispatcher, IERC20DispatcherTrait};

/// TransferRequest struct
#[derive(Drop, Serde, Copy)]
struct TransferRequest {
    /// Recipient address
    recipient: ContractAddress,
    /// Amount to transfer
    amount: u256,
}

#[starknet::interface]
trait ITokenSender<TContractState> {
    /// Multisend function
    /// # Arguments
    /// - `token_address` - The address of the token contract
    /// - `transfer_list` - The list of transfers to perform
    fn multisend(
        self: @TContractState, token_address: ContractAddress, transfer_list: Array<TransferRequest>
    ) -> ();
}

#[starknet::contract]
mod TokenSender {
    use starknet::{
        get_caller_address, contract_address_const, ContractAddress, get_contract_address, Into
    };

    use zeroable::Zeroable;
    use array::{ArrayTrait, SpanTrait};

    use token_sender::erc20::erc20::{IERC20, IERC20Dispatcher, IERC20DispatcherTrait};

    use debug::PrintTrait;

    use super::TransferRequest;


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TokensSent: TokensSent,
    }
    #[derive(Drop, starknet::Event)]
    struct TokensSent {
        token_address: ContractAddress,
        recipients: felt252,
    }


    #[constructor]
    fn constructor(ref self: ContractState,) {}

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl TokenSender of super::ITokenSender<ContractState> {
        fn multisend(
            self: @ContractState,
            token_address: ContractAddress,
            transfer_list: Array<TransferRequest>
        ) {
            let erc20 = IERC20Dispatcher { contract_address: token_address };

            let mut total_amount: u256 = 0;

            for t in transfer_list.span() {
                total_amount += *t.amount;
            };

            erc20.transfer_from(get_caller_address(), get_contract_address(), total_amount);

            for t in transfer_list.span() {
                erc20.transfer(*t.recipient, *t.amount);
            };
        }
    }
}
