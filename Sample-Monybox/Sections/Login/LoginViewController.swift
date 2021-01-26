import Foundation
import UIKit

protocol LoginViewProtocol {
    func show(error: Error?)
}

final class LoginViewController: UIViewController {
    var presenter: LoginPresenterProtocol?

    @IBOutlet weak var emailTxtField: UITextField?
    @IBOutlet weak var passwordTxtField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLoginBtn(_ sender: Any) {
        emailTxtField?.text = "test+ios@moneyboxapp.com"
        passwordTxtField?.text = "P455word12"
        presenter?.login(user: User(email: emailTxtField?.text ?? "",
                                    password: passwordTxtField?.text ?? ""))
    }
}

extension LoginViewController: LoginViewProtocol {
    func show(error: Error?) {
        alert(message: "Error \(error?.localizedDescription ?? "")")
    }
}
