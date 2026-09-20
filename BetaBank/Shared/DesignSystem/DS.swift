import UIKit

enum DS {
    enum Colors {
        static let accentColor = UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1)
        static let accentInteractive = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.55, green: 0.50, blue: 0.95, alpha: 1)
                : UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1)
        }
        static let unavailableColor = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 0.25)
                : UIColor(red: 0.949, green: 0.946, blue: 0.975, alpha: 1)
        }

        static let background = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
                : UIColor.white
        }
        static let surfaceColor = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.17, green: 0.17, blue: 0.19, alpha: 1)
                : UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        }

        static let whiteText = UIColor.white
        static let blueText = UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1)
        static let blackText = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1)
                : UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1)
        }
        static let defaultTextColor = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.55, green: 0.55, blue: 0.58, alpha: 1)
                : UIColor(red: 0.50, green: 0.50, blue: 0.52, alpha: 1)
        }
        static let placeholderTextColor = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.40, green: 0.40, blue: 0.42, alpha: 1)
                : UIColor(red: 0.72, green: 0.72, blue: 0.74, alpha: 1)
        }

        static let errorColor = UIColor(red: 0.898, green: 0.231, blue: 0.208, alpha: 1)
        static let successColor = UIColor(red: 0.157, green: 0.722, blue: 0.376, alpha: 1)

        static let focusColor = UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1)
        static let defaultBorderColor = UIColor { t in
            t.userInterfaceStyle == .dark
                ? UIColor(red: 0.30, green: 0.30, blue: 0.32, alpha: 1)
                : UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)
        }
    }

    enum Fonts {
        static let largeTitle = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let title2 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let bodyMedium = UIFont.systemFont(ofSize: 15, weight: .medium)
        static let bodySemibold = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let caption = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let captionSemibold = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let caption2 = UIFont.systemFont(ofSize: 12, weight: .regular)

        static func monospaced(size: CGFloat = 15, weight: UIFont.Weight = .regular) -> UIFont {
            .monospacedSystemFont(ofSize: size, weight: weight)
        }
    }

    enum Spacing {
        static let xs: CGFloat = 5
        static let s: CGFloat = 8
        static let sm: CGFloat = 10
        static let m: CGFloat = 16
        static let l: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let section: CGFloat = 50
    }

    enum Radius {
        static let s: CGFloat = 8
        static let m: CGFloat = 15
        static let l: CGFloat = 20
        static let xl: CGFloat = 22
    }

    struct ShadowConfig {
        let color: UIColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat
    }

    enum Shadow {
        static let card = ShadowConfig(
            color: UIColor(red: 0.213, green: 0.161, blue: 0.717, alpha: 1),
            opacity: 0.4,
            offset: CGSize(width: 0, height: 10),
            radius: 18
        )
        static let modal = ShadowConfig(
            color: .black,
            opacity: 0.08,
            offset: CGSize(width: 0, height: 4),
            radius: 12
        )
    }
}

// MARK: - CALayer shadow helper

extension CALayer {
    func applyShadow(_ config: DS.ShadowConfig) {
        shadowColor = config.color.cgColor
        shadowOpacity = config.opacity
        shadowOffset = config.offset
        shadowRadius = config.radius
        masksToBounds = false
    }
}
