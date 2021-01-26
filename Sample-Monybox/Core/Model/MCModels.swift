import Foundation

struct LoginModel: Codable {
    let user: UserModel
    let session: UserSessionModel

    private enum CodingKeys : String, CodingKey {
        case user = "User",
             session = "Session"
    }
}

struct UserModel: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let mobileNumber: String?

    private enum CodingKeys : String, CodingKey {
        case firstName = "FirstName",
             lastName = "LastName",
             email = "Email",
             mobileNumber = "MobileNumber"
    }
}

struct UserSessionModel: Codable {
    let bearerToken: String

    private enum CodingKeys : String, CodingKey {
        case bearerToken = "BearerToken"
    }
}

struct InvestorProductsModel: Codable {
    let totalPlanValue: Float
    let products: [ProductModel]
    
    private enum CodingKeys : String, CodingKey {
        case totalPlanValue = "TotalPlanValue",
             products = "ProductResponses"
    }
}

struct ProductModel: Codable {
    let planValue: Float
    let moneybox: Float
    let product: ProductName
    
    private enum CodingKeys : String, CodingKey {
        case planValue = "PlanValue",
             moneybox = "Moneybox",
             product = "Product"
    }
}

struct ProductName: Codable {
    let friendlyName: String
    
    private enum CodingKeys : String, CodingKey {
        case friendlyName = "FriendlyName"
    }
}

struct ErrorModel: Codable {
    let name: String
    let message: String

    private enum CodingKeys : String, CodingKey {
        case name = "Name",
             message = "Message"
    }
}
