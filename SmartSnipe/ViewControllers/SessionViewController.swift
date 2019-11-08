//
//  ViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {

    override func viewDidLoad() {
        self.view.backgroundColor = .black
        self.navigationItem.title = "Session"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        self.navigationController?.navigationBar.barTintColor = .black
        super.viewDidLoad()
    }


}

