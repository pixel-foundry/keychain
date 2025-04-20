import Dependencies
import Foundation
import Valet

struct ValetKeychain {

	@Dependency(\.keychainConfiguration) var configuration

	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()

	private func valet() throws -> Valet {
		switch configuration.type {
		case .iCloud:
			switch configuration.identifier {
			case let .identifier(identifier):
				guard let identifier = Identifier(nonEmpty: identifier) else {
					throw Error.invalidIdentifier
				}
				return Valet.iCloudValet(
					with: identifier,
					accessibility: configuration.accessibility.cloudAccessibility
				)

			case let .sharedGroup(appIDPrefix, groupIdentifier):
				guard let identifier = SharedGroupIdentifier(appIDPrefix: appIDPrefix, nonEmptyGroup: groupIdentifier) else {
					throw Error.invalidIdentifier
				}
				return Valet.iCloudSharedGroupValet(
					with: identifier,
					accessibility: configuration.accessibility.cloudAccessibility
				)
			}

		case .local:
			switch configuration.identifier {
			case let .identifier(identifier):
				guard let identifier = Identifier(nonEmpty: identifier) else {
					throw Error.invalidIdentifier
				}
				return Valet.valet(
					with: identifier,
					accessibility: configuration.accessibility.accessibility
				)

			case let .sharedGroup(appIDPrefix, groupIdentifier):
				guard let identifier = SharedGroupIdentifier(appIDPrefix: appIDPrefix, nonEmptyGroup: groupIdentifier) else {
					throw Error.invalidIdentifier
				}
				return Valet.sharedGroupValet(
					with: identifier,
					accessibility: configuration.accessibility.accessibility
				)
			}
		}
	}

	enum Error: Swift.Error {
		case invalidIdentifier
	}

}

// MARK: Keychain

extension ValetKeychain: Keychain {

	@inlinable
	func load<T>(key: String) throws -> T where T: Decodable {
		let data = try valet().object(forKey: key)
		return try decoder.decode(T.self, from: data)
	}

	@inlinable
	func save<T>(key: String, value: T) throws where T: Encodable {
		let data = try encoder.encode(value)
		try valet().setObject(data, forKey: key)
	}

	func delete(key: String) throws {
		try valet().removeObject(forKey: key)
	}

	func allKeys() throws -> Set<String> {
		try valet().allKeys()
	}

}

extension KeychainConfiguration.Accessibility {

	fileprivate var accessibility: Accessibility {
		switch self {
		case .afterFirstUnlock:
			return .afterFirstUnlock
		case .whenUnlocked:
			return .whenUnlocked
		}
	}

	fileprivate var cloudAccessibility: CloudAccessibility {
		switch self {
		case .afterFirstUnlock:
			return .afterFirstUnlock
		case .whenUnlocked:
			return .whenUnlocked
		}
	}

}
