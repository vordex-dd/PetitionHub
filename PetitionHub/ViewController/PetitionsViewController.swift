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
    private var allPetition: [Petition] = []
    private var filterPetition: [Petition] = [] {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    private var table = UITableView()
    private var searchField = UITextField()
    private var ref: DatabaseReference! = Database.database().reference()
    private var stack = UIStackView()
    private var curFilter = ""
    
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
        setUpSearchField()
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
    
    func setUpSearchField() {
        let line = UIView()
        view.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        line.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        line.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        line.heightAnchor.constraint(equalToConstant: 35).isActive = true
        //line.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        line.backgroundColor = CONFIG.deviderColor
        line.layer.borderWidth = CONFIG.borderWidth
        line.layer.borderColor = CONFIG.borderColor
        line.layer.cornerRadius = CONFIG.cornerRadiusForSearch
        line.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
        searchField.leadingAnchor.constraint(equalTo: line.leadingAnchor, constant: 10).isActive = true
        searchField.trailingAnchor.constraint(equalTo: line.trailingAnchor, constant: -10).isActive = true
        searchField.bottomAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        searchField.placeholder = "Поиск"
        searchField.backgroundColor = CONFIG.deviderColor
        searchField.delegate = self
    }
    
    func setUpTable() {
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = CONFIG.backgroundColor
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        table.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
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
            self?.filterPet()
        }
    }
    
    func filterPet() {
        filterPetition = []
        for current in allPetition {
            let name = current.title.lowercased()
            if name.range(of: curFilter) != nil || curFilter == "" {
                filterPetition.append(current)
            }
        }
    }

}


extension PetitionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterPetition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let curPerson = filterPetition[indexPath.row]
        cell.backgroundColor = CONFIG.backgroundColor
        cell.layer.cornerRadius = CONFIG.cornerRadius
        cell.textLabel?.text = curPerson.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(curPerson.description)\nТеги: \(curPerson.tags)\nПодписей: \(curPerson.count)"
        cell.textLabel?.numberOfLines = 0
        //cell.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return cell
    }
    
    
}


extension PetitionsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            curFilter = text.replacingCharacters(in: textRange, with: string).lowercased()
        }
        filterPet()
        return true
    }
}
