import XCTest
@testable import Sample_Moneybox

extension MCURLCommandTests {
    func testInvestorProductsRequest() {
        keychain?.userSessionHandler = {
            let user = UserModel(firstName: "",
                                 lastName: "",
                                 email: "",
                                 mobileNumber: "")
            let session = UserSessionModel(bearerToken: "TsMWRkbrcu3NGrpf84gi2+pg0iOMVymyKklmkY0oI84=")
            return LoginModel(user: user,
                              session: session)
        }

        guard let data = JSONMock.loadJson(fromResource: "valid_investor_products") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) {
            XCTAssertEqual($0.url?.absoluteString, "https://api-test02.moneyboxapp.com/investorproducts")
            XCTAssertEqual($0.httpMethod, "GET")

            let headers = $0.allHTTPHeaderFields
            XCTAssertEqual(headers?["AppId"], "8cb2237d0679ca88db6464")
            XCTAssertEqual(headers?["Content-Type"], "application/json")
            XCTAssertEqual(headers?["appVersion"], "7.10.0")
            XCTAssertEqual(headers?["apiVersion"], "3.0.0")
            XCTAssertEqual(headers?["Authorization"], "Bearer TsMWRkbrcu3NGrpf84gi2+pg0iOMVymyKklmkY0oI84=")

            XCTAssertNil($0.httpBody)
        }

        do {
            try MCServicePerformer(configuration: configure(session))
                .products { _ in }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testInvestorProductsResponseShouldSuccess() {
        guard let data = JSONMock.loadJson(fromResource: "valid_investor_products") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession(data: data, response: nil, error: nil) { _ in }

        do {
            try MCServicePerformer(configuration: configure(session))
                .products { result in
                    switch result {
                    case .success(let response):
                        XCTAssertEqual(response.totalPlanValue, 5651.960000)
                        let userProduct = response.products.first
                        XCTAssertEqual(userProduct?.planValue, 2693.80)
                        XCTAssertEqual(userProduct?.moneybox, 0.00)
                        XCTAssertEqual(userProduct?.product.friendlyName, "Stocks & Shares ISA")
                    case .failure(let error):
                        XCTFail("Should be success! Got: \(error)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
    
    func testInvestorProductsShouldSuccess_withBadData_shouldFail() {
        let session = MockedSession.simulate(failure: MCServiceError.noData) { _ in }
        
        do {
            try MCServicePerformer(configuration: configure(session))
                .products { result in
                    switch result {
                    case .success:
                        XCTFail("Should be fail! Got success.")
                    case .failure(let error):
                        guard let mcError = error as? MCServiceError else {
                            XCTFail("Unexpected error type!")
                            return
                        }
                        XCTAssert(mcError == MCServiceError.noData)
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
}
