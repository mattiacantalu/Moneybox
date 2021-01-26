import Foundation

enum MonyboxSession {
    private static let headers = [
        MCConstants.Headers.AppId: "<token>",
        MCConstants.Headers.contentType: "application/json",
        MCConstants.Headers.appVersion: "<app version>",
        MCConstants.Headers.apiVersion: "<API version>"
    ]

    private static let keychain = AppleKeychain(service: MCConstants.Keychain.service)

    static var configuration = MCURLConfiguration(service: MCURLService(),
                                                  decorators: headers,
                                                  baseUrl: MCConstants.URL.base,
                                                  keychain: keychain)
}
