# Tool for testing rust-xcode compatibility

Xcode requires the LLVM version used to build rust libraries match what it uses internally for App Store builds. This script installs the specified nightly toolchain and attempts to archive an iOS app that links to a rust library.

## Requirements

- `cargo install cbindgen`

## Running

Examples:

```sh
./make.sh clean
./make.sh nightly
./make.sh nightly-2021-01-01
```
