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
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
