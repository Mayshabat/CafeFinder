//
//  CafeListViewController.swift
//  CafeFinder
//

import UIKit
import FirebaseFirestore

class CafeListViewController: UIViewController,
                              UITableViewDelegate,
                              UITableViewDataSource,
                              UISearchBarDelegate {

    // MARK: - Outlets

    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    private var cafes: [Cafe] = []
    private var filteredCafes: [Cafe] = []
    private var isSearching = false

    private var cafesListener: ListenerRegistration?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        configureAppearance()

        emptyStateLabel.isHidden = true

        observeCafes()
    }

    // MARK: - Firestore

    private func observeCafes() {

        cafesListener =
            CafeFirestoreService.shared.observeCafes {
                [weak self] result in

                DispatchQueue.main.async {

                    guard let self = self else {
                        return
                    }

                    switch result {

                    case .success(let cafes):

                        self.cafes = cafes

                        self.updateSearchResults()

                        self.tableView.reloadData()
                        self.updateEmptyState()

                    case .failure(let error):

                        self.showError(
                            error.localizedDescription
                        )
                    }
                }
            }
    }

    // MARK: - Search

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {

        updateSearchResults(
            with: searchText
        )

        tableView.reloadData()
        updateEmptyState()
    }

    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {

        searchBar.resignFirstResponder()
    }

    private func updateSearchResults(
        with text: String? = nil
    ) {

        let searchText =
            text ?? searchBar.text ?? ""

        let cleanText =
            searchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        if cleanText.isEmpty {

            isSearching = false
            filteredCafes = cafes

        } else {

            isSearching = true

            filteredCafes =
                cafes.filter { cafe in

                    cafe.name
                        .localizedCaseInsensitiveContains(
                            cleanText
                        )

                    ||

                    cafe.city
                        .localizedCaseInsensitiveContains(
                            cleanText
                        )

                    ||

                    cafe.address
                        .localizedCaseInsensitiveContains(
                            cleanText
                        )
                }
        }
    }

    // MARK: - Empty State

    private func updateEmptyState() {

        let displayedCafes =
            isSearching
            ? filteredCafes
            : cafes

        emptyStateLabel.isHidden =
            !displayedCafes.isEmpty
    }

    // MARK: - Navigation

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {

        // MARK: Add Cafe

        if segue.identifier == "showAddCafe" {

            let addVC: AddCafeViewController?

            if let directAddVC =
                segue.destination
                    as? AddCafeViewController {

                addVC = directAddVC

            } else if let navigationController =
                        segue.destination
                            as? UINavigationController {

                addVC =
                    navigationController
                        .topViewController
                        as? AddCafeViewController

            } else {

                addVC = nil
            }

            guard let addVC = addVC else {
                return
            }

            addVC.onSave = {
                [weak self] cafe in

                guard let self = self else {
                    return
                }

                var newCafe = cafe

                newCafe.imageName =
                    self.randomAvailableImageName()

                CafeFirestoreService.shared
                    .addCafe(newCafe) { error in

                        DispatchQueue.main.async {

                            if let error = error {

                                self.showError(
                                    error.localizedDescription
                                )
                            }
                        }
                    }
            }
        }

        // MARK: Cafe Details

        else if segue.identifier == "showDetails",
                let detailsVC =
                    segue.destination
                        as? CafeDetailsViewController,
                let cafe = sender as? Cafe {

            detailsVC.cafe = cafe

            // Delete
            detailsVC.onDelete = {
                [weak self] in

                CafeFirestoreService.shared
                    .deleteCafe(
                        id: cafe.id
                    ) { error in

                        DispatchQueue.main.async {

                            if let error = error {

                                self?.showError(
                                    error.localizedDescription
                                )
                            }
                        }
                    }
            }

            // Edit
            detailsVC.onEdit = {
                [weak self] editedCafe in

                CafeFirestoreService.shared
                    .updateCafe(
                        editedCafe
                    ) { error in

                        DispatchQueue.main.async {

                            if let error = error {

                                self?.showError(
                                    error.localizedDescription
                                )
                            }
                        }
                    }
            }
        }
    }

    // MARK: - Random Cafe Image

    private func randomAvailableImageName() -> String {

        let allImages = [
            "cafe1",
            "cafe2",
            "cafe3",
            "cafe4",
            "cafe5",
            "cafe6"
        ]

        let usedImages =
            Set(
                cafes.map {
                    $0.imageName
                }
            )

        let availableImages =
            allImages.filter {
                !usedImages.contains($0)
            }

        // Use an unused image first
        if let image =
            availableImages.randomElement() {

            return image
        }

        // If all images are already used,
        // allow random reuse
        return allImages.randomElement()
            ?? "defaultCafe"
    }

    // MARK: - Table View Data Source

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return displayedCafes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: "CafeCell",
                    for: indexPath
                ) as? CafeTableViewCell
        else {
            return UITableViewCell()
        }

        let cafe =
            displayedCafes[indexPath.row]

        // Cafe Name
        cell.cafeNameLabel.text =
            cafe.name

        // City
        cell.cityLabel.text =
            cafe.city

        // Rating
        cell.ratingLabel.text =
            createStars(
                for: cafe.rating
            )

        return cell
    }

    // MARK: - Table View Delegate

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        let selectedCafe =
            displayedCafes[indexPath.row]

        performSegue(
            withIdentifier: "showDetails",
            sender: selectedCafe
        )
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {

        return 90
    }

    // MARK: - Helpers

    private var displayedCafes: [Cafe] {

        return isSearching
            ? filteredCafes
            : cafes
    }

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

    // MARK: - Appearance
    // מצב לילה - המערכת קוראת לפונקציה כאשר מאפייני התצוגה משתנים
    private func configureAppearance() {

        // Search Bar
        searchBar.backgroundImage =
            UIImage()

        searchBar.barTintColor =
            .clear

        searchBar.backgroundColor =
            .clear

        searchBar.searchTextField.backgroundColor =
            CafeAppTheme.Colors.card

        searchBar.searchTextField.textColor =
            CafeAppTheme.Colors.darkBrown

        searchBar.searchTextField.tintColor =
            CafeAppTheme.Colors.primary

        searchBar.searchTextField.layer.cornerRadius =
            CafeAppTheme.Metrics.fieldRadius

        searchBar.searchTextField.clipsToBounds =
            true

        searchBar.searchTextField.attributedPlaceholder =
            NSAttributedString(
                string: "Search cafes...",
                attributes: [
                    .foregroundColor:
                        CafeAppTheme
                            .Colors
                            .secondaryText
                ]
            )

        if let searchIcon =
            searchBar.searchTextField.leftView
                as? UIImageView {

            searchIcon.tintColor =
                CafeAppTheme
                    .Colors
                    .secondaryText
        }

        // Background
        view.backgroundColor =
            CafeAppTheme.Colors.background

        tableView.backgroundColor =
            .clear

        tableView.separatorStyle =
            .none

        tableView.contentInset =
            UIEdgeInsets(
                top: 8,
                left: 0,
                bottom: 20,
                right: 0
            )

        // Empty State
        emptyStateLabel.text =
            "☕️ No cafes found"

        emptyStateLabel.textColor =
            CafeAppTheme
                .Colors
                .secondaryText

        emptyStateLabel.textAlignment =
            .center

        emptyStateLabel.font =
            UIFont.systemFont(
                ofSize: 18,
                weight: .semibold
            )

        // Navigation Bar
        navigationController?
            .navigationBar
            .prefersLargeTitles = false

        navigationItem.largeTitleDisplayMode =
            .never

        configureNavigationBar()
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

        searchBar.searchTextField.backgroundColor =
            CafeAppTheme.Colors.card

        searchBar.searchTextField.textColor =
            CafeAppTheme.Colors.darkBrown

        searchBar.searchTextField.tintColor =
            CafeAppTheme.Colors.primary

        searchBar.searchTextField
            .attributedPlaceholder =
            NSAttributedString(
                string: "Search cafes...",
                attributes: [
                    .foregroundColor:
                        CafeAppTheme
                            .Colors
                            .secondaryText
                ]
            )

        emptyStateLabel.textColor =
            CafeAppTheme
                .Colors
                .secondaryText

        configureNavigationBar()

        tableView.reloadData()
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
        cafesListener?.remove()
    }
}
