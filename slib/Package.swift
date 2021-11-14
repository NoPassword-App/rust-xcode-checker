// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "slib",
	products: [
		.library(
			name: "slib",
			targets: ["slib"]),
	],
	targets: [
		.target(
			name: "slib",
			dependencies: ["rlib"]),
		.binaryTarget(
			name: "rlib",
			path: "./rlib.xcframework"),
	]
)
