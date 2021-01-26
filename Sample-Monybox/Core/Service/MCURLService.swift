import Foundation

protocol MCURLServiceProtocol {
    func performTask(with request: URLRequest,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

struct MCURLService {
    private let session: MCURLSessionProtocol
    private let dispatcher: Dispatcher

    init(session: MCURLSessionProtocol = MCURLSession(),
         dispatcher: Dispatcher = DefaultDispatcher()) {
        self.session = session
        self.dispatcher = dispatcher
    }
}

extension MCURLService: MCURLServiceProtocol {
    func performTask(with request: URLRequest,
                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: request) { responseData, urlResponse, responseError in
            self.dispatcher.dispatch {
                completion(responseData, urlResponse, responseError)
            }
        }
    }
}
