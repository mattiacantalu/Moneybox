import UIKit

extension UIViewController {
    func alert(title: String? = nil,
                      message: String? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: { _ in controller.dismiss(animated: true, completion: nil) })

        controller.addAction(action)

        present(controller, animated: true)
    }
}
