//
//  PetitionsViewController.swift
//  PetitionHub
//
//  Created by Dmitry on 10.05.2023.
//

import UIKit

class PetitionsViewController: UIViewController {

    private let user = UserProfile()
    
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
        // Do any additional setup after loading the view.
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

}
