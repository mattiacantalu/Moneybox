import Foundation
import UIKit

protocol ProductsViewProtocol {
    func show(error: Error?)
    func load(user: UserModel, products: InvestorProductsModel)
}

final class ProductsViewController: UIViewController {
    var presenter: ProductsPresenterProtocol?

    @IBOutlet weak var logoutBtn: UIButton?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var userNameLabel: UILabel?
    @IBOutlet weak var planValueLabel: UILabel?
    
    private var products: [ProductModel]? {
        didSet {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.investorProducts()
    }

    @IBAction func onLogout(_ sender: Any) {
        presenter?.logout()
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell",
                                                      for: indexPath) as? ProductCell

        let product = products?[indexPath.row]
        cell?.stockNameLabel?.text = product?.product.friendlyName
        cell?.planValueLabel?.text = product?.planValue.priceValue
        cell?.moneyboxLabel?.text = product?.moneybox.priceValue

        return cell ?? UITableViewCell()
    }
}

extension ProductsViewController: ProductsViewProtocol {
    func show(error: Error?) {
        alert(message: "Error \(String(describing: error?.localizedDescription))")
    }

    func load(user: UserModel,
              products: InvestorProductsModel) {
        self.userNameLabel?.text = "Hello \(user.username)"
        self.planValueLabel?.text = products.totalPlanValue.priceValue
        self.products = products.products
    }
}

private extension Float {
     var priceValue: String {
       "\(self) $"
    }
}

private extension UserModel {
    var username: String {
        "\(firstName) \(lastName)"
    }
}
