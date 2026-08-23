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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cafeImageView: UIImageView!

    // MARK: - Properties

    var cafe: Cafe?

    var onDelete: (() -> Void)?
    var onEdit: ((Cafe) -> Void)?

    private var viewsHandle: DatabaseHandle?

    private let geocoder = CLGeocoder()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        displayCafeDetails()
        showCafeLocation()
        observeViews()
    }

    // MARK: - Display Cafe

    private func displayCafeDetails() {

        guard let cafe = cafe else {

            showError(
                "Cafe details could not be found"
            )

            return
        }

        title = "Cafe Details"

        // Name

        nameLabel.text = cafe.name

        // City

        cityLabel.text = cafe.city

        // Address

        let cleanAddress =
            cafe.address.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        addressLabel.text =
            cleanAddress.isEmpty
            ? "No address added"
            : cleanAddress

        // Rating

        ratingLabel.text =
            createStars(
                for: cafe.rating
            )

        // Notes

        let cleanNotes =
            cafe.notes.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        notesTextView.text =
            cleanNotes.isEmpty
            ? "No notes added"
            : cleanNotes

        // Image

        cafeImageView.image =
            UIImage(named: cafe.imageName)
            ?? UIImage(named: "defaultCafe")
    }

    // MARK: - Rating

    private func createStars(
        for rating: Int
    ) -> String {

        var stars = ""

        for index in 1...5 {

            stars +=
                index <= rating
                ? "★"
                : "☆"
        }

        return stars
    }

    // MARK: - Realtime Database

    private func observeViews() {

        guard let cafe = cafe else {
            return
        }

        CafeRealtimeService.shared
            .incrementViews(
                for: cafe.id
            )

        viewsHandle =
            CafeRealtimeService.shared
                .observeViews(
                    for: cafe.id
                ) { [weak self] views in

                    DispatchQueue.main.async {

                        self?.viewsLabel.text =
                            "Views: \(views)"
                    }
                }
    }

    // MARK: - Navigation

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {

        guard
            segue.identifier == "showEditCafe"
        else {
            return
        }

        if let addVC =
            segue.destination
                as? AddCafeViewController {

            configureEditScreen(
                addVC
            )

        } else if
            let navigationController =
                segue.destination
                    as? UINavigationController,
            let addVC =
                navigationController
                    .topViewController
                    as? AddCafeViewController {

            configureEditScreen(
                addVC
            )
        }
    }

    private func configureEditScreen(
        _ addVC: AddCafeViewController
    ) {

        addVC.cafeToEdit = cafe

        addVC.onSave = {
            [weak self] editedCafe in

            guard let self = self else {
                return
            }

            self.cafe = editedCafe

            self.displayCafeDetails()

            self.showCafeLocation()

            self.onEdit?(editedCafe)
        }
    }

    // MARK: - Delete

    @IBAction func deletePressed(
        _ sender: UIButton
    ) {

        let alert =
            UIAlertController(
                title: "Delete Cafe",
                message:
                    "Are you sure you want to delete this cafe?",
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

                self?
                    .navigationController?
                    .popViewController(
                        animated: true
                    )
            }
        )

        present(
            alert,
            animated: true
        )
    }

    // MARK: - Map

    private func showCafeLocation() {

        guard let cafe = cafe else {
            return
        }

        let cleanAddress =
            cafe.address.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let cleanCity =
            cafe.city.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let fullAddress: String

        if cleanAddress.isEmpty {

            fullAddress = cleanCity

        } else if cleanCity.isEmpty {

            fullAddress = cleanAddress

        } else {

            fullAddress =
                "\(cleanAddress), \(cleanCity)"
        }

        guard !fullAddress.isEmpty else {

            mapView.removeAnnotations(
                mapView.annotations
            )

            return
        }

        // Cancel a previous geocoding request
        geocoder.cancelGeocode()

        geocoder.geocodeAddressString(
            fullAddress
        ) { [weak self] placemarks, error in

            guard let self = self else {
                return
            }

            if let error = error {

                // Ignore cancellation errors
                if (error as NSError).code !=
                    CLError.geocodeCanceled.rawValue {

                    print(
                        "Geocoding error:",
                        error.localizedDescription
                    )
                }

                return
            }

            guard
                let location =
                    placemarks?
                        .first?
                        .location
            else {
                return
            }

            let coordinate =
                location.coordinate

            DispatchQueue.main.async {

                // Remove previous pin

                self.mapView
                    .removeAnnotations(
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

                // Zoom to cafe

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

        // Background

        view.backgroundColor =
            CafeAppTheme.Colors.background

        // Cafe Image

        cafeImageView.contentMode =
            .scaleAspectFill

        cafeImageView.clipsToBounds =
            true

        cafeImageView.layer.cornerRadius =
            CafeAppTheme.Metrics.fieldRadius

        // Name

        nameLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        nameLabel.font =
            UIFont.systemFont(
                ofSize: 24,
                weight: .bold
            )

        nameLabel.numberOfLines = 0

        // City

        cityLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        cityLabel.font =
            UIFont.systemFont(
                ofSize: 17,
                weight: .medium
            )

        cityLabel.numberOfLines = 0

        // Address

        addressLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        addressLabel.font =
            UIFont.systemFont(
                ofSize: 14,
                weight: .regular
            )

        addressLabel.numberOfLines = 0

        // Rating

        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        ratingLabel.font =
            UIFont.systemFont(
                ofSize: 23,
                weight: .semibold
            )

        // Views

        viewsLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        viewsLabel.font =
            UIFont.systemFont(
                ofSize: 14,
                weight: .medium
            )

        // Notes

        CafeAppTheme.styleTextView(
            notesTextView
        )

        notesTextView.isEditable =
            false

        notesTextView.isSelectable =
            true

        // Map

        configureMapAppearance()

        // Navigation Bar

        configureNavigationBar()
    }

    // MARK: - Map Appearance

    private func configureMapAppearance() {

        mapView.layer.cornerRadius =
            CafeAppTheme.Metrics.fieldRadius

        mapView.layer.borderWidth = 1

        mapView.layer.borderColor =
            CafeAppTheme.Colors.border
                .resolvedColor(
                    with: traitCollection
                )
                .cgColor

        mapView.clipsToBounds =
            true
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

        nameLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        cityLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        addressLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        ratingLabel.textColor =
            CafeAppTheme.Colors.star

        viewsLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        CafeAppTheme.styleTextView(
            notesTextView
        )

        notesTextView.isEditable =
            false

        notesTextView.isSelectable =
            true

        configureMapAppearance()
        configureNavigationBar()
    }

    // MARK: - Error

    private func showError(
        _ message: String
    ) {

        let alert =
            UIAlertController(
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

        present(
            alert,
            animated: true
        )
    }

    // MARK: - Cleanup

    deinit {

        geocoder.cancelGeocode()

        guard
            let cafe = cafe,
            let viewsHandle = viewsHandle
        else {
            return
        }

        CafeRealtimeService.shared
            .removeViewsObserver(
                for: cafe.id,
                handle: viewsHandle
            )
    }
}
