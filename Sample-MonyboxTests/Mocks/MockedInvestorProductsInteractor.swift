import Foundation
@testable import Sample_Moneybox

class MockedInvestorProductsInteractor: InvestorProductsInteractorProtocol {
    var counterPerform: Int = 0

    var performHandler: (() -> Void)?

    public init() {}

    func perform() {
        counterPerform += 1
        if let performHandler = performHandler {
            return performHandler()
        }
    }
}

