import Dependencies
import Foundation
import os
import Valet

public final class InMemoryKeychain {

	@usableFromInline
	static let data = OSAllocatedUnfairLock(initialState: [String: Data]())

	init() {}

	@usableFromInline
	let encoder = JSONEncoder()

	@usableFromInline
	let decoder = JSONDecoder()

}

// MARK: Keychain

extension InMemoryKeychain: Keychain {

	@inlinable
	public func load<T>(key: String) throws -> T where T: Decodable {
		guard let data = InMemoryKeychain.data.withLock({ $0[key] }) else {
			throw KeychainError.itemNotFound
		}
		return try decoder.decode(T.self, from: data)
	}

	@inlinable
	public func save<T>(key: String, value: T) throws where T: Encodable {
		let data = try encoder.encode(value)
		InMemoryKeychain.data.withLock { $0[key] = data }
	}

	public func delete(key: String) throws {
		_ = InMemoryKeychain.data.withLock { $0.removeValue(forKey: key) }
	}

	public func allKeys() throws -> Set<String> {
		InMemoryKeychain.data.withLock { Set($0.keys) }
	}

}
