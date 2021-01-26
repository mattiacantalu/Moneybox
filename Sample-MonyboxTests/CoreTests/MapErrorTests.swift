import XCTest
@testable import Sample_Moneybox

class MapErrorTests: XCTestCase {

    func testMapError() {
        guard let data = JSONMock.loadJson(fromResource: "valid_error") else {
            XCTFail("JSON data error!")
            return
        }

        let url = URL(string: "https://api-test02.moneyboxapp.com")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 401,
                                       httpVersion: "1.0",
                                       headerFields: [:])
        
        let session = MockedSession.simulate(failure: response, data: data) { _ in }

        let service = MCURLService(session: session,
                                   dispatcher: SyncDispatcher())
        let config =  MCURLConfiguration(service: service,
                                         decorators: [:],
                                         baseUrl: "https://api-test02.moneyboxapp.com",
                                         keychain: MockedMCKeychain())
        

        do {
            try MCServicePerformer(configuration: config)
                .products() { result in
                    switch result {
                    case .success:
                        XCTFail("Should be fail! Got success.")
                    case .failure(let error):
                        XCTAssertEqual(error.localizedDescription, "Your session has expired. Please close the app and log in again.")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
}
