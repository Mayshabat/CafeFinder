//
//  AddCafeViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
//
import UIKit

class AddCafeViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var ratingStepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!

    // MARK: - Properties

    var onSave: ((Cafe) -> Void)?
    var cafeToEdit: Cafe?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureStepper()
        configureAppearance()
        configureScreen()
    }

    // MARK: - Screen Configuration

    private func configureStepper() {

        ratingStepper.minimumValue = 1
        ratingStepper.maximumValue = 5
        ratingStepper.stepValue = 1
        ratingStepper.value = 1

        ratingStepper.tintColor =
            CafeAppTheme.Colors.primary

        updateRatingLabel(rating: 1)
    }

    private func configureScreen() {

        if let cafe = cafeToEdit {
            configureEditMode(with: cafe)
        } else {
            configureAddMode()
        }
    }

    private func configureAddMode() {

        title = "Add Cafe"

        saveButton.setTitle(
            "Save Cafe",
            for: .normal
        )
    }

    private func configureEditMode(with cafe: Cafe) {

        title = "Edit Cafe"

        saveButton.setTitle(
            "Update Cafe",
            for: .normal
        )

        nameTextField.text = cafe.name
        cityTextField.text = cafe.city
        addressTextField.text = cafe.address
        notesTextView.text = cafe.notes

        ratingStepper.value =
            Double(cafe.rating)

        updateRatingLabel(
            rating: cafe.rating
        )
    }

    // MARK: - Rating

    @IBAction func stepperChanged(
        _ sender: UIStepper
    ) {

        let rating = Int(sender.value)

        updateRatingLabel(
            rating: rating
        )
    }

    private func updateRatingLabel(
        rating: Int
    ) {

        var stars = ""

        for index in 1...5 {

            stars +=
                index <= rating
                ? "★"
                : "☆"
        }

        ratingLabel.text = stars

        ratingLabel.textColor =
            CafeAppTheme.Colors.star
    }

    // MARK: - Save

    @IBAction func savePressed(
        _ sender: UIButton
    ) {

        view.endEditing(true)

        let name =
            nameTextField.text?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""

        let city =
            cityTextField.text?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""

        let address =
            addressTextField.text?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""

        let notes =
            notesTextView.text?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""

        guard !name.isEmpty else {

            showAlert(
                message:
                    "Please enter a cafe name"
            )

            return
        }

        guard !city.isEmpty else {

            showAlert(
                message:
                    "Please enter a city"
            )

            return
        }

        guard !address.isEmpty else {

            showAlert(
                message:
                    "Please enter an address"
            )

            return
        }

        let cafe = Cafe(
            id:
                cafeToEdit?.id
                ?? UUID().uuidString,

            name: name,

            city: city,

            rating:
                Int(ratingStepper.value),

            notes: notes,

            createdAt:
                cafeToEdit?.createdAt
                ?? Date(),

            address: address
        )

        onSave?(cafe)

        navigationController?
            .popViewController(
                animated: true
            )
    }

    // MARK: - Appearance

    private func configureAppearance() {

        // MARK: Background

        view.backgroundColor =
            CafeAppTheme.Colors.background

        // MARK: Text Fields

        CafeAppTheme.styleTextField(
            nameTextField
        )

        CafeAppTheme.styleTextField(
            cityTextField
        )

        CafeAppTheme.styleTextField(
            addressTextField
        )

        // MARK: Notes

        CafeAppTheme.styleTextView(
            notesTextView
        )

        // MARK: Save Button

        CafeAppTheme.stylePrimaryButton(
            saveButton
        )

        // MARK: Labels

        let labels = [
            cafeNameLabel,
            cityLabel,
            addressLabel,
            notesLabel
        ]

        labels.forEach { label in

            label?.textColor =
                CafeAppTheme
                    .Colors
                    .darkBrown

            label?.font =
                UIFont.systemFont(
                    ofSize: 15,
                    weight: .semibold
                )
        }

        // MARK: Rating

        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        ratingLabel.font =
            UIFont.systemFont(
                ofSize: 22,
                weight: .semibold
            )

        // MARK: Placeholders

        configurePlaceholders()

        // MARK: Navigation Bar

        configureNavigationBar()
    }

    // MARK: - Placeholders

    private func configurePlaceholders() {

        nameTextField.attributedPlaceholder =
            makePlaceholder(
                "Enter cafe name"
            )

        cityTextField.attributedPlaceholder =
            makePlaceholder(
                "Enter city"
            )

        addressTextField.attributedPlaceholder =
            makePlaceholder(
                "Enter full address"
            )
    }

    private func makePlaceholder(
        _ text: String
    ) -> NSAttributedString {

        return NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor:
                    CafeAppTheme
                        .Colors
                        .secondaryText
            ]
        )
    }

    // MARK: - Navigation Bar

    private func configureNavigationBar() {

        let appearance =
            UINavigationBarAppearance()

        appearance
            .configureWithOpaqueBackground()

        appearance.backgroundColor =
            CafeAppTheme.Colors.background

        appearance.titleTextAttributes = [
            .foregroundColor:
                CafeAppTheme
                    .Colors
                    .darkBrown,

            .font:
                UIFont.systemFont(
                    ofSize: 18,
                    weight: .bold
                )
        ]

        navigationController?
            .navigationBar
            .standardAppearance =
                appearance

        navigationController?
            .navigationBar
            .scrollEdgeAppearance =
                appearance

        navigationController?
            .navigationBar
            .compactAppearance =
                appearance

        navigationController?
            .navigationBar
            .tintColor =
                CafeAppTheme
                    .Colors
                    .primary
    }

    // MARK: - Dark Mode

    override func traitCollectionDidChange(
        _ previousTraitCollection:
            UITraitCollection?
    ) {

        super.traitCollectionDidChange(
            previousTraitCollection
        )

        if previousTraitCollection?
            .hasDifferentColorAppearance(
                comparedTo: traitCollection
            ) == true {

            updateDynamicAppearance()
        }
    }

    private func updateDynamicAppearance() {

        view.backgroundColor =
            CafeAppTheme.Colors.background

        CafeAppTheme.styleTextField(
            nameTextField
        )

        CafeAppTheme.styleTextField(
            cityTextField
        )

        CafeAppTheme.styleTextField(
            addressTextField
        )

        CafeAppTheme.styleTextView(
            notesTextView
        )

        CafeAppTheme.stylePrimaryButton(
            saveButton
        )

        cafeNameLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        cityLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        addressLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        notesLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        configurePlaceholders()
        configureNavigationBar()
    }

    // MARK: - Keyboard

    @IBAction func dismissKeyboard(
        _ sender: UITapGestureRecognizer
    ) {

        view.endEditing(true)
    }

    // MARK: - Alert

    private func showAlert(
        message: String
    ) {

        let alert =
            UIAlertController(
                title:
                    "Missing Information",

                message: message,

                preferredStyle:
                    .alert
            )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(
            alert,
            animated: true
        )
    }
}
