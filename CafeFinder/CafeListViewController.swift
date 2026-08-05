//
//  CafeListViewController.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
//
import UIKit



class CafeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var cafes: [Cafe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        print("Segue:", segue.identifier ?? "nil")

        if let addVC = segue.destination as? AddCafeViewController {

            print("Add Cafe")

            addVC.onSave = { [weak self] cafe in
                self?.cafes.append(cafe)
                self?.tableView.reloadData()
            }

        } else if let detailsVC = segue.destination as? CafeDetailsViewController,
                  let cafe = sender as? Cafe {

            print("Details")

            detailsVC.cafe = cafe

            if let index = cafes.firstIndex(where: { $0.name == cafe.name }) {

                // מחיקה
                detailsVC.onDelete = { [weak self] in
                    self?.cafes.remove(at: index)
                    self?.tableView.reloadData()
                }

                // עריכה
                detailsVC.onEdit = { [weak self] editedCafe in
                    self?.cafes[index] = editedCafe
                    self?.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        let cafe = cafes[indexPath.row]

        cell.textLabel?.text = cafe.name
        cell.detailTextLabel?.text = "\(cafe.city) ⭐️\(cafe.rating)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: cafes[indexPath.row])
    }}
  

