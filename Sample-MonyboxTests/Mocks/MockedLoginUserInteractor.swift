import Foundation
@testable import Sample_Moneybox

class MockedLoginUserInteractor: LoginUserInteractorProtocol {
    var counterPerform: Int = 0

    var performHandler: ((User?) -> Void)?

    public init() {}

    func perform(_ user: User) {
        counterPerform += 1
        if let performHandler = performHandler {
            return performHandler(user)
        }
    }
}

