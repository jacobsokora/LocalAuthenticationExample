//
//  ViewController.swift
//  LocalAuthenticationExample
//
//  Created by Jacob Sokora on 9/24/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit
import LocalAuthentication

class LocalAuthenticationViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func authenticate(_ sender: Any) {
        errorLabel.text = ""
        infoLabel.text = "Unauthenticated"
        let context = LAContext()
        var error: NSError?
        let alert = UIAlertController(title: "How would you like to authenticate", message: nil, preferredStyle: .actionSheet)
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            alert.addAction(UIAlertAction(title: "With Biometrics or Passcode", style: .default) { action in
                self.authenticate(context: context, policy: .deviceOwnerAuthentication)
            })
        }
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            alert.addAction(UIAlertAction(title: "With Biometrics Only", style: .default) { action in
                self.authenticate(context: context, policy: .deviceOwnerAuthenticationWithBiometrics)
            })
        }
        if let error = error {
            errorLabel.text = error.localizedDescription
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func authenticate(context: LAContext, policy: LAPolicy) {
        let reason = "Authenticate"
        context.evaluatePolicy(policy, localizedReason: reason) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.infoLabel.text = "Authenticated"
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.errorLabel.text = error.localizedDescription
                }
            }
        }
    }
}

