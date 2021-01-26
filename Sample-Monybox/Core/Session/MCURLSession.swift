import Foundation

protocol MCURLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

struct MCURLSession: MCURLSessionProtocol {
    private let session: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        session = urlSession
    }

    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: request) { responseData, urlResponse, responseError in
            completion(responseData, urlResponse, responseError)
        }

        task.resume()
    }
}
