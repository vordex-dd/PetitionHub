//
//  DetailsViewController.swift
//  PetitionHub
//
//  Created by Dmitry on 12.06.2023.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController {

    var currentPetition: Petition?
    private var titles = UILabel()
    private var text = UILabel()
    private var ref: DatabaseReference! = Database.database().reference()
    let id = Auth.auth().currentUser?.uid
    private var signed = false {
        didSet {
            DispatchQueue.main.async {
                self.setUpRightButton()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = CONFIG.backgroundColor
        title = "Информация"
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButton
        //navigationItem.rightBarButtonItem = .init(title: "Подписать", style: .done, target: self, action: #selector(onButtonTapped))
        //setUpRightButton()
        check()
        setUpTitle()
        setUpText()
    }
    
    func setUpRightButton() {
        if signed {
            let sign = UIButton()
            sign.setTitle("Подписано", for: .normal)
            sign.setTitleColor(UIColor(cgColor: CGColor(red: 0, green: 1, blue: 0, alpha: 0.2)), for: .normal)
            let rightbarButtonItem = UIBarButtonItem(customView: sign)
            navigationItem.rightBarButtonItem = rightbarButtonItem
        }else{
            navigationItem.rightBarButtonItem = .init(title: "Подписать", style: .done, target: self, action: #selector(onButtonTapped))
        }
    }
    
    @objc func onButtonTapped() {
        ref.child("petitions").child(currentPetition?.title ?? "").child("count").setValue((currentPetition?.count ?? 0) + 1)
        //print(currentPetition?.count)
        ref.child("petitions").child(currentPetition?.title ?? "").child("users").child(id ?? "").setValue(0)
        navigationController?.popViewController(animated: true)
    }
    
    func setUpTitle() {
        titles.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titles)
        titles.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titles.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        titles.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        titles.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titles.text = currentPetition?.title
        titles.font = titles.font?.withSize(27)
    }
    
    func setUpText() {
        text.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(text)
        text.topAnchor.constraint(equalTo: titles.bottomAnchor, constant: 10).isActive = true
        text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        text.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        text.numberOfLines = 0
        text.text = "\(currentPetition?.description ?? "")\nТеги: \(currentPetition?.tags ?? "")\nПодписей: \(currentPetition?.count ?? 0)"
    }

    func check() {
        ref.child("petitions").child(currentPetition?.title ?? "").child("users").observe(DataEventType.value) { [weak self] data in
            guard let information = data.value as? [String: Int] else { return }
            if let _ = information[self?.id ?? ""] {
                self?.signed = true
            }else {
                self?.signed = false
            }
        }
    }
}
