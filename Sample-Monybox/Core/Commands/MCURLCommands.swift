import Foundation

struct User {
    let email: String
    let password: String
}

extension MCServicePerformer: MCServicePerformerProtocol {
    func login(user: User,
               completion: @escaping ((Result<LoginModel, Error>) -> Void)) throws {
        
        let userUrl = baseUrl?.appendingPathComponent(MCConstants.Command.login)

        guard let url = userUrl else {
            completion(.failure(MCServiceError.couldNotCreate(url: userUrl?.absoluteString)))
            return
        }

        let request = { () -> MCURLRequest in
            try MCURLRequest
                .post(url: url)
                .with(body: [
                    MCConstants.Body.email: user.email,
                    MCConstants.Body.password: user.password,
                    MCConstants.Body.idfa: MCConstants.Body.Value.idfa
                ])
        }

        try makeRequest(request(),
                        map: LoginModel.self,
                        completion: completion)
    }

    func products(completion: @escaping ((Result<InvestorProductsModel, Error>) -> Void)) throws {

        let userUrl = baseUrl?.appendingPathComponent(MCConstants.Command.products)

        guard let url = userUrl else {
            completion(.failure(MCServiceError.couldNotCreate(url: userUrl?.absoluteString)))
            return
        }

        let request = { () -> MCURLRequest in
            MCURLRequest
                .get(url: url)
                .appendingHeaders([MCConstants.Headers.authorization: "\(MCConstants.Headers.bearer) \(authToken)"])
        }

        try makeRequest(request(),
                        map: InvestorProductsModel.self,
                        completion: completion)
    }
}
