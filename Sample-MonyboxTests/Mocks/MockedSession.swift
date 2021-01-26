import Foundation
@testable import Sample_Moneybox

struct MockedSession: MCURLSessionProtocol {
    let data: Data?
    let response: URLResponse?
    let error: Error?

    let completionRequest: (URLRequest) -> Void

    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        completion(data, response, error)
        completionRequest(request)
    }

    static func simulate(failure error: Error,
                         completion: @escaping (URLRequest) -> Void) -> MCURLSessionProtocol {
        return MockedSession(data: nil,
                             response: nil,
                             error: error) { request in
                                completion(request)
        }
    }

    static func simulate(failure urlResponse: URLResponse?,
                         data: Data,
                         completion: @escaping (URLRequest) -> Void) -> MCURLSessionProtocol {
        return MockedSession(data: data,
                             response: urlResponse,
                             error: nil) { request in
                                completion(request)
        }
    }

    static func simulate(success data: Data,
                         completion: @escaping (URLRequest) -> Void) -> MCURLSessionProtocol {
        return MockedSession(data: data,
                             response: nil,
                             error: nil) { request in
                                completion(request)
        }
    }
}

enum MockedSessionError: Error {
    case badURL
    case badJSON
    case invalidResponse
}
