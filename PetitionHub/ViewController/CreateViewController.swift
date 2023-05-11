//
//  CreateViewController.swift
//  PetitionHub
//
//  Created by Dmitry on 11.05.2023.
//

import UIKit
import Firebase

class CreateViewController: UIViewController {

    private lazy var textField = UITextField()
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = CONFIG.backgroundColor
        title = "Создание петиции"
        navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(onButtonTapped))
        setUpTextField()
    }
    
    @objc func onButtonTapped() {
        let text = textField.text ?? ""
        if text.isEmpty {
            showAlert("Петиция не может быть пустой")
            return
        }
        ref.child("petitions").child(text).setValue(0)
        navigationController?.popViewController(animated: true)
    }

    func setUpTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textField.backgroundColor = CONFIG.deviderColor
        textField.layer.cornerRadius = CONFIG.cornerRadius
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.placeholder = "Текст петиции"
        view.addSubview(textField)
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .default))
        present(alert, animated: true)
    }
}
