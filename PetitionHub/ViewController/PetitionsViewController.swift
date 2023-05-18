//
//  PetitionsViewController.swift
//  PetitionHub
//
//  Created by Dmitry on 10.05.2023.
//

import UIKit
import Firebase

class PetitionsViewController: UIViewController {

    private let user = UserProfile()
    private var allPetition: [Petition] = [] {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    private var table = UITableView()
    private var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = CONFIG.backgroundColor
        title = "Петиции"
        navigationController?.navigationBar.tintColor = CONFIG.segmentSelectedColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if user.openAuth() {
            let authViewController = AuthenticationViewController()
            authViewController.user = user
            navigationController?.pushViewController(authViewController, animated: true)
            //present(authViewController, animated: true)
        }
        setUpRightButton()
        setUpTable()
        load()
    }
    
    func setUpRightButton() {
        let person: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let personImage = UIImage(systemName: "plus")
        person.setImage(personImage, for: .normal)
        person.addTarget(self, action: #selector(toCreate), for: UIControl.Event.touchUpInside)
        person.tintColor = .systemGreen
        let rightbarButtonItem = UIBarButtonItem(customView: person)
        navigationItem.rightBarButtonItem = rightbarButtonItem
    }

    @objc func toCreate() {
        let createViewController = CreateViewController()
        navigationController?.pushViewController(createViewController, animated: true)
    }
    
    func setUpTable() {
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = CONFIG.backgroundColor
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func load() {
        ref.child("petitions").observe(DataEventType.value) { [weak self] data   in
            guard let information = data.value as? [String: Int] else { return }
            self?.allPetition = []
            for (key, value) in information {
                self?.allPetition.append(Petition(title: key, count: value))
            }
        }
    }

}


extension PetitionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allPetition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = CONFIG.backgroundColor
        cell.layer.cornerRadius = CONFIG.cornerRadius
        cell.textLabel?.text = allPetition[indexPath.row].title
        cell.detailTextLabel?.text = "Подписей: \(allPetition[indexPath.row].count)"
        cell.textLabel?.numberOfLines = 0
        cell.separatorInset = UIEdgeInsets(top: 100, left: 0, bottom: 10, right: 0)
        return cell
    }
    
    
}
