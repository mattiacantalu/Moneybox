import Foundation
@testable import Sample_Moneybox

class MockedMCKeychain: MCKeychainProtocol {
    var counterUserSession: Int = 0
    var counterSaveUserSession: Int = 0
    var counterClearSession: Int = 0

    var userSessionHandler: (() -> LoginModel?)?
    var saveUserSesssionHandler: ((LoginModel) -> Void)?
    var clearSessionHandler: (() -> Void)?

    init() {}

    func userSession() -> LoginModel? {
        counterUserSession += 1
        if let userSessionHandler = userSessionHandler {
            return userSessionHandler()
        }
        return nil
    }

    func user(session: LoginModel) {
        counterSaveUserSession += 1
        if let saveUserSesssionHandler = saveUserSesssionHandler {
            return saveUserSesssionHandler(session)
        }
    }
    
    func clearSession() {
        counterClearSession += 1
        if let clearSessionHandler = clearSessionHandler {
            return clearSessionHandler()
        }
    }
}
