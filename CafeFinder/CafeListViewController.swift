//
//  CafeListViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
//

import UIKit
import FirebaseFirestore

class CafeListViewController: UIViewController,
                              UITableViewDelegate,
                              UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private var cafes: [Cafe] = []
    private var cafesListener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "בתי קפה"

        tableView.delegate = self
        tableView.dataSource = self

        configureAppearance()
        observeCafes()
    }

    // MARK: - Firestore

    private func observeCafes() {
        cafesListener = CafeFirestoreService.shared.observeCafes {
            [weak self] result in

            DispatchQueue.main.async {
                switch result {

                case .success(let cafes):
                    self?.cafes = cafes
                    self?.tableView.reloadData()

                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        print("Segue identifier:", segue.identifier ?? "nil")
        print("Destination:", type(of: segue.destination))

        if segue.identifier == "showAddCafe" {

            let addVC: AddCafeViewController?

            if let directAddVC =
                segue.destination as? AddCafeViewController {

                addVC = directAddVC

            } else if let navigationController =
                        segue.destination as? UINavigationController {

                addVC = navigationController.topViewController
                    as? AddCafeViewController

            } else {
                addVC = nil
            }

            guard let addVC = addVC else {
                print("ERROR: AddCafeViewController was not found")
                return
            }

            print("AddCafeViewController found")

            addVC.onSave = { [weak self] cafe in
                print("onSave received:", cafe.name)

                CafeFirestoreService.shared.addCafe(cafe) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print(
                                "FIRESTORE SAVE ERROR:",
                                error.localizedDescription
                            )

                            self?.showError(
                                error.localizedDescription
                            )
                        } else {
                            print("FIRESTORE SAVE SUCCESS")
                        }
                    }
                }
            }

        } else if segue.identifier == "showDetails",
                  let detailsVC =
                    segue.destination as? CafeDetailsViewController,
                  let cafe = sender as? Cafe {

            detailsVC.cafe = cafe

            detailsVC.onDelete = { [weak self] in
                CafeFirestoreService.shared.deleteCafe(
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

            detailsVC.onEdit = { [weak self] editedCafe in
                CafeFirestoreService.shared.updateCafe(
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

    // MARK: - UITableViewDataSource

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return cafes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let identifier = "CafeCell"

        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier
        ) ?? UITableViewCell(
            style: .subtitle,
            reuseIdentifier: identifier
        )

        let cafe = cafes[indexPath.row]

        cell.textLabel?.text = cafe.name
        cell.detailTextLabel?.text =
            "\(cafe.city) · \(String(repeating: "⭐️", count: cafe.rating))"

        cell.textLabel?.textColor = .label
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.backgroundColor = .secondarySystemBackground
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        let selectedCafe = cafes[indexPath.row]

        performSegue(
            withIdentifier: "showDetails",
            sender: selectedCafe
        )
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 72
    }

    // MARK: - Appearance

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine

        navigationController?
            .navigationBar
            .prefersLargeTitles = true

        navigationItem.largeTitleDisplayMode = .always
    }

    // MARK: - Error Alert

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
        cafesListener?.remove()
    }
}
