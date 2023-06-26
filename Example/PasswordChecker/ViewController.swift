//
//  ViewController.swift
//  PasswordChecker
//
//  Created by loupehope on 06/26/2023.
//  Copyright (c) 2023 loupehope. All rights reserved.
//

import UIKit
import PasswordChecker

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let passwordChecker = try? PasswordChecker()

        let password = "2-Ubvrr23dsf2"
        let result = passwordChecker?.getPasswordScore(password, userInputs: ["Vlad", "2-Ubvrr23"])

        switch result {
        case let .success(passwordInfo):
            debugPrint(passwordInfo)

        case let .failure(error):
            debugPrint(error.localizedDescription)

        case .none:
            assertionFailure("PasswordChecker is not initialised!")
        }
    }
}
