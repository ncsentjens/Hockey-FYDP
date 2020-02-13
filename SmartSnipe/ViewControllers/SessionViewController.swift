//
//  ViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

protocol HockeyNetDelegate: class {
    func holeWasSelected(hole: HockeyNetHole)
}

struct SessionViewControllerViewModel {
    var isNetConnected: Bool
    var isSessionInProgress: Bool
    var sessionViewModel: SessionViewModel
}

class SessionViewController: UIViewController {
    private let sessionButton: UIButton = UIButton()
    private let tableView: UITableView = UITableView()
    private var viewModel: SessionViewControllerViewModel
    
    init() {
        let sessionViewModel = SessionViewModel(shots: 10,
                                                goals: 4,
                                                averageShotSpeed: 67.9,
                                                averageReactionTime: 0.43,
                                                fastestShot: 84.2,
                                                quickestReactionTime: 0.40,
                                                sessionDate: Date())
        self.viewModel = SessionViewControllerViewModel(isNetConnected: false,
                                                        isSessionInProgress: false,
                                                        sessionViewModel: sessionViewModel
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.viewModel.isNetConnected = SSBluetoothManager.sharedManager.isConnectedToNet()
        
        self.view.backgroundColor = SSColors.raisinBlack
        
        self.navigationItem.title = "Session"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : SSColors.grainYellow]
        self.navigationController?.navigationBar.barTintColor = SSColors.raisinBlack
        
        self.sessionButton.setTitle("End Session", for: .selected)
        self.sessionButton.setTitleColor(.red, for: .selected)
        self.sessionButton.backgroundColor = SSColors.grainYellow
        self.sessionButton.layer.cornerRadius = 8
        self.sessionButton.addTarget(self,
                                     action: #selector(sessionButtonTapped),
                                     for: .touchUpInside)
        
        self.updateSessionButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = SSColors.grainYellow
        self.tableView.backgroundColor = SSColors.raisinBlack
        self.tableView.register(SessionsStatusCell.self, forCellReuseIdentifier: "session_status_cell")
        self.tableView.register(HockeyNetCell.self, forCellReuseIdentifier: "hockey_net_cell")
        self.tableView.register(CurrentSessionCell.self, forCellReuseIdentifier: "current_session_cell")
        
        self.setupConstraints()
        
        SSBluetoothManager.sharedManager.sessionDelegate = self
        
        super.viewDidLoad()
    }
    
    private func setupConstraints() {
        self.sessionButton.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.sessionButton)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.sessionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: SSMargins.massive),
            self.sessionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -SSMargins.massive),
            self.sessionButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -SSMargins.large),
            self.sessionButton.heightAnchor.constraint(equalToConstant: 40),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.sessionButton.topAnchor, constant: -SSMargins.large)
        ])
    }
    
    private func updateSessionButton() {
        if self.viewModel.isSessionInProgress {
            self.sessionButton.setTitle("End Session", for: .normal)
            self.sessionButton.setTitleColor(SSColors.jet, for: .normal)
        } else {
            self.sessionButton.setTitle("Start Session", for: .normal)
            self.sessionButton.setTitleColor(SSColors.jet, for: .normal)
        }
    }
    
    @objc private func sessionButtonTapped() {
        if self.viewModel.isSessionInProgress {
            CoreDataManager.saveSessionModel(model: self.viewModel.sessionViewModel)
            self.viewModel.isSessionInProgress = false
            SSBluetoothManager.sharedManager.endSession()
        } else {
            let successful = SSBluetoothManager.sharedManager.startSession()
            if successful {
                self.viewModel.isSessionInProgress = true
            } else {
                let alert = UIAlertController(title: "Unable to Start Session", message: "A session could not be started. Try reconnecting to the net.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.updateSessionButton()
        self.tableView.reloadData()
    }
}

extension SessionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 106
        case 1:
            return 280
        case 2:
            return 346
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
            cell.updateCell(isNetConnected: self.viewModel.isNetConnected)
            return cell
        case 1:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "hockey_net_cell") as? HockeyNetCell else {
                fatalError()
            }
            cell.delegate = self
            return cell
        case 2:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "current_session_cell") as? CurrentSessionCell else {
                fatalError()
            }
            cell.applyViewModel(viewModel: self.viewModel.sessionViewModel)
            return cell
        default:
            fatalError()
        }

    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension SessionViewController: HockeyNetDelegate {
    func holeWasSelected(hole: HockeyNetHole) {
        SSBluetoothManager.sharedManager.updateNextHole(hole: hole)
    }
}

extension SessionViewController: SessionDelegate {
    func didUpdateSessionModel(sessionViewModel: SessionViewModel) {
        self.viewModel.sessionViewModel = sessionViewModel
        self.tableView.reloadData()
    }
}

extension SessionViewController: BluetoothConnectionDelegate {
    func didUpdateConnection(connected: Bool) {
        self.viewModel.isNetConnected = connected
        self.tableView.reloadData()
    }
}
