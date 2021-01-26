import Foundation

enum MCServiceError: Error {
    case unexpectedError(message: String)
    case noData
    case couldNotCreate(url: String?)
    case couldNotDecode(data: Data)
}
