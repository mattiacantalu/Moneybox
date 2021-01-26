import Foundation
@testable import Sample_Moneybox

class MockedLoginControllerView: LoginViewProtocol {
    var counterUpdate: Int = 0
    var counterShowError: Int = 0

    var updateHandler: (() -> Void)?
    var showErrorHandler: ((Error?) -> Void)?

    public init() {}

    func update() {
        counterUpdate += 1
        if let updateHandler = updateHandler {
            return updateHandler()
        }
    }

    func show(error: Error?) {
        counterShowError += 1
        if let showErrorHandler = showErrorHandler {
            return showErrorHandler(error)
        }
    }
}
