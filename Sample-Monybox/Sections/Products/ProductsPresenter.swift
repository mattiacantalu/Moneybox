protocol ProductsPresenterProtocol: AnyObject {
    func investorProducts()
    func investor(products: InvestorProductsModel)
    func on(error: Error?)
    
    func logout()
}

class ProductsPresenter {
    private let view: ProductsViewProtocol?
    private let productsInteractor: InvestorProductsInteractorProtocol
    private let configuration: MCURLConfiguration

    init(view: ProductsViewProtocol?,
         productsInteractor: InvestorProductsInteractorProtocol,
         configuration: MCURLConfiguration) {
        self.view = view
        self.productsInteractor = productsInteractor
        self.configuration = configuration
    }
}

extension ProductsPresenter: ProductsPresenterProtocol {
    func logout() {
        clearSession()
    }

    func investorProducts() {
        productsInteractor.perform()
    }

    func investor(products: InvestorProductsModel) {
        view?.load(user: configuration.keychain.userSession()?.user ?? UserModel(),
                   products: products)
    }

    func on(error: Error?) {
        clearSession()
    }

    private func clearSession() {
        configuration.keychain.clearSession()
        investor(products: InvestorProductsModel(totalPlanValue: 0, products: []))
        (view as? ProductsViewController)?
            .presentLogin(with: configuration,
                          presentation: self)
    }
}

extension ProductsPresenter: PresentationProtocol {
    func onDismiss() {
        productsInteractor.perform()
    }
}

private extension UserModel {
    init() {
        self.init(firstName: "",
                  lastName: "",
                  email: "",
                  mobileNumber: "")
    }
}
