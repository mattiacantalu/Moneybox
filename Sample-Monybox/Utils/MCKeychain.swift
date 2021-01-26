import Foundation

protocol MCKeychainProtocol {
    func userSession() -> LoginModel?
    func user(session: LoginModel)
    func clearSession()
}

extension AppleKeychain: MCKeychainProtocol {
    func userSession() -> LoginModel? {
        let session = try? readObject(for: "userSession") as LoginModel?
        return session
    }

    func user(session: LoginModel) {
        do {
             return try save(object: session, for: "userSession")
        } catch {
            print("Unable to save user session into keychain")
        }
    }

    func clearSession() {
        do {
            try delete(key: "userSession")
        } catch {
            print("Unable to delete user session from keychain")
        }
    }
}
