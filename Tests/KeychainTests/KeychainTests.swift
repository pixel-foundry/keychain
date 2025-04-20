import Dependencies
@testable import Keychain
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
			XCTAssertThrowsError(try { let _: String = try keychain.load(key: "key") }())
		}
	}

}
