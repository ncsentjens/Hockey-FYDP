//
//  SessionStatusCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-10.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class SessionsStatusCell: UITableViewCell {
    
    let descriptionLabel = UILabel()
    let netStatusLabel = UILabel()
    let reconnectButton = UIButton()
    
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
        self.descriptionLabel.text = "Bluetooth Status"
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = SSColors.raisinBlack
        
        self.stackView.axis = .vertical
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.alignment = UIStackView.Alignment.fill
        self.stackView.spacing = 6
        self.contentView.addSubview(self.stackView)
        
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.netStatusLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        [self.descriptionLabel, self.netStatusLabel].forEach {
            $0.textColor = SSColors.platinum
            self.stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.reconnectButton.addTarget(self,
                                       action: #selector(reconnectButtonTapped),
                                       for: .touchUpInside)
        self.reconnectButton.contentHorizontalAlignment = .left
        self.reconnectButton.setTitle("Reconnect", for: .normal)
        self.reconnectButton.setTitleColor(SSColors.grainYellow, for: .normal)
        self.reconnectButton.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(self.reconnectButton)
        
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SSMargins.large),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: SSMargins.large),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -SSMargins.large),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -SSMargins.large)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isNetConnected: Bool) {
        
        let statusString = isNetConnected ? "Net Status: Connected" : "Net Status: Disconnected"
        let statusAttributedString = NSMutableAttributedString(string: statusString, attributes: [NSAttributedString.Key.foregroundColor : SSColors.platinum])
        statusAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : SSColors.grainYellow], range: NSMakeRange(0, "Net Status: ".count))
        self.netStatusLabel.attributedText = statusAttributedString
        
        if isNetConnected {
            self.reconnectButton.isHidden = true
        } else {
            self.reconnectButton.isHidden = false
        }
    }
    
    @objc
    func reconnectButtonTapped() {
        SSBluetoothManager.sharedManager.reconnectToNet()
    }
}
