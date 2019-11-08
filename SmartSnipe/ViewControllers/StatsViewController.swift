//
//  StatsViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    override func viewDidLoad() {
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        self.navigationItem.title = "Stats"
        super.viewDidLoad()
    }


}
