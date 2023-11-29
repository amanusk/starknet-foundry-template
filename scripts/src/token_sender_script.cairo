use sncast_std::{
    declare, deploy, invoke, call, DeclareResult, DeployResult, InvokeResult, CallResult
};
use debug::PrintTrait;

fn main() {
    let max_fee = 1000000000000000;
    let salt = 0x3;

    // let declare_result = declare('TokenSender', Option::Some(max_fee));
    // 'Declared'.print();
    // let class_hash: felt252 = declare_result.class_hash.into();

    let class_hash = 0x019cb5760ab6be052cbdbeef813c7712d2778c495633c9d2f944f635671825f0
        .try_into()
        .unwrap();
    // class_hash.print();

    let deploy_result = deploy(
        class_hash, ArrayTrait::new(), Option::Some(salt), true, Option::Some(max_fee)
    );

    'Deployed'.print();
    deploy_result.contract_address.print();
}
