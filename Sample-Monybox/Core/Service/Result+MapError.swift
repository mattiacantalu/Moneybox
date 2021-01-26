import Foundation

extension Result where Success == ErrorModel {
    func mapError<T: Decodable>(code: Int) -> (Result<T, Error>) {
        switch self {
        case .success(let model):
            return .failure(NSError(domain: "",
                                    code: code,
                                    userInfo: [NSLocalizedDescriptionKey: model.message]))
        case .failure(let error):
            return .failure(error)
        }
    }
}
