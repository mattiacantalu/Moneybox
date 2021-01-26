import XCTest
@testable import Sample_Moneybox

class LoginPresenterTests: XCTestCase {
    var sut: LoginPresenter?
    var loginUser: MockedLoginUserInteractor?
    var view: MockedLoginControllerView?
    var keychain: MockedMCKeychain?

    override func setUp() {
        loginUser = MockedLoginUserInteractor()
        view = MockedLoginControllerView()
        keychain = MockedMCKeychain()

        guard let loginUser = loginUser,
              let view = view,
              let keychain = keychain else {
            XCTFail("Init failure")
            return
        }

        sut = LoginPresenter(view: view,
                             loginUserInteractor: loginUser,
                             keychain: keychain,
                             presentation: nil)
    }
    
    func testLoginUser() {
        loginUser?.performHandler = {
            XCTAssertEqual($0?.email, "email")
            XCTAssertEqual($0?.password, "password")
        }
        sut?.login(user: User(email: "email",
                              password: "password"))
        XCTAssertEqual(loginUser?.counterPerform, 1)
    }
    
    func testUserLogged() {
        keychain?.saveUserSesssionHandler = {
            let user = $0.user
            XCTAssertEqual(user.firstName, "firstname")
            XCTAssertEqual(user.lastName, "lastname")
            XCTAssertEqual(user.email, "email")
            XCTAssertEqual(user.mobileNumber, "000")
            XCTAssertEqual($0.session.bearerToken, "abc123")
        }

        let user = UserModel(firstName: "firstname",
                             lastName: "lastname",
                             email: "email",
                             mobileNumber: "000")
        let session = UserSessionModel(bearerToken: "abc123")
        let login = LoginModel(user: user,
                               session: session)

        sut?.user(logged: login)

        XCTAssertEqual(keychain?.counterSaveUserSession, 1)
    }

    func testShowError() {
        sut?.on(error: nil)
        XCTAssertEqual(view?.counterShowError, 1)
    }
}
