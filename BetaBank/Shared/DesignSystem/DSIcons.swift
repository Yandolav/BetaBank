import UIKit

extension DS {
    enum Icons {
        enum Size {
            static let small: CGFloat = 16
            static let medium: CGFloat = 22
            static let large: CGFloat = 32
            static let xlarge: CGFloat = 48
        }

        enum Tint {
            static let primary = DS.Colors.accentColor
            static let secondary = DS.Colors.defaultTextColor
            static let success = DS.Colors.successColor
            static let error = DS.Colors.errorColor
            static let onAccent = DS.Colors.whiteText
        }

        // MARK: - Navigation

        static let profile = make("person.circle.fill", size: Size.medium, tint: Tint.primary)
        static let back = make("chevron.left", size: Size.medium, tint: Tint.primary)
        static let close = make("xmark", size: Size.medium, tint: Tint.secondary)

        // MARK: - Actions

        static let send = make("arrow.up.right", size: Size.small, tint: Tint.primary)
        static let add = make("plus", size: Size.small, tint: Tint.primary)
        static let clear = make("xmark.circle.fill", size: Size.small, tint: Tint.secondary)
        static let retry = make("arrow.clockwise", size: Size.medium, tint: Tint.primary)
        static let edit = make("pencil", size: Size.medium, tint: Tint.primary)
        static let delete = make("trash", size: Size.medium, tint: Tint.error)
        static let logout = make("rectangle.portrait.and.arrow.right", size: Size.medium, tint: Tint.error)

        // MARK: - Security

        static let passwordHidden = make("eye.slash.fill", size: Size.small, tint: Tint.primary)
        static let passwordVisible = make("eye.fill", size: Size.small, tint: Tint.primary)

        // MARK: - States

        static let empty = make("tray", size: Size.xlarge, tint: Tint.secondary)
        static let error = make("wifi.exclamationmark", size: Size.xlarge, tint: Tint.secondary)

        // MARK: - Transaction direction arrows

        static let creditArrow = "↓"
        static let debitArrow = "↑"

        // MARK: - Factory

        static func make(
            _ name: String,
            size: CGFloat = Size.medium,
            weight: UIImage.SymbolWeight = .medium,
            tint: UIColor = Tint.primary
        ) -> UIImage {
            UIImage(
                systemName: name,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: size,
                    weight: weight
                )
            )!.withTintColor(tint, renderingMode: .alwaysOriginal)
        }
    }
}
