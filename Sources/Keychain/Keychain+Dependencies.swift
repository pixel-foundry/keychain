import Dependencies
import Foundation

extension DependencyValues {

	public var keychain: any Keychain {
		get { self[KeychainDependencyKey.self] }
		set { self[KeychainDependencyKey.self] = newValue }
	}

}

public enum KeychainDependencyKey: DependencyKey {
	public static var liveValue: any Keychain { ValetKeychain() }
	public static var testValue: any Keychain { InMemoryKeychain() }
}
