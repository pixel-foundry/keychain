import Dependencies
import Foundation
import os

public final class InMemoryKeychain {

	private static let data = OSAllocatedUnfairLock(initialState: [String: Data]())

	init() {}

	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()

}

// MARK: Keychain

extension InMemoryKeychain: Keychain {

	public func load<T>(key: String) throws -> T where T: Decodable {
		return try decoder.decode(T.self, from: InMemoryKeychain.data.withLock { $0[key] } ?? Data())
	}

	public func save<T>(key: String, value: T) throws where T: Encodable {
		let data = try encoder.encode(value)
		InMemoryKeychain.data.withLock { $0[key] = data }
	}

	public func delete(key: String) throws {
		_ = InMemoryKeychain.data.withLock { $0.removeValue(forKey: key) }
	}

}
