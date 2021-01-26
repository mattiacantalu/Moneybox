import XCTest
@testable import Sample_Moneybox

class ProductsPresenterTests: XCTestCase {
    var sut: ProductsPresenter?
    var productsInteractor: MockedInvestorProductsInteractor?
    var view: MockedProductsView?
    var keychain: MockedMCKeychain?

    override func setUp() {
        view = MockedProductsView()
        keychain = MockedMCKeychain()
        productsInteractor = MockedInvestorProductsInteractor()
        let config = MCURLConfiguration(service: MCURLService(),
                                        decorators: [:],
                                        baseUrl: "",
                                        keychain: keychain ?? MockedMCKeychain())
        sut = ProductsPresenter(view: view,
                                productsInteractor: productsInteractor ?? MockedInvestorProductsInteractor(),
                                configuration: config)
    }
    
    func testLogout() {
        keychain?.userSessionHandler = {
            nil
        }
        view?.loadUserProductsHandler = {
            XCTAssertTrue($0.firstName.isEmpty)
            XCTAssertTrue($0.lastName.isEmpty)
            XCTAssertTrue($0.email.isEmpty)
            XCTAssertTrue($0.mobileNumber?.isEmpty == true)
            XCTAssertEqual($1.totalPlanValue, 0)
            XCTAssertEqual($1.products.count, 0)
        }

        sut?.logout()
        XCTAssertEqual(keychain?.counterClearSession, 1)
        XCTAssertEqual(view?.counterLoadUserProducts, 1)
    }
    
    func testInvestorProductFetch() {
        sut?.investorProducts()
        XCTAssertEqual(productsInteractor?.counterPerform, 1)
    }
    
    func testInvestorProductFetched() {
        keychain?.userSessionHandler = {
            let user = UserModel(firstName: "firstname",
                                 lastName: "lastname",
                                 email: "email",
                                 mobileNumber: "000")
            let session = UserSessionModel(bearerToken: "")
            return LoginModel(user: user,
                              session: session)
        }

        view?.loadUserProductsHandler = {
            XCTAssertEqual($0.firstName, "firstname")
            XCTAssertEqual($0.lastName, "lastname")
            XCTAssertEqual($0.email, "email")
            XCTAssertEqual($0.mobileNumber, "000")
            XCTAssertEqual($1.totalPlanValue, 1.0)
        }

        let model = InvestorProductsModel(totalPlanValue: 1.0,
                                          products: [])
        sut?.investor(products: model)
        
        XCTAssertEqual(view?.counterLoadUserProducts, 1)
    }
    
    func testInvestorProductFetchedMissingUserInfo() {
        view?.loadUserProductsHandler = {
            XCTAssertTrue($0.firstName.isEmpty == true)
            XCTAssertTrue($0.lastName.isEmpty == true)
            XCTAssertTrue($0.email.isEmpty == true)
            XCTAssertTrue($0.mobileNumber?.isEmpty == true)
            XCTAssertEqual($1.totalPlanValue, 1.0)
        }

        let model = InvestorProductsModel(totalPlanValue: 1.0,
                                          products: [])
        sut?.investor(products: model)
        
        XCTAssertEqual(view?.counterLoadUserProducts, 1)
    }
    
    func testOnError() {
        keychain?.userSessionHandler = {
            nil
        }
        view?.loadUserProductsHandler = {
            XCTAssertTrue($0.firstName.isEmpty)
            XCTAssertTrue($0.lastName.isEmpty)
            XCTAssertTrue($0.email.isEmpty)
            XCTAssertTrue($0.mobileNumber?.isEmpty == true)
            XCTAssertEqual($1.totalPlanValue, 0)
            XCTAssertEqual($1.products.count, 0)
        }

        sut?.on(error: nil)
        XCTAssertEqual(keychain?.counterClearSession, 1)
        XCTAssertEqual(view?.counterLoadUserProducts, 1)
    }
    
    func testOnDismiss() {
        sut?.onDismiss()
        XCTAssertEqual(productsInteractor?.counterPerform, 1)
    }
}
