import Foundation

public protocol Keychain: Sendable {

	@inlinable
	func load<T>(key: String) throws -> T where T: Decodable

	@inlinable
	func save<T>(key: String, value: T) throws where T: Encodable

	func delete(key: String) throws

	func allKeys() throws -> Set<String>

}
