import Foundation

struct MCURLConfiguration {
    let service: MCURLService
    let decorators: [String: String]
    let baseUrl: String
    let keychain: MCKeychainProtocol

    init(service: MCURLService,
         decorators: [String: String],
         baseUrl: String,
         keychain: MCKeychainProtocol) {
        self.service = service
        self.decorators = decorators
        self.baseUrl = baseUrl
        self.keychain = keychain
    }
}
