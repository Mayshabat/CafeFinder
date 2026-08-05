//
//  CafeDetailsViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
//
import UIKit

class CafeDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!

    var cafe: Cafe?

    // מחיקה
    var onDelete: (() -> Void)?

    // עריכה
    var onEdit: ((Cafe) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let cafe = cafe {

            nameLabel.text = cafe.name
            cityLabel.text = cafe.city

            var stars = ""
            for i in 1...5 {
                stars += i <= cafe.rating ? "★" : "☆"
            }

            ratingLabel.text = stars
            notesTextView.text = cafe.notes
        }
    }

    // מעבר למסך העריכה
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let addVC = segue.destination as? AddCafeViewController {

            addVC.cafeToEdit = cafe

            addVC.onSave = { [weak self] editedCafe in
                self?.onEdit?(editedCafe)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    // כפתור Delete
    @IBAction func deletePressed(_ sender: UIButton) {

        onDelete?()

        navigationController?.popViewController(animated: true)
    }
}
