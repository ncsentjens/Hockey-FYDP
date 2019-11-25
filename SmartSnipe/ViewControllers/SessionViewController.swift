//
//  ViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {
    private let sessionButton: UIButton = UIButton()
    private let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        self.view.backgroundColor = .black
        
        self.navigationItem.title = "Session"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        self.navigationController?.navigationBar.barTintColor = .black
        
        self.sessionButton.setTitle("End Session", for: .normal)
        self.sessionButton.setTitleColor(.red, for: .normal)
        self.sessionButton.setTitle("End Session", for: .selected)
        self.sessionButton.setTitleColor(.red, for: .selected)
        self.sessionButton.backgroundColor = .lightGray
        self.sessionButton.layer.cornerRadius = 8
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = .white
        self.tableView.backgroundColor = .black
        self.tableView.register(SessionsStatusCell.self, forCellReuseIdentifier: "session_status_cell")
        self.tableView.register(HockeyNetCell.self, forCellReuseIdentifier: "hockey_net_cell")
        self.tableView.register(CurrentSessionCell.self, forCellReuseIdentifier: "current_session_cell")
        
        self.setupConstraints()
        
        super.viewDidLoad()
    }
    
    private func setupConstraints() {
        self.sessionButton.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.sessionButton)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.sessionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.sessionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.sessionButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            self.sessionButton.heightAnchor.constraint(equalToConstant: 40),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.sessionButton.topAnchor, constant: -12)
        ])
    }
}

extension SessionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80
        case 1:
            return 280
        case 2:
            return 150
        default:
            return 80
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "session_status_cell") as? SessionsStatusCell else {
                fatalError()
            }
            cell.updateCell(isNetConnected: true)
            return cell
        case 1:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "hockey_net_cell") as? HockeyNetCell else {
                fatalError()
            }
            return cell
        case 2:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "current_session_cell") else {
                fatalError()
            }
            return cell
        default:
            fatalError()
        }

    }
}

