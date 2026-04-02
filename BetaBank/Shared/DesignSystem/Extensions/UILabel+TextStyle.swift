import UIKit

enum TextStyle {
    case largeTitle
    case title
    case title2
    case body
    case lightBody
    case bodySemibold
    case bodyMedium
    case caption
    case captionSemibold
    case caption2
    case error
    case link
    case monospacedBody
    case monospacedCaption
    case lightTitle
    case lightTitle2
    case lightCaption
    case lightMonospacedBody
    case lightMonospacedCaption
}

extension UILabel {
    func apply(_ style: TextStyle) {
        switch style {
        case .largeTitle:
            font = DS.Fonts.largeTitle
            textColor = DS.Colors.blackText
        case .title:
            font = DS.Fonts.title
            textColor = DS.Colors.blackText
        case .title2:
            font = DS.Fonts.title2
            textColor = DS.Colors.blackText
        case .body:
            font = DS.Fonts.body
            textColor = DS.Colors.blackText
        case .lightBody:
            font = DS.Fonts.body
            textColor = DS.Colors.whiteText
        case .bodySemibold:
            font = DS.Fonts.bodySemibold
            textColor = DS.Colors.blackText
        case .bodyMedium:
            font = DS.Fonts.bodyMedium
            textColor = DS.Colors.blackText
        case .caption:
            font = DS.Fonts.caption
            textColor = DS.Colors.defaultTextColor
        case .captionSemibold:
            font = DS.Fonts.captionSemibold
            textColor = DS.Colors.defaultTextColor
        case .caption2:
            font = DS.Fonts.caption2
            textColor = DS.Colors.defaultTextColor
        case .error:
            font = DS.Fonts.caption
            textColor = DS.Colors.errorColor
        case .link:
            font = DS.Fonts.caption
            textColor = DS.Colors.accentColor
        case .monospacedBody:
            font = DS.Fonts.monospaced(size: 15)
            textColor = DS.Colors.blackText
        case .monospacedCaption:
            font = DS.Fonts.monospaced(size: 13)
            textColor = DS.Colors.defaultTextColor
        case .lightTitle:
            font = DS.Fonts.title
            textColor = DS.Colors.whiteText
        case .lightTitle2:
            font = DS.Fonts.title2
            textColor = DS.Colors.whiteText
        case .lightCaption:
            font = DS.Fonts.caption
            textColor = DS.Colors.whiteText.withAlphaComponent(0.7)
        case .lightMonospacedBody:
            font = DS.Fonts.monospaced(size: 15)
            textColor = DS.Colors.whiteText.withAlphaComponent(0.85)
        case .lightMonospacedCaption:
            font = DS.Fonts.monospaced(size: 13, weight: .medium)
            textColor = DS.Colors.whiteText.withAlphaComponent(0.75)
        }
    }
}
