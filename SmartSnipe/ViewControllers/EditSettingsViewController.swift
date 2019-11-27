//
//  EditSettingsViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-26.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

struct EditSettingsViewModel {
    let navigationTitleText: String
    let descriptionText: String
    var pickerValues: [String]
    var selectedPickerValue: String
}

class EditSettingsViewController: UIViewController {
    var viewModel: EditSettingsViewModel
    
    let descriptionLabel = UILabel()
    let pickerView = UIPickerView()
    
    init(viewModel: EditSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupSubviews()
        
        self.view.backgroundColor = SSColors.jet
        
        let selectedPickerIndex = self.viewModel.pickerValues.firstIndex { (pickerValue) -> Bool in
            return pickerValue == self.viewModel.selectedPickerValue
        } ?? 0
        
        self.pickerView.selectRow(selectedPickerIndex, inComponent: 0, animated: true)
        
        self.navigationController?.navigationBar.barTintColor = SSColors.raisinBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : SSColors.grainYellow]
        
        self.navigationItem.title = self.viewModel.navigationTitleText
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = SSColors.grainYellow
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(setButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = SSColors.grainYellow
        
        super.viewDidLoad()
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.text = self.viewModel.descriptionText
        self.descriptionLabel.numberOfLines = 2
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.descriptionLabel.textColor = SSColors.platinum
        
        self.view.addSubview(self.pickerView)
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.tintColor = SSColors.grainYellow
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: SSMargins.large),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: SSMargins.massive),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -SSMargins.large),
            self.pickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: SSMargins.large),
            self.pickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -SSMargins.large),
            self.pickerView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: SSMargins.large),
            self.pickerView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    @objc func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setButtonTapped() {
        self.viewModel.selectedPickerValue = self.viewModel.pickerValues[self.pickerView.selectedRow(inComponent: 0)]
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditSettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.pickerValues.count
    }
}

extension EditSettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.viewModel.pickerValues[row],
                                  attributes: [NSAttributedString.Key.foregroundColor : SSColors.grainYellow])
    }
}
