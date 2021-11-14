#[no_mangle]
pub extern "C" fn rust_lib_print() {
	let version = include_str!("../target/NIGHTLY");
	println!("rust version:");
	println!("{}", version);
}
