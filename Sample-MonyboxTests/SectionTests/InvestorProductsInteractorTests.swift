import XCTest
@testable import Sample_Moneybox

class InvestorProductsInteractorTests: XCTestCase {
    var sut: InvestorProductsInteractor?
    var presenter: MockedProductsPresenter?

    override func setUp() {
        presenter = MockedProductsPresenter()
    }
    
    func testPerformShouldReturnInvestorProducts() {
        presenter?.investorFetchedProducts = {
            XCTAssertNotNil($0)
        }

        guard let data = JSONMock.loadJson(fromResource: "valid_investor_products") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) { _ in }
        create(session)
        
        sut?.perform()
        XCTAssertEqual(presenter?.counterInvestorFetchedProducts, 1)
        XCTAssertEqual(presenter?.counterOnError, 0)
        XCTAssertEqual(presenter?.counterLogout, 0)
    }
    
    func testPerformShouldReturnError() {
        presenter?.onErrorHandler = {
            let error = $0 as? FakeError
            XCTAssertEqual(error, FakeError.test)
        }

        let session = MockedSession.simulate(failure: FakeError.test) { _ in }
        create(session)
        
        sut?.perform()

        XCTAssertEqual(presenter?.counterInvestorFetchedProducts, 0)
        XCTAssertEqual(presenter?.counterOnError, 1)
        XCTAssertEqual(presenter?.counterLogout, 0)
    }
    
    func testPerformShouldLogout() {
        let error = NSError(domain: "",
                            code: 401,
                            userInfo: [:])
        let session = MockedSession.simulate(failure: error) { _ in }
        create(session)
        
        sut?.perform()

        XCTAssertEqual(presenter?.counterInvestorFetchedProducts, 0)
        XCTAssertEqual(presenter?.counterOnError, 0)
        XCTAssertEqual(presenter?.counterLogout, 1)
    }
    
    private func create(_ session: MCURLSessionProtocol) {
        let service = MCURLService(session: session,
                                   dispatcher: SyncDispatcher())
        let config = MCURLConfiguration(service: service,
                                        decorators: [:],
                                        baseUrl: "https://sample.com",
                                        keychain: MockedMCKeychain())
        let facade = MCServicePerformer(configuration: config)
        sut = InvestorProductsInteractor(service: facade)
        sut?.presenter = presenter
    }
}
