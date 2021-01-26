import Foundation
@testable import Sample_Moneybox

class MockedProductsPresenter: ProductsPresenterProtocol {
    var counterInvestorProducts: Int = 0
    var counterInvestorFetchedProducts: Int = 0
    var counterOnError: Int = 0
    var counterLogout: Int = 0

    var investorProductsHandler: (() -> Void)?
    var investorFetchedProducts: ((InvestorProductsModel) -> Void)?
    var onErrorHandler: ((Error?) -> Void)?
    var logoutHandler: (() -> Void)?

    public init() {}

    func investorProducts() {
        counterInvestorProducts += 1
        if let investorProductsHandler = investorProductsHandler {
            return investorProductsHandler()
        }
    }

    func investor(products: InvestorProductsModel) {
        counterInvestorFetchedProducts += 1
        if let investorFetchedProducts = investorFetchedProducts {
            return investorFetchedProducts(products)
        }
    }

    func on(error: Error?) {
        counterOnError += 1
        if let onErrorHandler = onErrorHandler {
            return onErrorHandler(error)
        }
    }
    
    func logout() {
        counterLogout += 1
        if let logoutHandler = logoutHandler {
            return logoutHandler()
        }
    }
}
