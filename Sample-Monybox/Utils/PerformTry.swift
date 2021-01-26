import Foundation

public func performTry<T>(_ function: () throws -> T,
                        fallback: @escaping (Error) -> T) -> T {
    do {
        return try function()
    } catch {
        return fallback(error)
    }
}
