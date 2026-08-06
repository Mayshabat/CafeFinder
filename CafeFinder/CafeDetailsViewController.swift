//
//  CafeDetailsViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
//

import UIKit
import FirebaseDatabase

class CafeDetailsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var viewsLabel: UILabel!

    // MARK: - Properties

    var cafe: Cafe?

    var onDelete: (() -> Void)?
    var onEdit: ((Cafe) -> Void)?

    private var viewsHandle: DatabaseHandle?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        displayCafeDetails()
        observeViews()
    }

    // MARK: - Display Data

    private func displayCafeDetails() {
        guard let cafe = cafe else {
            showError("לא נמצאו פרטי בית הקפה")
            return
        }

        title = cafe.name

        nameLabel.text = cafe.name
        cityLabel.text = cafe.city
        ratingLabel.text = createStars(for: cafe.rating)
        notesTextView.text = cafe.notes

        if cafe.notes.isEmpty {
            notesTextView.text = "לא נוספו הערות"
        }
    }

    private func createStars(for rating: Int) -> String {
        var stars = ""

        for index in 1...5 {
            stars += index <= rating ? "★" : "☆"
        }

        return stars
    }

    // MARK: - Realtime Database

    private func observeViews() {
        guard let cafe = cafe else { return }

        CafeRealtimeService.shared.incrementViews(for: cafe.id)

        viewsHandle = CafeRealtimeService.shared.observeViews(
            for: cafe.id
        ) { [weak self] views in
            DispatchQueue.main.async {
                self?.viewsLabel.text = "צפיות: \(views)"
            }
        }
    }

    // MARK: - Navigation

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        guard segue.identifier == "showEditCafe" else {
            return
        }

        if let addVC = segue.destination as? AddCafeViewController {
            configureEditScreen(addVC)
        } else if let navigationController =
                    segue.destination as? UINavigationController,
                  let addVC =
                    navigationController.topViewController
                    as? AddCafeViewController {

            configureEditScreen(addVC)
        }
    }

    private func configureEditScreen(
        _ addVC: AddCafeViewController
    ) {
        addVC.cafeToEdit = cafe

        addVC.onSave = { [weak self] editedCafe in
            guard let self = self else { return }

            self.cafe = editedCafe
            self.displayCafeDetails()
            self.onEdit?(editedCafe)
        }
    }

    // MARK: - Delete

    @IBAction func deletePressed(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "מחיקת בית קפה",
            message: "האם את בטוחה שברצונך למחוק את בית הקפה?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "ביטול",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "מחיקה",
                style: .destructive
            ) { [weak self] _ in
                self?.onDelete?()

                self?.navigationController?
                    .popViewController(animated: true)
            }
        )

        present(alert, animated: true)
    }

    // MARK: - Appearance

    private func configureAppearance() {
        view.backgroundColor = .systemBackground

        nameLabel.textColor = .label
        cityLabel.textColor = .secondaryLabel
        ratingLabel.textColor = .systemOrange
        viewsLabel.textColor = .secondaryLabel

        notesTextView.backgroundColor =
            .secondarySystemBackground

        notesTextView.textColor = .label
        notesTextView.layer.cornerRadius = 12
        notesTextView.isEditable = false
    }

    // MARK: - Error

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "שגיאה",
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

    // MARK: - Cleanup

    deinit {
        guard let cafe = cafe,
              let viewsHandle = viewsHandle else {
            return
        }

        CafeRealtimeService.shared.removeViewsObserver(
            for: cafe.id,
            handle: viewsHandle
        )
    }
}

