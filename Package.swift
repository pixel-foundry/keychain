// swift-tools-version:6.0
import PackageDescription

let package = Package(
	name: "keychain",
	platforms: [
		.iOS(.v16),
		.macOS(.v13),
		.tvOS(.v16),
		.watchOS(.v9)
	],
	products: [
		.library(name: "Keychain", targets: ["Keychain"])
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.1"),
		.package(url: "https://github.com/square/Valet", from: "5.0.0")
	],
	targets: [
		.target(
			name: "Keychain",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "Valet", package: "Valet")
			]
		),
		.testTarget(name: "KeychainTests", dependencies: ["Keychain"])
	]
)
