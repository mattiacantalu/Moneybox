import Foundation
@testable import Sample_Moneybox

class MockedLoginPresenter: LoginPresenterProtocol {
    var counterLoginUser: Int = 0
    var counterUserLogged: Int = 0
    var counterOnError: Int = 0

    var loginUserHandler: ((User?) -> Void)?
    var userLoggedHandler: ((LoginModel) -> Void)?
    var onErrorHandler: ((Error?) -> Void)?

    public init() {}

    func login(user: User) {
        counterLoginUser += 1
        if let loginUserHandler = loginUserHandler {
            return loginUserHandler(user)
        }
    }

    func user(logged: LoginModel) {
        counterUserLogged += 1
        if let userLoggedHandler = userLoggedHandler {
            return userLoggedHandler(logged)
        }
    }

    func on(error: Error?) {
        counterOnError += 1
        if let onErrorHandler = onErrorHandler {
            return onErrorHandler(error)
        }
    }
}

