import Foundation
import os
import Valet

public final class InMemoryKeychain {

	let data = OSAllocatedUnfairLock(initialState: [String: Data]())

	init() {}

	let encoder = JSONEncoder()

	let decoder = JSONDecoder()

}

// MARK: Keychain

extension InMemoryKeychain: Keychain {

	public func load<T>(key: String) throws -> T where T: Decodable {
		guard let data = data.withLock({ $0[key] }) else {
			throw KeychainError.itemNotFound
		}
		return try decoder.decode(T.self, from: data)
	}

	public func save<T>(key: String, value: T) throws where T: Encodable {
		let encoded = try encoder.encode(value)
		data.withLock { $0[key] = encoded }
	}

	public func delete(key: String) throws {
		_ = data.withLock { $0.removeValue(forKey: key) }
	}

	public func allKeys() throws -> Set<String> {
		data.withLock { Set($0.keys) }
	}

}
