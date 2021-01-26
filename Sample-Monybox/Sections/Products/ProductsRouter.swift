import Foundation
import UIKit

struct ProductsRouter {
    let view: ProductsViewController?

    init(sessionConfig: MCURLConfiguration) {
        view = UIStoryboard(name: "Main",
                            bundle: nil)
                   .instantiateViewController(withIdentifier: "productsViewController") as? ProductsViewController

        let serviceFacade = MCServicePerformer(configuration: sessionConfig)
        let interactor = InvestorProductsInteractor(service: serviceFacade)
        let presenter = ProductsPresenter(view: view,
                                          productsInteractor: interactor,
                                          configuration: sessionConfig)

        interactor.presenter = presenter
        view?.presenter = presenter
    }
}
