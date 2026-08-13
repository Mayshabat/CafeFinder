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

        view.backgroundColor = CafeAppTheme.Colors.background

        CafeAppTheme.styleTextField(nameTextField)
        CafeAppTheme.styleTextField(cityTextField)
        CafeAppTheme.styleTextField(addressTextField)

        CafeAppTheme.styleTextView(notesTextView)
        CafeAppTheme.stylePrimaryButton(saveButton)
    }

    // MARK: - Screen Configuration

    private func configureStepper() {
        ratingStepper.minimumValue = 1
        ratingStepper.maximumValue = 5
        ratingStepper.stepValue = 1
        ratingStepper.value = 1

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
        saveButton.setTitle("Save Cafe", for: .normal)
    }

    private func configureEditMode(with cafe: Cafe) {
        saveButton.setTitle("Update Cafe", for: .normal)

        nameTextField.text = cafe.name
        cityTextField.text = cafe.city
        addressTextField.text = cafe.address
        notesTextView.text = cafe.notes

        ratingStepper.value = Double(cafe.rating)
        updateRatingLabel(rating: cafe.rating)
    }

    // MARK: - Rating

    @IBAction func stepperChanged(_ sender: UIStepper) {
        let rating = Int(sender.value)
        updateRatingLabel(rating: rating)
    }

    private func updateRatingLabel(rating: Int) {
        var stars = ""

        for index in 1...5 {
            stars += index <= rating ? "★" : "☆"
        }

        ratingLabel.text = stars
    }

    // MARK: - Save

    @IBAction func savePressed(_ sender: UIButton) {

        let name = nameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let city = cityTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let address = addressTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let notes = notesTextView.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !name.isEmpty else {
            showAlert(message: "Please enter a cafe name")
            return
        }

        guard !city.isEmpty else {
            showAlert(message: "Please enter a city")
            return
        }

        guard !address.isEmpty else {
            showAlert(message: "Please enter an address")
            return
        }

        let cafe = Cafe(
            id: cafeToEdit?.id ?? UUID().uuidString,
            name: name,
            city: city,
            rating: Int(ratingStepper.value),
            notes: notes,
            createdAt: cafeToEdit?.createdAt ?? Date(),
            address: address
        )

        onSave?(cafe)

        navigationController?
            .popViewController(animated: true)
    }

    // MARK: - Appearance

    private func configureAppearance() {

        // Backgrounds
        nameTextField.backgroundColor = .secondarySystemBackground
        cityTextField.backgroundColor = .secondarySystemBackground
        addressTextField.backgroundColor = .secondarySystemBackground
        notesTextView.backgroundColor = .secondarySystemBackground

        // Text colors
        nameTextField.textColor = CafeAppTheme.Colors.darkBrown
        cityTextField.textColor = CafeAppTheme.Colors.darkBrown
        addressTextField.textColor = CafeAppTheme.Colors.darkBrown
        notesTextView.textColor = CafeAppTheme.Colors.darkBrown

        // Labels
        cafeNameLabel.textColor = CafeAppTheme.Colors.darkBrown
        cityLabel.textColor = CafeAppTheme.Colors.darkBrown
        addressLabel.textColor = CafeAppTheme.Colors.darkBrown
        notesLabel.textColor = CafeAppTheme.Colors.darkBrown

        // Placeholders
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Name",
            attributes: [
                .foregroundColor: CafeAppTheme.Colors.secondaryText
            ]
        )

        cityTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter City",
            attributes: [
                .foregroundColor: CafeAppTheme.Colors.secondaryText
            ]
        )

        addressTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter full address",
            attributes: [
                .foregroundColor: CafeAppTheme.Colors.secondaryText
            ]
        )

        // Corners
        nameTextField.layer.cornerRadius = 10
        cityTextField.layer.cornerRadius = 10
        addressTextField.layer.cornerRadius = 10
        notesTextView.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 12

        // Rating
        ratingLabel.textColor = CafeAppTheme.Colors.star

        // Navigation
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()

        navAppearance.titleTextAttributes = [
            .foregroundColor: CafeAppTheme.Colors.darkBrown
        ]

        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
    }

    // MARK: - Alert

    private func showAlert(message: String) {

        let alert = UIAlertController(
            title: "Missing Information",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
