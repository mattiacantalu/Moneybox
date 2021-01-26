import XCTest
@testable import Sample_Moneybox

class MCURLCommandTests: XCTestCase {
    var keychain: MockedMCKeychain?

    override func setUp() {
        keychain = MockedMCKeychain()
    }
    
    func configure(_ session: MCURLSessionProtocol) -> MCURLConfiguration {
        let service = MCURLService(session: session,
                                   dispatcher: SyncDispatcher())
        return MCURLConfiguration(service: service,
                                  decorators: [
                                    MCConstants.Headers.AppId: "8cb2237d0679ca88db6464",
                                    MCConstants.Headers.contentType: "application/json",
                                    MCConstants.Headers.appVersion: "7.10.0",
                                    MCConstants.Headers.apiVersion: "3.0.0"
                                  ],
                                  baseUrl: "https://api-test02.moneyboxapp.com",
                                  keychain: keychain ?? MockedMCKeychain())
    }
}

func == (lhs: MCServiceError, rhs: MCServiceError) -> Bool {
    switch (lhs, rhs) {
    case (let .couldNotCreate(url), let .couldNotCreate(url2)):
        return url == url2
    case (.noData, .noData):
        return true
    default:
        return false
    }
}
