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
    private var stack = UIStackView()
    
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
        setUpStack()
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
    
    func setUpStack() {
        let activityInd = UIActivityIndicatorView()
        activityInd.style = .medium
        activityInd.startAnimating()
        activityInd.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(activityInd)
        stack.axis = .vertical
        let label = UILabel()
        label.text = "Загрузка"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = CONFIG.deviderColor
        stack.addArrangedSubview(label)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //stack.baselineAdjustment = .alignCenters
    }
    
    func load() {
        ref.child("petitions").observe(DataEventType.value) { [weak self] data   in
            guard let information = data.value as? [String: [String: Any]] else { return }
            self?.allPetition = []
            self?.stack.isHidden = true
            for (key, value) in information {
                self?.allPetition.append(Petition(title: key, description: value["description"] as? String ?? "", tags: value["tags"] as? String ?? "", count: value["count"] as? Int ?? 0))
            }
            self?.allPetition.sort { $0.count > $1.count }
        }
    }

}


extension PetitionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allPetition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let curPerson = allPetition[indexPath.row]
        cell.backgroundColor = CONFIG.backgroundColor
        cell.layer.cornerRadius = CONFIG.cornerRadius
        cell.textLabel?.text = curPerson.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(curPerson.description)\nТеги: \(curPerson.tags)\nПодписей: \(curPerson.count)"
        cell.textLabel?.numberOfLines = 0
        cell.separatorInset = UIEdgeInsets(top: 100, left: 0, bottom: 10, right: 0)
        return cell
    }
    
    
}
