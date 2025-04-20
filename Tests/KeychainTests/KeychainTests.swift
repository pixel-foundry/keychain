@testable import Keychain
import Dependencies
import XCTest

class KeychainTests: XCTestCase {

	@Dependency(\.keychain) var keychain

	func testInMemoryKeychain() throws {
		try withDependencies {
			$0.keychain = InMemoryKeychain()
		} operation: {
			try keychain.save(key: "key", value: "test")
			XCTAssertEqual(try keychain.load(key: "key"), "test")
			try keychain.delete(key: "key")
			XCTAssertEqual(try? keychain.load(key: "key"), Optional<String>.none)
		}
	}

}
