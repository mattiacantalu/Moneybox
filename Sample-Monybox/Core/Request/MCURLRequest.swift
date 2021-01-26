import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct MCURLRequest {
    let url: URL
    let method: HTTPMethod
    let body: Data?
    let headers: [String: String]

    private init(url: URL,
                 method: HTTPMethod,
                 headers: [String: String] = [:],
                 body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }

    static func post(url: URL) -> MCURLRequest {
        MCURLRequest(url: url,
                     method: .post)
    }

    static func get(url: URL) -> MCURLRequest {
        MCURLRequest(url: url,
                     method: .get)
    }
}

extension MCURLRequest {
    func appendingHeaders(_ headers: [String: String]) -> MCURLRequest {
        MCURLRequest(url: url,
                     method: method,
                     headers: self.headers + headers,
                     body: body)
    }

    func with(body: [String: Any]?) throws -> MCURLRequest {
        guard let content = body else {
            return self
        }
        let data = try JSONSerialization.data(withJSONObject: content, options: [])
        return MCURLRequest(url: url,
                            method: method,
                            headers: headers,
                            body: data)
    }

    func build() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
}
