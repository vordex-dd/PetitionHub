//
//  AuthenticationViewController.swift
//  PetitionHub
//
//  Created by Dmitry on 10.05.2023.
//

import UIKit

class AuthenticationViewController: UIViewController {

    var user: UserProfile?
    private lazy var stack = UIStackView()
    private lazy var segmentedControl = UISegmentedControl()
    private lazy var userParametrs = [UITextField(), UITextField()]
    private var curStatusAuth = StatusAuth.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = CONFIG.backgroundColor
        title = "Аутентификация"
        navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(onButtonTapped))
        
        setUpSegmentControl()
        setUpUserParametrs()
        setUpStack()
    }
    
    @objc func onButtonTapped() {
        //TODO
        navigationController?.popViewController(animated: true)
    }
    
    func setUpSegmentControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Вход", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Регистрация", at: 1, animated: false)
        let segmentNotSelected = [NSAttributedString.Key.foregroundColor: CONFIG.segmentNotSelectedTextColor]
        segmentedControl.setTitleTextAttributes(segmentNotSelected, for: .normal)

        let segmentSelected = [NSAttributedString.Key.foregroundColor: CONFIG.segmentSelectedTextColor]
        segmentedControl.setTitleTextAttributes(segmentSelected, for: .selected)
        segmentedControl.selectedSegmentTintColor = CONFIG.segmentSelectedColor
        segmentedControl.addTarget(self, action: #selector(changeTypeAuth), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = CONFIG.cornerRadius
        stack.addArrangedSubview(segmentedControl)
    }
    
    func setUpUserParametrs() {
        for textField in userParametrs {
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
            textField.backgroundColor = CONFIG.deviderColor
            textField.layer.cornerRadius = CONFIG.cornerRadius
            textField.setLeftPaddingPoints(10)
            textField.setRightPaddingPoints(10)
        }
        userParametrs[0].placeholder = "Email"
        userParametrs[1].placeholder = "Пароль"
        stack.addArrangedSubview(userParametrs[0])
        stack.addArrangedSubview(userParametrs[1])
    }
    
    func setUpStack() {
        view.addSubview(stack)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        stack.distribution = .fillEqually
        stack.spacing = 10
    }
    
    @objc func changeTypeAuth(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        curStatusAuth = StatusAuth(rawValue: sender.selectedSegmentIndex) ?? .login
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
