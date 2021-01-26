import XCTest
@testable import Sample_Moneybox

class LoginUserInteractorTests: XCTestCase {
    var sut: LoginUserInteractor?
    var presenter: MockedLoginPresenter?

    override func setUp() {
        presenter = MockedLoginPresenter()
    }
    
    func testPerformUserShouldReturnUserLogged() {
        presenter?.userLoggedHandler = {
            XCTAssertNotNil($0)
        }

        guard let data = JSONMock.loadJson(fromResource: "valid_login") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) { _ in }
        create(session)
        
        sut?.perform(User(email: "", password: ""))
        XCTAssertEqual(presenter?.counterUserLogged, 1)
        XCTAssertEqual(presenter?.counterOnError, 0)
    }

    func testPerformUserShouldReturnError() {
        presenter?.onErrorHandler = {
            let error = $0 as? FakeError
            XCTAssertEqual(error, FakeError.test)
        }

        let session = MockedSession.simulate(failure: FakeError.test) { _ in }
        create(session)
        
        sut?.perform(User(email: "", password: ""))
        XCTAssertEqual(presenter?.counterUserLogged, 0)
        XCTAssertEqual(presenter?.counterOnError, 1)
    }

    private func create(_ session: MCURLSessionProtocol) {
        let service = MCURLService(session: session,
                                   dispatcher: SyncDispatcher())
        let config = MCURLConfiguration(service: service,
                                        decorators: [:],
                                        baseUrl: "https://sample.com",
                                        keychain: MockedMCKeychain())
        let facade = MCServicePerformer(configuration: config)
        sut = LoginUserInteractor(service: facade)
        sut?.presenter = presenter
    }
}

enum FakeError: Error {
    case test
}

func == (lhs: FakeError, rhs: FakeError) -> Bool {
    switch (lhs, rhs) {
    case (.test, .test):
        return true
    }
}
