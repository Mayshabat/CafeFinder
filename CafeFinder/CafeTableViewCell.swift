////
//  CafeTableViewCell.swift
//  CafeFinder
//
//  Created by Student14 on 12/08/2026.
//

import UIKit

class CafeTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        configureAppearance()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cafeNameLabel.text = nil
        cityLabel.text = nil
        ratingLabel.text = nil
    }

    // MARK: - Appearance

    private func configureAppearance() {

        // Cell
        backgroundColor = .clear
        selectionStyle = .none

        // Card
        contentView.backgroundColor =
            CafeAppTheme.Colors.card

        contentView.layer.cornerRadius =
            CafeAppTheme.Metrics.cardRadius

        contentView.layer.borderWidth = 1

        contentView.layer.borderColor =
            CafeAppTheme.Colors.border.cgColor

        contentView.layer.masksToBounds = true

        // Space around card
        contentView.directionalLayoutMargins =
            NSDirectionalEdgeInsets(
                top: 8,
                leading: 16,
                bottom: 8,
                trailing: 16
            )

        // Cafe Name
        cafeNameLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        cafeNameLabel.font =
            UIFont.systemFont(
                ofSize: 18,
                weight: .bold
            )

        cafeNameLabel.numberOfLines = 1

        // City
        cityLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        cityLabel.font =
            UIFont.systemFont(
                ofSize: 14,
                weight: .regular
            )

        cityLabel.numberOfLines = 1

        // Rating
        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        ratingLabel.font =
            UIFont.systemFont(
                ofSize: 16,
                weight: .semibold
            )

        ratingLabel.numberOfLines = 1
    }

    // MARK: - Dark Mode Changes

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(
            previousTraitCollection
        )

        if previousTraitCollection?
            .hasDifferentColorAppearance(
                comparedTo: traitCollection
            ) == true {

            updateDynamicColors()
        }
    }

    private func updateDynamicColors() {

        contentView.backgroundColor =
            CafeAppTheme.Colors.card

        contentView.layer.borderColor =
            CafeAppTheme.Colors.border
                .resolvedColor(
                    with: traitCollection
                )
                .cgColor

        cafeNameLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        cityLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        ratingLabel.textColor =
            CafeAppTheme.Colors.star
    }
}
