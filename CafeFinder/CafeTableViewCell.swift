//
//  CafeTableViewCell.swift
//  CafeFinder
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

        // הגדרת העיצוב כאשר התא נטען
        configureAppearance()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // ניקוי הנתונים לפני שימוש חוזר בתא
        cafeNameLabel.text = nil
        cityLabel.text = nil
        ratingLabel.text = nil
    }


    // MARK: - Appearance

    // הגדרת העיצוב של תא בית הקפה
    private func configureAppearance() {

        // Cell

        backgroundColor = .clear
        selectionStyle = .none


        // Card

        // עיצוב התא ככרטיס
        contentView.backgroundColor =
            CafeAppTheme.Colors.card

        contentView.layer.cornerRadius =
            CafeAppTheme.Metrics.cardRadius

        contentView.layer.borderWidth = 1

        contentView.layer.borderColor =
            CafeAppTheme.Colors.border
                .resolvedColor(
                    with: traitCollection
                )
                .cgColor

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


    // MARK: - Dark Mode

    // זיהוי מעבר בין מצב בהיר למצב כהה
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

    // עדכון צבעי התא בהתאם למצב התצוגה
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
