import Foundation
import UIKit

struct LoginRouter {
    let view: LoginViewController?
    
    init(sessionConfig: MCURLConfiguration,
         presentation: PresentationProtocol?) {
        view = UIStoryboard(name: "Main",
                            bundle: nil)
                   .instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController

        let serviceFacade = MCServicePerformer(configuration: sessionConfig)
        let interactor = LoginUserInteractor(service: serviceFacade)
        let presenter = LoginPresenter(view: view,
                                       loginUserInteractor: interactor,
                                       keychain: sessionConfig.keychain,
                                       presentation: presentation)

        interactor.presenter = presenter
        view?.presenter = presenter
    }
}

extension UIViewController {
    func presentLogin(with configuration: MCURLConfiguration,
                      presentation: PresentationProtocol) {
        if let controller = LoginRouter(sessionConfig: configuration,
                                        presentation: presentation).view {
            controller.modalPresentationStyle = .formSheet
            controller.isModalInPresentation = true
            self.present(controller, animated: true, completion: nil)
        }
    }
}
