set -e

NIGHTLY=$1

function get_rust {
  rustup install $NIGHTLY
  rustup +$NIGHTLY component add rust-src
  rustup +$NIGHTLY target add aarch64-apple-ios
}

function write_nightly {
  mkdir -p rlib/target
  printf "$NIGHTLY" > rlib/target/NIGHTLY
}

function toolchain {
  cd rlib/target
  rustc +$NIGHTLY -Zunstable-options --target=aarch64-apple-ios --print target-spec-json \
  | sed "s/\"is-builtin\": true,/\"is-builtin\": false,/g" \
  | sed "s/\"llvm-target\": \".*\",/\"llvm-target\": \"arm64-apple-ios13.0\",/g" \
  > "aarch64-apple-ios.json"
  cd ../..
}

function build_rust {
  cd rlib

  mkdir -p "target/Headers"
  cbindgen --config "cbindgen.toml" -o "target/Headers/librlib.h"

  echo 'module rlib {' > "target/Headers/module.modulemap"
  echo '  export *' >> "target/Headers/module.modulemap"
  echo '  link "librlib"' >> "target/Headers/module.modulemap"
  echo '  header "librlib.h"' >> "target/Headers/module.modulemap"
  echo '}' >> "target/Headers/module.modulemap"

  cargo +$NIGHTLY build --release \
    -Zbuild-std --target "target/aarch64-apple-ios.json"

  cd ..
}

function build_xcframework {
  rm -rf "slib/rlib.xcframework"
  xcodebuild -create-xcframework \
    -library "rlib/target/aarch64-apple-ios/release/librlib.a" \
    -headers "rlib/target/Headers" \
    -output "slib/rlib.xcframework" >/dev/null
}

function check_ios {
  cd rs-ios
  rm -rf ".build"
  xcodebuild -scheme rs-ios -destination generic/platform=iOS archive \
    -archivePath ".build/rs-ios.xcarchive"
  cd ..
}

if [[ "$#" -ne 1 ]]
then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

if [[ $NIGHTLY = "clean" ]]
then
  (cd rlib && cargo clean)
  (cd slib && swift package clean)
  rm -rf "slib/rlib.xcframework"
  rm -rf "rs-ios/build"
  exit 0
fi

get_rust
write_nightly
toolchain
build_rust
build_xcframework
check_ios
