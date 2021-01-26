# Moneybox

This demo app is an iOS allows a user login and retrieves all his investor products using Moneybox API. User session is saved securely inside the Apple Keychain while the products are fetched at each session.

This project is oriented toward the following patterns: 

✅ VIPER Architecture

✅ Protocol Oriented

✅ Functional Programming

✅ Clean Code

✅ Dependency Injection

✅ Unit Tests

The project contains 3 main sections:
1. Utils: utilities and extensions
2. Core: networking module
3. Sections: VIPER module

## HOW IT WORKS

### Network Layer

🔸 Facade

The core layer is managed by a facade

```
struct MCURLServiceFacade {
    private let configuration: MCURLConfiguration

    init(configuration: MCURLConfiguration) {
        self.configuration = configuration
    }

    var baseUrl: URL? {
        URL(string: configuration.baseUrl)
    }
    
    var authToken: String {
        configuration.keychain.userSession()?.session.bearerToken ?? ""
    }

    func makeRequest<T: Decodable>(_ request: MCURLRequest,
                                     map: T.Type,
                                     completion: @escaping ((Result<T, Error>) -> Void)) throws {
        
        let urlRequest = request
            .appendingHeaders(configuration.decorators)
            .build()

        configuration
            .service
            .performTask(with: urlRequest) { responseData, urlResponse, responseError in
                completion(self.makeDecode(response: responseData,
                                           urlResponse: urlResponse,
                                           map: map,
                                           error: responseError))
            }
    }

    private func makeDecode<T: Decodable>(response: Data?,
                                      urlResponse: URLResponse?,
                                      map: T.Type,
                                      error: Error?) -> (Result<T, Error>) {
        
        if let error = error { return (.failure(error)) }
        guard let jsonData = response else { return (.failure(MCServiceError.noData)) }
        
        let statusCode = urlResponse?.httpResponse?.statusCode ?? MCConstants.URL.statusCodeOk

        guard statusCode >= MCConstants.URL.statusCodeOk &&
                statusCode < MCConstants.URL.statusCodemultipleChoice else {
            return decode(response: jsonData,
                          map: ErrorModel.self)
                .mapError(code: statusCode)
        }

        return decode(response: jsonData,
                      map: map)
    }
    
    private func decode<T: Decodable>(response: Data,
                                          map: T.Type) -> (Result<T, Error>) {
        do {
            let decoded = try JSONDecoder().decode(map,
                                                   from: response)
            return (.success(decoded))
        } catch {
            return (.failure(error))
        }
    }
}
```

🔸 Command

Every service requests(e.g. GET/POST) is a specific comand for the presentation layer:

```
    func products(completion: @escaping ((Result<InvestorProductsModel, Error>) -> Void)) throws {

        let userUrl = baseUrl?.appendingPathComponent(MCConstants.Command.products)

        guard let url = userUrl else {
            completion(.failure(MCServiceError.couldNotCreate(url: userUrl?.absoluteString)))
            return
        }

        let request = { () -> MCURLRequest in
            MCURLRequest
                .get(url: url)
                .appendingHeaders([MCConstants.Headers.authorization: "\(MCConstants.Headers.bearer) \(authToken)"])
        }

        try makeRequest(request(),
                        map: InvestorProductsModel.self,
                        completion: completion)
    }
```

🔸 URLSession

`URLSession` is built over protocols

```
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
```
```
struct MCURLService {
    private let session: MCURLSessionProtocol
    private let dispatcher: Dispatcher

    init(session: MCURLSessionProtocol = MCURLSession(),
                dispatcher: Dispatcher = DefaultDispatcher()) {
        self.session = session
        self.dispatcher = dispatcher
    }
}

extension MCURLService: MCURLServiceProtocol {
    func performTask(with request: URLRequest,
                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: request) { responseData, urlResponse, responseError in
            self.dispatcher.dispatch {
                completion(responseData, urlResponse, responseError)
            }
        }
    }
}
```

### VIPER 
Each section is built over 4 files
1. Router (routing layer)
2. Presenter (view logic)
3. Interactor (business logic for a use case)
4. View (display data)


#### CONFIGURATION

The routing layer performs the injection:

🔸 Presenter

🔸 View

🔸 Interactor
```
struct ProductsRouter {
    let view: ProductsViewController?

    init(sessionConfig: MCURLConfiguration) {
        view = UIStoryboard(name: "Main",
                            bundle: nil)
                   .instantiateViewController(withIdentifier: "productsViewController") as? ProductsViewController

        let serviceFacade = MCURLServiceFacade(configuration: sessionConfig)
        let interactor = InvestorProductsInteractor(service: serviceFacade)
        let presenter = ProductsPresenter(view: view,
                                          productsInteractor: interactor,
                                          configuration: sessionConfig)

        interactor.presenter = presenter
        view?.presenter = presenter
    }
}
```

... building the main layers of the application:

🔸 View
```
view = UIStoryboard(name: "Main",
                    bundle: nil)
        .instantiateViewController(withIdentifier: "productsViewController") as? ProductsViewController
```

🔸 Service facade

```
let serviceFacade = MCURLServiceFacade(configuration: sessionConfig)
```

🔸 Interactor
```
let interactor = InvestorProductsInteractor(service: serviceFacade)
```

🔸 Presenter
```
let presenter = ProductsPresenter(view: view,
                                  productsInteractor: interactor,
                                  configuration: sessionConfig)
}
```


### VIPER FLOW

1. View calls Presenter:

    ```
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.investorProducts()
    }
    ```

2. Presenter performs Interactor call

    ```
    func investorProducts() {
        productsInteractor.perform()
    }
    ```

3. Interactor executes "business logic" and notifies Presenter

    ```
   func perform() {
        performTry({
            try service.products() { result in
                switch result {
                case .success(let response):
                    self.presenter?.investor(products: response)
                case .failure(let error):
                    if error.nsError.code == 401 {
                        self.presenter?.logout()
                        return
                    }
                    self.presenter?.on(error: error)
                }
            }
        }, fallback: { self.presenter?.on(error: $0) })
    }
    ```

4. Presenter revices data from interactor and notifies the view

    ```
    func investor(products: InvestorProductsModel) {
        view?.load(user: configuration.keychain.userSession()?.user ?? UserModel(),
                   products: products)
    }
    ```

5. View updates the UI
    ```
    func load(user: UserModel,
              products: InvestorProductsModel) {
        self.userNameLabel?.text = "Hello \(user.username)"
        self.planValueLabel?.text = products.totalPlanValue.priceValue
        self.products = products.products
    }
    ```

### TESTS

Each module is unit tested (mocks oriented): decoding, mapping, services, presenter, interactor and view (and utilies for sure). 

1. Presenter sample test

```
    func testInvestorProductFetched() {
        keychain?.userSessionHandler = {
            let user = UserModel(firstName: "firstname",
                                 lastName: "lastname",
                                 email: "email",
                                 mobileNumber: "000")
            let session = UserSessionModel(bearerToken: "")
            return LoginModel(user: user,
                              session: session)
        }

        view?.loadUserProductsHandler = {
            XCTAssertEqual($0.firstName, "firstname")
            XCTAssertEqual($0.lastName, "lastname")
            XCTAssertEqual($0.email, "email")
            XCTAssertEqual($0.mobileNumber, "000")
            XCTAssertEqual($1.totalPlanValue, 1.0)
        }

        let model = InvestorProductsModel(totalPlanValue: 1.0,
                                          products: [])
        sut?.investor(products: model)
        
        XCTAssertEqual(view?.counterLoadUserProducts, 1)
    }
```

2. Interactor sample test

```
    func testPerformShouldReturnInvestorProducts() {
        presenter?.investorFetchedProducts = {
            XCTAssertNotNil($0)
        }

        guard let data = JSONMock.loadJson(fromResource: "valid_investor_products") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) { _ in }
        create(session)
        
        sut?.perform()
        XCTAssertEqual(presenter?.counterInvestorFetchedProducts, 1)
        XCTAssertEqual(presenter?.counterOnError, 0)
        XCTAssertEqual(presenter?.counterLogout, 0)
    }
```

3. Request sample tests

```
    func testInvestorProductsRequest() {
        keychain?.userSessionHandler = {
            let user = UserModel(firstName: "",
                                 lastName: "",
                                 email: "",
                                 mobileNumber: "")
            let session = UserSessionModel(bearerToken: "TsMWRkbrcu3NGrpf84gi2+pg0iOMVymyKklmkY0oI84=")
            return LoginModel(user: user,
                              session: session)
        }

        guard let data = JSONMock.loadJson(fromResource: "valid_investor_products") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) {
            XCTAssertEqual($0.url?.absoluteString, "https://api-test02.moneyboxapp.com/investorproducts")
            XCTAssertEqual($0.httpMethod, "GET")

            let headers = $0.allHTTPHeaderFields
            XCTAssertEqual(headers?["AppId"], "8cb2237d0679ca88db6464")
            XCTAssertEqual(headers?["Content-Type"], "application/json")
            XCTAssertEqual(headers?["appVersion"], "7.10.0")
            XCTAssertEqual(headers?["apiVersion"], "3.0.0")
            XCTAssertEqual(headers?["Authorization"], "Bearer TsMWRkbrcu3NGrpf84gi2+pg0iOMVymyKklmkY0oI84=")

            XCTAssertNil($0.httpBody)
        }

        do {
            try MCURLServiceFacade(configuration: configure(session))
                .products { _ in }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
```

4. Response sample tests

```
    func testInvestorProductsResponseShouldSuccess() {
        guard let data = JSONMock.loadJson(fromResource: "valid_investor_products") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession(data: data, response: nil, error: nil) { _ in }

        do {
            try MCURLServiceFacade(configuration: configure(session))
                .products { result in
                    switch result {
                    case .success(let response):
                        XCTAssertEqual(response.totalPlanValue, 5651.960000)
                        let userProduct = response.products.first
                        XCTAssertEqual(userProduct?.planValue, 2693.80)
                        XCTAssertEqual(userProduct?.moneybox, 0.00)
                        XCTAssertEqual(userProduct?.product.friendlyName, "Stocks & Shares ISA")
                    case .failure(let error):
                        XCTFail("Should be success! Got: \(error)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
```

## REQUIREMENTS

• Xcode 12

• iOS 13+
