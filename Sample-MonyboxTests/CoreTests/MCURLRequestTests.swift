import XCTest
@testable import Sample_Moneybox

class MCURLRequestTests: XCTestCase {

    func testCreateRequest_withPost() {
        guard let url = URL(string: "https://sample.com") else {
            XCTFail("URL error!")
            return
        }
        do {
            let request = try create(MCURLRequest.post(url: url))
            XCTAssertEqual(request.url.absoluteString, "https://sample.com")
            XCTAssertEqual(request.method.rawValue, "POST")
            XCTAssertEqual(request.body?.toDict()["bKey"], "bValue")
            XCTAssertEqual(request.headers["hKey"], "hValue")
        } catch {
            XCTFail("Got error. Success expected!")
        }
    }

    func testCreateRequest_withGet() {
        guard let url = URL(string: "https://sample.com") else {
            XCTFail("URL error!")
            return
        }
        do {
            let request = try create(MCURLRequest.get(url: url))
            XCTAssertEqual(request.url.absoluteString, "https://sample.com")
            XCTAssertEqual(request.method.rawValue, "GET")
            XCTAssertEqual(request.body?.toDict()["bKey"], "bValue")
            XCTAssertEqual(request.headers["hKey"], "hValue")
        } catch {
            XCTFail("Got error. Success expected!")
        }
    }
    
    private func create(_ request: MCURLRequest) throws -> MCURLRequest {
        return try request
            .with(body: ["bKey": "bValue"])
            .appendingHeaders(["hKey": "hValue"])
    }
}

extension Data {
    func toDict() -> [String: String] {
        guard let data = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: String] else {
            return [:]
        }
        return data
    }
}
