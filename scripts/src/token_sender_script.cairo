use sncast_std::{
    declare, deploy, invoke, call, DeclareResult, DeployResult, InvokeResult, CallResult, get_nonce
};
use debug::PrintTrait;

fn main() {
    let max_fee = 2000000000000000;
    let salt = 0x4;

    let declare_result = declare('TokenSender', Option::Some(max_fee), Option::None);

    let nonce = get_nonce('pending');
    let class_hash = declare_result.class_hash;
    let deploy_result = deploy(
        class_hash,
        ArrayTrait::new(),
        Option::Some(salt),
        true,
        Option::Some(max_fee),
        Option::Some(nonce)
    );

    'Deploy'.print();
    deploy_result.contract_address.print();
}
