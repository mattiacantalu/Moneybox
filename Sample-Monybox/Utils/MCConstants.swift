struct MCConstants {
    struct Headers {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        static let appVersion = "appVersion"
        static let apiVersion = "apiVersion"
        static let AppId = "AppId"
        static let bearer = "Bearer"
    }

    struct Command {
        static let login = "/users/login"
        static let products = "investorproducts"
    }
    
    struct Body {
        static let email = "Email"
        static let password = "Password"
        static let idfa = "Idfa"
        
        struct Value {
            static let idfa = "ANYTHING"
        }
    }

    struct Keychain {
        static let service = "com.mattiacantalu.Moneybox"
        static let account = "authorizationToken"
    }

    struct URL {
        static let base = "<base url>"
        static let statusCodeOk = 200
        static let statusCodemultipleChoice = 300
    }

    struct Error {
        static let responseError = "An error has occurred"
        static let noData = "No data fetched"
        static let wrongUrl = "Unexpected URL creation exception"
    }
}
