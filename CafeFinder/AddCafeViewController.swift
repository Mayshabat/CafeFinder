
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

    // מעביר את בית הקפה שנשמר למסך הקודם
    var onSave: ((Cafe) -> Void)?

    // אם קיים בית קפה - המסך נפתח במצב עריכה
    var cafeToEdit: Cafe?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureStepper()
        configureAppearance()
        configureScreen()
    }


    // MARK: - Screen Configuration

    // קובע אם המסך משמש להוספה או לעריכה
    private func configureScreen() {

        if let cafe = cafeToEdit {
            configureEditMode(with: cafe)
        } else {
            configureAddMode()
        }
    }

    // מצב הוספת בית קפה חדש
    private func configureAddMode() {

        title = "Add Cafe"

        saveButton.setTitle(
            "Save Cafe",
            for: .normal
        )
    }

    // מצב עריכת בית קפה קיים
    private func configureEditMode(
        with cafe: Cafe
    ) {

        title = "Edit Cafe"

        saveButton.setTitle(
            "Update Cafe",
            for: .normal
        )

        // הצגת הנתונים הקיימים בשדות
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

    // הגדרת דירוג בין 1 ל-5
    private func configureStepper() {

        ratingStepper.minimumValue = 1
        ratingStepper.maximumValue = 5
        ratingStepper.stepValue = 1
        ratingStepper.value = 1

        ratingStepper.tintColor =
            CafeAppTheme.Colors.primary

        updateRatingLabel(
            rating: 1
        )
    }

    // מופעל כאשר המשתמש משנה את הדירוג
    @IBAction func stepperChanged(
        _ sender: UIStepper
    ) {

        updateRatingLabel(
            rating: Int(sender.value)
        )
    }

    // עדכון הכוכבים לפי הדירוג שנבחר
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

        // סגירת המקלדת לפני השמירה
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
            notesTextView.text
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )


        // MARK: Validation

        // בדיקה שכל שדות החובה מולאו
        guard !name.isEmpty else {

            showAlert(
                message: "Please enter a cafe name"
            )

            return
        }

        guard !city.isEmpty else {

            showAlert(
                message: "Please enter a city"
            )

            return
        }

        guard !address.isEmpty else {

            showAlert(
                message: "Please enter an address"
            )

            return
        }


        // MARK: Create Cafe

        // יצירת בית קפה חדש או עדכון בית קפה קיים
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

            address: address,

            imageName:
                cafeToEdit?.imageName
                ?? "defaultCafe"
        )

        // העברת בית הקפה לצורך שמירה
        onSave?(cafe)

        // חזרה למסך הקודם
        navigationController?
            .popViewController(
                animated: true
            )
    }


    // MARK: - Appearance

    // הגדרת העיצוב הכללי של המסך
    private func configureAppearance() {

        // Background

        view.backgroundColor =
            CafeAppTheme.Colors.background


        // Text Fields

        CafeAppTheme.styleTextField(
            nameTextField
        )

        CafeAppTheme.styleTextField(
            cityTextField
        )

        CafeAppTheme.styleTextField(
            addressTextField
        )


        // Notes

        CafeAppTheme.styleTextView(
            notesTextView
        )


        // Save Button

        CafeAppTheme.stylePrimaryButton(
            saveButton
        )


        // Labels

        configureLabels()


        // Rating

        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        ratingLabel.font =
            UIFont.systemFont(
                ofSize: 22,
                weight: .semibold
            )


        // Placeholders

        configurePlaceholders()


        // Navigation Bar

        configureNavigationBar()
    }


    // MARK: - Labels

    // עיצוב הכותרות של שדות הקלט
    private func configureLabels() {

        let labels = [
            cafeNameLabel,
            cityLabel,
            addressLabel,
            notesLabel
        ]

        labels.forEach { label in

            label?.textColor =
                CafeAppTheme.Colors.darkBrown

            label?.font =
                UIFont.systemFont(
                    ofSize: 15,
                    weight: .semibold
                )
        }
    }


    // MARK: - Placeholders

    // הגדרת הטקסט שמופיע בתוך השדות לפני ההקלדה
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

    // התאמת העיצוב של סרגל הניווט
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

    // זיהוי מעבר בין מצב בהיר למצב כהה
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

    // עדכון צבעי המסך בהתאם למצב התצוגה
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

        configureLabels()

        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        ratingStepper.tintColor =
            CafeAppTheme.Colors.primary

        configurePlaceholders()
        configureNavigationBar()
    }


    // MARK: - Keyboard

    // סגירת המקלדת בלחיצה מחוץ לשדות
    @IBAction func dismissKeyboard(
        _ sender: UITapGestureRecognizer
    ) {

        view.endEditing(true)
    }


    // MARK: - Alert

    // הצגת הודעה כאשר חסר מידע
    private func showAlert(
        message: String
    ) {

        let alert =
            UIAlertController(
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

        present(
            alert,
            animated: true
        )
    }
}
