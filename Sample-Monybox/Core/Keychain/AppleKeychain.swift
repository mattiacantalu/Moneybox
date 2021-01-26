import Foundation

struct AppleKeychain {
    
    enum KeychainError: Error {
        case missingObject
        case unexpectedObjectData
        case unhandledError
    }
    
    let service: String
    let accessGroup: String?
    
    init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    func readObject<T: Codable>(for key: String) throws -> T? {
        var query = AppleKeychain.keychainQuery(withService: service, account: key, accessGroup: accessGroup)
        query[kSecReturnData as String] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)

        guard status != errSecItemNotFound else { throw KeychainError.missingObject }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        return try decode(queryResult as? Data)
    }
    
    func save<T: Codable>(object: T?, for key: String) throws {
        var queryResult: AnyObject?
        let query = AppleKeychain.keychainQuery(withService: service, account: key, accessGroup: accessGroup)

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &queryResult)

        if status == errSecItemNotFound {
            var newItem = AppleKeychain.keychainQuery(withService: service, account: key, accessGroup: accessGroup)
            do {
            let data = try JSONEncoder().encode(object)
                newItem[kSecValueData as String] = data
            } catch { throw KeychainError.unexpectedObjectData }
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        } else if status == errSecSuccess {
            let data = try? JSONEncoder().encode(object)
            
            let query = AppleKeychain.keychainQuery(withService: service, account: key, accessGroup: accessGroup)
            
            let updateDictionary = [kSecValueData as String: data]
            let status = SecItemUpdate(query as CFDictionary, updateDictionary as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func delete(key: String) throws {
        let query = AppleKeychain.keychainQuery(withService: service, account: key, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: Any] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword as AnyObject?
        query[kSecAttrService as String] = service as AnyObject?
        query[kSecAttrAccount as String] = account as AnyObject?
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    private func decode<T: Codable>(_ data: Data?) throws -> T? {
        guard let data = data else {
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NSError(domain: NSItemProvider.errorDomain,
                          code: -1001,
                          userInfo: [NSLocalizedDescriptionKey: "JSON decoding error: \(error.localizedDescription)"])
        }
    }
}
