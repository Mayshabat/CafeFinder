//
//  CafeDetailsViewController.swift
//  CafeFinder
//

import UIKit
import FirebaseDatabase
import MapKit
import CoreLocation

class CafeDetailsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

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
        showCafeLocation()
        observeViews()
    }

    // MARK: - Display Data

    private func displayCafeDetails() {
        guard let cafe = cafe else {
            showError("Cafe details could not be found")
            return
        }

        nameLabel.text = cafe.name
        cityLabel.text = cafe.city
        ratingLabel.text = createStars(for: cafe.rating)

        if cafe.notes.isEmpty {
            notesTextView.text = "No notes added"
        } else {
            notesTextView.text = cafe.notes
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
                self?.viewsLabel.text = "Views: \(views)"
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

        if let addVC =
            segue.destination as? AddCafeViewController {

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

            // Refresh the map after editing the address
            self.showCafeLocation()

            self.onEdit?(editedCafe)
        }
    }

    // MARK: - Delete

    @IBAction func deletePressed(_ sender: UIButton) {

        let alert = UIAlertController(
            title: "Delete Cafe",
            message: "Are you sure you want to delete this cafe?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive
            ) { [weak self] _ in

                self?.onDelete?()

                self?.navigationController?
                    .popViewController(animated: true)
            }
        )

        present(alert, animated: true)
    }

    // MARK: - Map

    private func showCafeLocation() {
        guard let cafe = cafe else { return }

        let cleanAddress = cafe.address
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let cleanCity = cafe.city
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let fullAddress: String

        if cleanAddress.isEmpty {
            fullAddress = cleanCity
        } else {
            fullAddress = "\(cleanAddress), \(cleanCity)"
        }

        guard !fullAddress.isEmpty else {
            print("No address available")
            return
        }

        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(
            fullAddress
        ) { [weak self] placemarks, error in

            guard let self = self else { return }

            if let error = error {
                print(
                    "Geocoding error:",
                    error.localizedDescription
                )
                return
            }

            guard let location =
                placemarks?.first?.location else {

                print("Location not found")
                return
            }

            let coordinate =
                location.coordinate

            DispatchQueue.main.async {

                // Remove previous pin
                self.mapView.removeAnnotations(
                    self.mapView.annotations
                )

                // Create new pin
                let annotation =
                    MKPointAnnotation()

                annotation.coordinate =
                    coordinate

                annotation.title =
                    cafe.name

                annotation.subtitle =
                    fullAddress

                self.mapView.addAnnotation(
                    annotation
                )

                // Zoom closer to the exact address
                let region =
                    MKCoordinateRegion(
                        center: coordinate,
                        latitudinalMeters: 700,
                        longitudinalMeters: 700
                    )

                self.mapView.setRegion(
                    region,
                    animated: true
                )

                self.mapView.selectAnnotation(
                    annotation,
                    animated: true
                )
            }
        }
    }

    // MARK: - Appearance

    private func configureAppearance() {

        view.backgroundColor =
            CafeAppTheme.Colors.background

        nameLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        cityLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        viewsLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        nameLabel.font =
            UIFont.systemFont(
                ofSize: 22,
                weight: .bold
            )

        cityLabel.font =
            UIFont.systemFont(
                ofSize: 17,
                weight: .medium
            )

        ratingLabel.font =
            UIFont.systemFont(
                ofSize: 24
            )

        notesTextView.backgroundColor =
            CafeAppTheme.Colors.card

        notesTextView.textColor =
            CafeAppTheme.Colors.darkBrown

        notesTextView.layer.cornerRadius =
            CafeAppTheme.Metrics.fieldRadius

        notesTextView.layer.borderWidth = 1

        notesTextView.layer.borderColor =
            CafeAppTheme.Colors.secondaryText
                .withAlphaComponent(0.25)
                .cgColor

        notesTextView.textContainerInset =
            UIEdgeInsets(
                top: 12,
                left: 12,
                bottom: 12,
                right: 12
            )

        notesTextView.isEditable = false

        // Map appearance
        mapView.layer.cornerRadius =
            CafeAppTheme.Metrics.fieldRadius

        mapView.clipsToBounds = true
    }

    // MARK: - Error

    private func showError(_ message: String) {

        let alert = UIAlertController(
            title: "Error",
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
