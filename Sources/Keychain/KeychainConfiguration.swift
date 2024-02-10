import Foundation

public struct KeychainConfiguration: Hashable, Sendable {

	public let type: Type
	public let identifier: Identifier
	public let accessibility: Accessibility

	public init(
		type: `Type`,
		identifier: Identifier,
		accessibility: Accessibility
	) {
		self.type = type
		self.identifier = identifier
		self.accessibility = accessibility
	}

	public enum `Type`: Hashable, Sendable {
		case iCloud
		case local
	}

	public enum Identifier: Hashable, Sendable {
		case identifier(String)
		case sharedGroup(appIDPrefix: String, groupIdentifier: String)
	}

	public enum Accessibility: Hashable, Sendable {
		case whenUnlocked
		case afterFirstUnlock
	}

}
