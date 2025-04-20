#if canImport(Sharing)
import Dependencies
import Sharing

extension SharedKey where Value: Codable & Sendable {

	public static func keychain<Value>(_ key: String) -> Self where Self == KeychainStorageKey<Value> {
		KeychainStorageKey(key: key)
	}

}

public struct KeychainStorageKey<Value: Codable & Sendable>: SharedKey {

	@Dependency(\.keychain) private var _keychain
	private let key: String

	public init(key: String) {
		self.key = key
	}

	public func load(context: LoadContext<Value>, continuation: LoadContinuation<Value>) {
		do {
			let value: Value = try _keychain.load(key: key)
			continuation.resume(returning: value)
		} catch {
			continuation.resume(throwing: error)
		}
	}

	public func save(_ value: Value, context: SaveContext, continuation: SaveContinuation) {
		do {
			try _keychain.save(key: key, value: value)
			continuation.resume()
		} catch {
			continuation.resume(throwing: error)
		}
	}

	public func subscribe(context: LoadContext<Value>, subscriber: SharedSubscriber<Value>) -> SharedSubscription {
		SharedSubscription {}
	}

}

extension KeychainStorageKey: Equatable, Hashable {

	public static func == (lhs: KeychainStorageKey, rhs: KeychainStorageKey) -> Bool {
		lhs.key == rhs.key
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(key)
	}

}
#endif
