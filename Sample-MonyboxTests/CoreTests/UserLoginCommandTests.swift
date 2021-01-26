import XCTest
@testable import Sample_Moneybox

extension MCURLCommandTests {
    func testLoginUserRequest() {
        guard let data = JSONMock.loadJson(fromResource: "valid_login") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) {
            XCTAssertEqual($0.url?.absoluteString, "https://api-test02.moneyboxapp.com/users/login")
            XCTAssertEqual($0.httpMethod, "POST")
            
            let headers = $0.allHTTPHeaderFields
            XCTAssertEqual(headers?["AppId"], "8cb2237d0679ca88db6464")
            XCTAssertEqual(headers?["Content-Type"], "application/json")
            XCTAssertEqual(headers?["appVersion"], "7.10.0")
            XCTAssertEqual(headers?["apiVersion"], "3.0.0")

            let body = $0.httpBody?.toDict()
            
            XCTAssertEqual(body?["Email"], "sample@mail.com")
            XCTAssertEqual(body?["Password"], "a1b2c3")
            XCTAssertEqual(body?["Idfa"], "ANYTHING")
        }

        let user = User(email: "sample@mail.com",
                        password: "a1b2c3")

        do {
            try MCServicePerformer(configuration: configure(session))
                .login(user: user) { _ in }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testLoginUserResponseShouldSuccess() {
        guard let data = JSONMock.loadJson(fromResource: "valid_login") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) { _ in }
        let user = User(email: "", password: "")

        do {
            try MCServicePerformer(configuration: configure(session))
                .login(user: user) { result in
                    switch result {
                    case .success(let response):
                        XCTAssertEqual(response.user.email, "test+ios@moneyboxapp.com")
                        XCTAssertEqual(response.user.firstName, "Michael")
                        XCTAssertEqual(response.user.lastName, "Jordan")
                        XCTAssertEqual(response.user.mobileNumber, "07566543455")
                        XCTAssertEqual(response.session.bearerToken, "wcjo+FG9KjQQjdLfN+yA/MxaCnnk5TgiWqHxjOrh37E=")
                    case .failure(let error):
                        XCTFail("Should be success! Got: \(error)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testLoginUser_withBadData_shouldFail() {
        let session = MockedSession.simulate(failure: MCServiceError.noData) { _ in }
        let user = User(email: "", password: "")

        do {
            try MCServicePerformer(configuration: configure(session))
                .login(user: user) { result in
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
