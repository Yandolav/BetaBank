import UIKit

enum Theme {

    enum Colors {
        static let accentColor = UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1)
        static let unavailableСolor = UIColor(red: 0.949, green: 0.946, blue: 0.975, alpha: 1)

        static let whiteText = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        static let blueText = UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1)
        static let blackText = UIColor(red: 0.203, green: 0.203, blue: 0.203, alpha: 1)
        static let defaultTextColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1)
        static let placeholderTextColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)

        static let errorColor = UIColor(red: 0.898, green: 0.231, blue: 0.208, alpha: 1)
        static let successColor = UIColor(red: 0.157, green: 0.722, blue: 0.376, alpha: 1)
        static let focusColor = UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1)
        static let defaultBorderColor = UIColor(red: 0.795, green: 0.795, blue: 0.795, alpha: 1)
    }

    enum Fonts {
        static let title = UIFont.systemFont(ofSize: 24)

        static let body = UIFont.systemFont(ofSize: 16)

        static let caption = UIFont.systemFont(ofSize: 12)
    }
}
