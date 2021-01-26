import Foundation
@testable import Sample_Moneybox

class MockedProductsView: ProductsViewProtocol {
    var counterLoadUserProducts: Int = 0
    var counterShowError: Int = 0

    var loadUserProductsHandler: ((UserModel, InvestorProductsModel) -> Void)?
    var showErrorHandler: ((Error?) -> Void)?

    public init() {}

    func show(error: Error?) {
        counterShowError += 1
        if let showErrorHandler = showErrorHandler {
            return showErrorHandler(error)
        }
    }

    func load(user: UserModel, products: InvestorProductsModel) {
        counterLoadUserProducts += 1
        if let loadUserProductsHandler = loadUserProductsHandler {
            return loadUserProductsHandler(user, products)
        }
    }
}
