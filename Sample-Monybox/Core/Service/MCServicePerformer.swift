import Foundation

protocol MCServicePerformerProtocol {
    func login(user: User,
               completion: @escaping ((Result<LoginModel, Error>) -> Void)) throws
    func products(completion: @escaping ((Result<InvestorProductsModel, Error>) -> Void)) throws
}

struct MCServicePerformer {
    private let configuration: MCURLConfiguration

    init(configuration: MCURLConfiguration) {
        self.configuration = configuration
    }

    var baseUrl: URL? {
        URL(string: configuration.baseUrl)
    }
    
    var authToken: String {
        configuration.keychain.userSession()?.session.bearerToken ?? ""
    }

    func makeRequest<T: Decodable>(_ request: MCURLRequest,
                                     map: T.Type,
                                     completion: @escaping ((Result<T, Error>) -> Void)) throws {
        
        let urlRequest = request
            .appendingHeaders(configuration.decorators)
            .build()

        configuration
            .service
            .performTask(with: urlRequest) { responseData, urlResponse, responseError in
                completion(self.makeDecode(response: responseData,
                                           urlResponse: urlResponse,
                                           map: map,
                                           error: responseError))
            }
    }

    private func makeDecode<T: Decodable>(response: Data?,
                                      urlResponse: URLResponse?,
                                      map: T.Type,
                                      error: Error?) -> (Result<T, Error>) {
        
        if let error = error { return (.failure(error)) }
        guard let jsonData = response else { return (.failure(MCServiceError.noData)) }
        
        let statusCode = urlResponse?.httpResponse?.statusCode ?? MCConstants.URL.statusCodeOk

        guard statusCode >= MCConstants.URL.statusCodeOk &&
                statusCode < MCConstants.URL.statusCodemultipleChoice else {
            return decode(response: jsonData,
                          map: ErrorModel.self)
                .mapError(code: statusCode)
        }

        return decode(response: jsonData,
                      map: map)
    }
    
    private func decode<T: Decodable>(response: Data,
                                          map: T.Type) -> (Result<T, Error>) {
        do {
            let decoded = try JSONDecoder().decode(map,
                                                   from: response)
            return (.success(decoded))
        } catch {
            return (.failure(error))
        }
    }
}

private extension URLResponse {
    var httpResponse: HTTPURLResponse? {
        self as? HTTPURLResponse
    }
}
