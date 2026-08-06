//
//  AddCafeViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
import UIKit

class AddCafeViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var ratingStepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!

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
        title = "הוספת בית קפה"
        saveButton.setTitle("שמירה", for: .normal)
    }

    private func configureEditMode(with cafe: Cafe) {
        title = "עריכת בית קפה"
        saveButton.setTitle("עדכון", for: .normal)

        nameTextField.text = cafe.name
        cityTextField.text = cafe.city
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

        let notes = notesTextView.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !name.isEmpty else {
            showAlert(message: "יש להזין שם של בית קפה")
            return
        }

        guard !city.isEmpty else {
            showAlert(message: "יש להזין עיר")
            return
        }

        let cafe = Cafe(
            id: cafeToEdit?.id ?? UUID().uuidString,
            name: name,
            city: city,
            rating: Int(ratingStepper.value),
            notes: notes,
            createdAt: cafeToEdit?.createdAt ?? Date()
        )

        onSave?(cafe)

        navigationController?.popViewController(animated: true)
    }

    // MARK: - Appearance

    private func configureAppearance() {
        view.backgroundColor = .systemBackground

        nameTextField.backgroundColor = .secondarySystemBackground
        cityTextField.backgroundColor = .secondarySystemBackground
        notesTextView.backgroundColor = .secondarySystemBackground

        nameTextField.textColor = .label
        cityTextField.textColor = .label
        notesTextView.textColor = .label

        nameTextField.layer.cornerRadius = 10
        cityTextField.layer.cornerRadius = 10
        notesTextView.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 12

        ratingLabel.textColor = .systemOrange
    }

    // MARK: - Alert

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "שימי לב",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "אישור",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
