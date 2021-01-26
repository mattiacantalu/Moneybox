import Foundation

protocol LoginUserInteractorProtocol {
    func perform(_ user: User)
}

class LoginUserInteractor: LoginUserInteractorProtocol {
    private let service: MCServicePerformerProtocol
    weak var presenter: LoginPresenterProtocol?

    init(service: MCServicePerformerProtocol) {
        self.service = service
    }
    
    func perform(_ user: User) {
        performTry({
            try service.login(user: user) { result in
                switch result {
                case .success(let response):
                    self.presenter?.user(logged: response)
                case .failure(let error):
                    self.presenter?.on(error: error)
                }
            }
        }, fallback: { self.presenter?.on(error: $0) })
    }
}
