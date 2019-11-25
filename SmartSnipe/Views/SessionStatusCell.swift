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
    var statusImageView: UIImageView
    var descriptionLabel: UILabel
    var connectButton: UIButton
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.statusImageView = UIImageView()
        self.descriptionLabel = UILabel()
        self.descriptionLabel.numberOfLines = 2
        self.descriptionLabel.setContentCompressionResistancePriority(UILayoutPriority(500.0), for: .horizontal)
        self.connectButton = UIButton()
        self.connectButton.setTitle("Connect", for: .normal)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .black
        self.statusImageView.contentMode = .scaleAspectFit
        
        self.descriptionLabel.textColor = .lightGray
        
        self.connectButton.setTitleColor(.green, for: .normal)
        
        self.setupCell()
    }
    
    private func setupCell() {
        self.statusImageView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.statusImageView)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.connectButton)
        
        NSLayoutConstraint.activate([
            self.statusImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.statusImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.statusImageView.widthAnchor.constraint(equalToConstant: 40),
            self.statusImageView.heightAnchor.constraint(equalToConstant: 40),
            
            self.descriptionLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.statusImageView.trailingAnchor, constant: 12),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.connectButton.leadingAnchor, constant: -12),
            
            self.connectButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.connectButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isNetConnected: Bool) {
        if isNetConnected {
            self.descriptionLabel.text = "You are connected to a net."
            self.connectButton.isHidden = true
            self.statusImageView.image = UIImage(named: "connected")
        } else {
            self.descriptionLabel.text = "You are not connected to a net."
            self.connectButton.isHidden = false
            self.statusImageView.image = UIImage(named: "not_connected")
        }
    }
}
