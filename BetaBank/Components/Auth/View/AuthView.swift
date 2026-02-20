import UIKit

protocol AuthViewDelegate: AnyObject {
    func didTapSignIn(email: String, password: String)
    func didTapSignUp(firstName: String, lastName: String, email: String, password: String)
}

final class AuthView: UIView {

    // MARK: Public properties

    weak var delegate: AuthViewDelegate?
}
