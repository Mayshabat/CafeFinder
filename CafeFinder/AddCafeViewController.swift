//
//  AddCafeViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
//
import UIKit

class AddCafeViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var ratingStepper: UIStepper!

    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func stepperChanged(_ sender: UIStepper) {

        let rating = Int(sender.value)

        var stars = ""

        for i in 1...5 {
            if i <= rating {
                stars += "★"
            } else {
                stars += "☆"
            }
        }

        ratingLabel.text = stars
    }
    var onSave: ((Cafe) -> Void)?
    var cafeToEdit: Cafe?
    var isEditingCafe = false
    @IBAction func savePressed(_ sender: UIButton) {
        
        print("save p")

        let cafe = Cafe(
            name: nameTextField.text ?? "",
            city: cityTextField.text ?? "",
            rating: Int(ratingStepper.value),
            notes: notesTextView.text
        )

        onSave?(cafe)
        print("onSave call")

        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingStepper.minimumValue = 1
        ratingStepper.maximumValue = 5
        ratingStepper.value = 1

        ratingLabel.text = "★☆☆☆☆"
        
        
        if let cafe = cafeToEdit {

            isEditingCafe = true
            title = "Edit Cafe"

            nameTextField.text = cafe.name
            cityTextField.text = cafe.city
            notesTextView.text = cafe.notes

            ratingStepper.value = Double(cafe.rating)

            var stars = ""
            for i in 1...5 {
                stars += i <= cafe.rating ? "⭐️" : "☆"
            }

            ratingLabel.text = stars
        }    }
    

}
