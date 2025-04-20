import Dependencies
import Foundation

extension DependencyValues {

	public var keychain: any Keychain {
		get { self[KeychainDependencyKey.self] }
		set { self[KeychainDependencyKey.self] = newValue }
	}

}

public enum KeychainDependencyKey: DependencyKey {
	public static let liveValue: any Keychain = ValetKeychain()
}

extension KeychainDependencyKey: TestDependencyKey {
	public static let testValue: any Keychain = InMemoryKeychain()
}
