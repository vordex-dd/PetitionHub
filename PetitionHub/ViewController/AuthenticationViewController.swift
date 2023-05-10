//
//  AuthenticationViewController.swift
//  PetitionHub
//
//  Created by Dmitry on 10.05.2023.
//

import UIKit
import Firebase
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
        navigationItem.hidesBackButton = true
        setUpSegmentControl()
        setUpUserParametrs()
        setUpStack()
    }
    
    @objc func onButtonTapped() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButton
        guard let email = userParametrs[0].text, let password = userParametrs[1].text else {
            showAlert("Нужно заполнить все поля")
            navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(onButtonTapped))
            return
        }
        if email.isEmpty || password.isEmpty {
            showAlert("Нужно заполнить все поля")
            navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(onButtonTapped))
            return
        }
        switch curStatusAuth {
        case .login:
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                if error == nil {
                    self?.succes()
                }else{
                    self?.signInFallied(0)
                }
                self?.navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(self?.onButtonTapped))
            }
        case .registration:
            Auth.auth().createUser(withEmail: email, password: password, completion:  {
                [weak self] (result, error) in
                if error == nil {
                    self?.succes()
                }else{
                    self?.showAlert("Ошибка регистрации")
                }
                self?.navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(self?.onButtonTapped))
            })
        }
    }
    
    func succes() {
        user?.readyAuth()
        navigationController?.popViewController(animated: true)
    }
    
    func signInFallied(_ i: Int) {
        if i == 0 {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
        if i > 6 {
            return
        }
        let cnt = [5, -10, +10, -10, 10, -10, 5][i]
        UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            let password = self?.userParametrs[1]
            password?.center.x += CGFloat(cnt)
            //password?.center.x -= 10
            //password?.center.x += 10
            //password?.center.x -= 5
        }) { [weak self] _ in
            self?.signInFallied(i + 1)
        }
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
        userParametrs[0].textContentType = .emailAddress
        userParametrs[1].placeholder = "Пароль"
        userParametrs[1].textContentType = .password
        userParametrs[1].isSecureTextEntry = true
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
        curStatusAuth = StatusAuth(rawValue: sender.selectedSegmentIndex) ?? .login
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .default))
        present(alert, animated: true)
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
