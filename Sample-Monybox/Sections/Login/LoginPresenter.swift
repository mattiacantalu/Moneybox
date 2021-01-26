import Foundation

protocol LoginPresenterProtocol: AnyObject {
    func login(user: User)
    func user(logged: LoginModel)
    func on(error: Error?)
}

class LoginPresenter {
    private let loginUserInteractor: LoginUserInteractorProtocol
    private let keychain: MCKeychainProtocol
    private let view: LoginViewProtocol?
    private let presentation: PresentationProtocol?

    init(view: LoginViewProtocol?,
         loginUserInteractor: LoginUserInteractorProtocol,
         keychain: MCKeychainProtocol,
         presentation: PresentationProtocol?) {
        self.view = view
        self.loginUserInteractor = loginUserInteractor
        self.keychain = keychain
        self.presentation = presentation
    }

    func login(user: User) {
        loginUserInteractor.perform(user)
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func user(logged: LoginModel) {
        keychain.user(session: logged)
        (view as? LoginViewController)?.dismiss(animated: true,
                                                completion: { self.presentation?.onDismiss() })
    }

    func on(error: Error?) {
        view?.show(error: error)
    }
}
