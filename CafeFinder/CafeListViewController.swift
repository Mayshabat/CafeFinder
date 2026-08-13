////
//  CafeListViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
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

                    switch result {

                    case .success(let cafes):

                        self?.cafes = cafes
                        self?.filteredCafes = cafes

                        self?.tableView.reloadData()
                        self?.updateEmptyState()

                    case .failure(let error):

                        self?.showError(
                            error.localizedDescription
                        )
                    }
                }
            }
    }

    // MARK: - Empty State

    private func updateEmptyState() {

        let displayedCafes =
            isSearching ? filteredCafes : cafes

        emptyStateLabel.isHidden =
            !displayedCafes.isEmpty
    }

    // MARK: - Search

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {

        let text = searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        if text.isEmpty {

            isSearching = false
            filteredCafes = cafes

        } else {

            isSearching = true

            filteredCafes = cafes.filter { cafe in

                cafe.name
                    .localizedCaseInsensitiveContains(text)

                ||

                cafe.city
                    .localizedCaseInsensitiveContains(text)

                ||

                cafe.address
                    .localizedCaseInsensitiveContains(text)
            }
        }

        tableView.reloadData()
        updateEmptyState()
    }

    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Navigation

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {

        // ADD CAFE
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

                CafeFirestoreService.shared
                    .addCafe(cafe) { error in

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

        // DETAILS
        else if segue.identifier == "showDetails",
                let detailsVC =
                    segue.destination
                        as? CafeDetailsViewController,
                let cafe = sender as? Cafe {

            detailsVC.cafe = cafe

            // DELETE
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

            // EDIT
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

    // MARK: - Table View Data Source

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return isSearching
            ? filteredCafes.count
            : cafes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "CafeCell",
                for: indexPath
            ) as? CafeTableViewCell else {

            return UITableViewCell()
        }

        let cafe = isSearching
            ? filteredCafes[indexPath.row]
            : cafes[indexPath.row]

        // Cafe Name
        cell.cafeNameLabel.text = cafe.name

        cell.cafeNameLabel.textColor =
            CafeAppTheme.Colors.darkBrown

        // City
        cell.cityLabel.text = cafe.city

        cell.cityLabel.textColor =
            CafeAppTheme.Colors.secondaryText

        // Rating
        var stars = ""

        for index in 1...5 {

            if index <= cafe.rating {
                stars += "★"
            } else {
                stars += "☆"
            }
        }

        cell.ratingLabel.text = stars

        cell.ratingLabel.textColor =
            CafeAppTheme.Colors.star

        // Cell Appearance
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

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

        let selectedCafe = isSearching
            ? filteredCafes[indexPath.row]
            : cafes[indexPath.row]

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

    // MARK: - Appearance

    private func configureAppearance() {

        // Search Bar

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

        searchBar.searchTextField.textColor =
            CafeAppTheme.Colors.darkBrown

        searchBar.searchTextField.backgroundColor =
            .white

        // Background

        view.backgroundColor =
            CafeAppTheme.Colors.background

        tableView.backgroundColor = .clear

        tableView.separatorStyle = .none

        // Empty State

        emptyStateLabel.text =
            "☕️ No cafes found"

        emptyStateLabel.textColor =
            CafeAppTheme.Colors.darkBrown

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

        let appearance =
            UINavigationBarAppearance()

        appearance
            .configureWithTransparentBackground()

        appearance.titleTextAttributes = [
            .foregroundColor:
                CafeAppTheme.Colors.darkBrown
        ]

        navigationController?
            .navigationBar
            .standardAppearance = appearance

        navigationController?
            .navigationBar
            .scrollEdgeAppearance = appearance

        navigationController?
            .navigationBar
            .compactAppearance = appearance
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
