//
//  CreateViewController.swift
//  PetitionHub
//
//  Created by Dmitry on 11.05.2023.
//

import UIKit
import Firebase

class CreateViewController: UIViewController {

    private lazy var labelName = UILabel()
    private lazy var labelDescription = UILabel()
    private lazy var labelTags = UILabel()
    private lazy var textField = UITextField()
    private lazy var textDescription = UITextView()
    private lazy var textTags = UITextField()
    private lazy var stack = UIStackView()
    private var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = CONFIG.backgroundColor
        title = "Создание петиции"
        navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(onButtonTapped))
        setUpName()
        setUpTextFields()
        stack.addArrangedSubview(textField)
        setUpDescription()
        setUpTextDescription()
        setUpTags()
        stack.addArrangedSubview(textTags)
        setUpStack()
    }
    
    @objc func onButtonTapped() {
        let name = textField.text ?? ""
        let description = textDescription.text ?? ""
        let tags = textTags.text ?? ""
        if name.isEmpty || description.isEmpty || tags.isEmpty {
            showAlert("Необходимо заполнить все поля")
            return
        }
        guard let id = Auth.auth().currentUser?.uid else {
            showAlert("Необходимо войти в аккаунт")
            return
        }
        ref.child("petitions").child(name).child("description").setValue(description)
        ref.child("petitions").child(name).child("tags").setValue(tags)
        ref.child("petitions").child(name).child("count").setValue(0)
        ref.child("petitions").child(name).child("users").child("settings").setValue(0)
        navigationController?.popViewController(animated: true)
    }
    
    func setUpName() {
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.text = "Название петиции:"
        stack.addArrangedSubview(labelName)
    }

    func setUpTextFields() {
        for text in [textField, textTags] {
            text.translatesAutoresizingMaskIntoConstraints = false
            text.heightAnchor.constraint(equalToConstant: 35).isActive = true
            text.backgroundColor = CONFIG.deviderColor
            text.layer.cornerRadius = CONFIG.cornerRadius
            text.setLeftPaddingPoints(10)
            text.setRightPaddingPoints(10)
        }
    }
    
    func setUpDescription() {
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.text = "Описание петиции:"
        stack.addArrangedSubview(labelDescription)
    }
    
    func setUpTextDescription() {
        textDescription.translatesAutoresizingMaskIntoConstraints = false
        textDescription.heightAnchor.constraint(equalToConstant: 90).isActive = true
        textDescription.backgroundColor = CONFIG.deviderColor
        textDescription.layer.cornerRadius = CONFIG.cornerRadius
        textDescription.font = labelName.font?.withSize(17)
        //textDescription.setLeftPaddingPoints(10)
        //textDescription.setRightPaddingPoints(10)
        stack.addArrangedSubview(textDescription)
    }
    
    func setUpTags() {
        labelTags.translatesAutoresizingMaskIntoConstraints = false
        labelTags.text = "Теги петиции (через запятую):"
        stack.addArrangedSubview(labelTags)
    }
    
    func setUpStack() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        stack.axis = .vertical
        //stack.distribution = .fillEqually
        stack.spacing = 10
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .default))
        present(alert, animated: true)
    }
}
