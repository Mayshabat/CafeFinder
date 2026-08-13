//
//  CafeAppTheme.swift
//  CafeFinder
//
//  Created by Student14 on 10/08/2026.
//
import UIKit

enum CafeAppTheme {

    // MARK: - Colors

    enum Colors {
        static let background = UIColor(
            red: 248 / 255,
            green: 245 / 255,
            blue: 240 / 255,
            alpha: 1
        )

        static let card = UIColor.white

        static let primary = UIColor(
            red: 123 / 255,
            green: 85 / 255,
            blue: 66 / 255,
            alpha: 1
        )

        static let darkBrown = UIColor(
            red: 58 / 255,
            green: 41 / 255,
            blue: 33 / 255,
            alpha: 1
        )

        static let secondaryText = UIColor(
            red: 138 / 255,
            green: 129 / 255,
            blue: 123 / 255,
            alpha: 1
        )

        static let star = UIColor(
            red: 242 / 255,
            green: 166 / 255,
            blue: 61 / 255,
            alpha: 1
        )
    }

    // MARK: - Sizes

    enum Metrics {
        static let cardRadius: CGFloat = 18
        static let fieldRadius: CGFloat = 12
        static let buttonRadius: CGFloat = 14

        static let cardPadding: CGFloat = 16
        static let standardSpacing: CGFloat = 12
    }

    // MARK: - Text Fields

    static func styleTextField(_ textField: UITextField) {

        textField.backgroundColor = Colors.card
        textField.textColor = Colors.darkBrown
        textField.font = UIFont.systemFont(ofSize: 16)

        textField.layer.cornerRadius = Metrics.fieldRadius
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.secondaryText.withAlphaComponent(0.25).cgColor

        textField.layer.masksToBounds = true

        textField.leftView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 12,
            height: 1
        ))

        textField.leftViewMode = .always
    }

    // MARK: - Text View

    static func styleTextView(_ textView: UITextView) {

        textView.backgroundColor = Colors.card
        textView.textColor = Colors.darkBrown
        textView.font = UIFont.systemFont(ofSize: 15)

        textView.layer.cornerRadius = Metrics.fieldRadius
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Colors.secondaryText.withAlphaComponent(0.25).cgColor

        textView.layer.masksToBounds = true

        textView.textContainerInset = UIEdgeInsets(
            top: 12,
            left: 12,
            bottom: 12,
            right: 12
        )
    }

    // MARK: - Primary Button

    static func stylePrimaryButton(_ button: UIButton) {

        button.backgroundColor = Colors.primary
        button.setTitleColor(.white, for: .normal)

        button.titleLabel?.font = UIFont.systemFont(
            ofSize: 17,
            weight: .semibold
        )

        button.layer.cornerRadius = Metrics.buttonRadius

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.12
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8

        button.layer.masksToBounds = false
    }

    // MARK: - Card

    static func styleCard(_ view: UIView) {

        view.backgroundColor = Colors.card

        view.layer.cornerRadius = Metrics.cardRadius

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10

        view.layer.masksToBounds = false
    }
}
