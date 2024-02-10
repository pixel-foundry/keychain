import Dependencies
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {

	public var keychainConfiguration: KeychainConfiguration {
		get { self[KeychainConfiguration.self] }
		set { self[KeychainConfiguration.self] = newValue }
	}

}

extension KeychainConfiguration: TestDependencyKey {

	public static var testValue: KeychainConfiguration {
		KeychainConfiguration(type: .local, identifier: Identifier.identifier("test"), accessibility: .afterFirstUnlock)
	}

}
