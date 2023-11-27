use sncast_std::{
    declare, deploy, invoke, call, DeclareResult, DeployResult, InvokeResult, CallResult
};
use debug::PrintTrait;

fn main() {
    let max_fee = 99999999999999999;
    let salt = 0x3;

    let declare_result = declare('TokenSender', Option::Some(max_fee));

    let class_hash = declare_result.class_hash;
    let deploy_result = deploy(
        class_hash, ArrayTrait::new(), Option::Some(salt), true, Option::Some(max_fee)
    );

    'Deployed'.print();
    deploy_result.contract_address.print();
// let invoke_result = invoke(
//     deploy_result.contract_address, 'put', array![0x1, 0x2], Option::Some(max_fee)
// );

// "Invoke tx hash is".print();
// invoke_result.transaction_hash.print();

// let call_result = call(deploy_result.contract_address, 'get', array![0x1]);
// assert(call_result.data == array![0x2], *call_result.data.at(0));
}
