import Foundation

protocol InvestorProductsInteractorProtocol {
    func perform()
}

class InvestorProductsInteractor: InvestorProductsInteractorProtocol {
    private let service: MCServicePerformerProtocol
    weak var presenter: ProductsPresenterProtocol?
    
    init(service: MCServicePerformerProtocol) {
        self.service = service
    }

    func perform() {
        performTry({
            try service.products() { result in
                switch result {
                case .success(let response):
                    self.presenter?.investor(products: response)
                case .failure(let error):
                    if error.nsError.code == 401 {
                        self.presenter?.logout()
                        return
                    }
                    self.presenter?.on(error: error)
                }
            }
        }, fallback: { self.presenter?.on(error: $0) })
    }
}

private extension Error {
    var nsError: NSError {
        self as NSError
    }
}
