//
//  HockeyNetCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-10.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

class HockeyNetCell: UITableViewCell {
    let hockeyNet = UIView()
    let topLeftHole = UIView()
    let topRightHole = UIView()
    let bottomLeftHole = UIView()
    let bottomRightHole = UIView()
    let fiveHole = UIView()
    let descriptionLabel = UILabel()
    let smartSnipeLabel = UILabel()
    
    private let sizeOfHole: CGFloat = 40
    private let offsetFromPost: CGFloat = 24.0
    private let fiveHoleOffsetFromBottom: CGFloat = 24.0
    private let offsetFromBottom: CGFloat = 40.0
    private let hockeyNetHeight: CGFloat = 200.0
    private let hockeyNetWidth: CGFloat = 300.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .black
        self.smartSnipeLabel.text = "SmartSnipe"
        self.smartSnipeLabel.textColor = .white
        self.descriptionLabel.textColor = .lightGray
        self.descriptionLabel.text = "Select an opening to open it next."
        let hockeyNetLayer = hockeyNetShapeLayer()
        self.hockeyNet.layer.addSublayer(hockeyNetLayer)
        self.constructCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func hockeyNetShapeLayer() -> CAShapeLayer {
        let hockeyPostPath = UIBezierPath()
        let pathWidth: CGFloat = 8.0
        let cornerRadius: CGFloat = 16.0
        hockeyPostPath.move(to: CGPoint(x: CGFloat(pathWidth/2), y: hockeyNetHeight))
        hockeyPostPath.addLine(to: CGPoint(x: pathWidth/2, y: pathWidth/2 + cornerRadius))
        hockeyPostPath.addArc(withCenter: CGPoint(x: pathWidth/2 + cornerRadius, y: pathWidth/2 + cornerRadius),
                              radius: CGFloat(cornerRadius),
                              startAngle: CGFloat(Double.pi),
                              endAngle: CGFloat(3*Double.pi/2),
                              clockwise: true)
        hockeyPostPath.addLine(to: CGPoint(x: hockeyNetWidth - cornerRadius - pathWidth/2,
                                           y: pathWidth/2))
        hockeyPostPath.addArc(withCenter: CGPoint(x: hockeyNetWidth - cornerRadius - pathWidth/2,
                                                  y: pathWidth/2 + cornerRadius),
                              radius: CGFloat(cornerRadius),
                              startAngle: CGFloat(3*Double.pi/2),
                              endAngle: CGFloat(2*Double.pi),
                              clockwise: true)
        hockeyPostPath.addLine(to: CGPoint(x: hockeyNetWidth - pathWidth/2,
                                           y: hockeyNetHeight))
        
        let hockeyNetShapeLayer = CAShapeLayer()
        hockeyNetShapeLayer.path = hockeyPostPath.cgPath
        hockeyNetShapeLayer.lineWidth = CGFloat(pathWidth)
        hockeyNetShapeLayer.strokeColor = UIColor.red.cgColor
        return hockeyNetShapeLayer
    }
    
    private func constructCell() {
        [self.hockeyNet, self.descriptionLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [self.topLeftHole,
         self.topRightHole,
         self.bottomLeftHole,
         self.bottomRightHole,
         self.fiveHole,
         self.smartSnipeLabel].forEach {
            $0.backgroundColor = .white
            self.hockeyNet.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.smartSnipeLabel.backgroundColor = .black
        [self.topLeftHole, self.topRightHole, self.bottomLeftHole, self.bottomRightHole].forEach { hole in
            NSLayoutConstraint.activate([
                hole.widthAnchor.constraint(equalToConstant: sizeOfHole),
                hole.heightAnchor.constraint(equalToConstant: sizeOfHole)
            ])
        }
        
        NSLayoutConstraint.activate([
            self.hockeyNet.widthAnchor.constraint(equalToConstant: hockeyNetWidth),
            self.hockeyNet.heightAnchor.constraint(equalToConstant: hockeyNetHeight),
            self.hockeyNet.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.hockeyNet.topAnchor.constraint(
                equalTo: self.descriptionLabel.bottomAnchor,
                constant: 20),
            self.hockeyNet.heightAnchor.constraint(equalToConstant: 200),
            self.smartSnipeLabel.centerXAnchor.constraint(equalTo: self.hockeyNet.centerXAnchor),
            self.smartSnipeLabel.centerYAnchor.constraint(equalTo: self.hockeyNet.centerYAnchor),
            self.topLeftHole.leadingAnchor.constraint(
                equalTo: self.hockeyNet.leadingAnchor,
                constant: offsetFromPost),
            self.topLeftHole.topAnchor.constraint(
                equalTo: self.hockeyNet.topAnchor,
                constant: offsetFromPost),
            self.topRightHole.topAnchor.constraint(
                equalTo: self.hockeyNet.topAnchor,
                constant: offsetFromPost),
            self.topRightHole.trailingAnchor.constraint(
                equalTo: self.hockeyNet.trailingAnchor,
                constant: -offsetFromPost),
            self.bottomLeftHole.leadingAnchor.constraint(
                equalTo: self.hockeyNet.leadingAnchor,
                constant: offsetFromPost),
            self.bottomLeftHole.bottomAnchor.constraint(
                equalTo: self.hockeyNet.bottomAnchor,
                constant: -offsetFromBottom),
            self.bottomRightHole.trailingAnchor.constraint(
                equalTo: self.hockeyNet.trailingAnchor,
                constant: -offsetFromPost),
            self.bottomRightHole.bottomAnchor.constraint(
                equalTo: self.hockeyNet.bottomAnchor,
                constant: -offsetFromBottom),
            self.fiveHole.widthAnchor.constraint(equalToConstant: 30),
            self.fiveHole.heightAnchor.constraint(equalToConstant: 30),
            self.fiveHole.centerXAnchor.constraint(
                equalTo: self.hockeyNet.centerXAnchor),
            self.fiveHole.bottomAnchor.constraint(
                equalTo: self.hockeyNet.bottomAnchor,
                constant: -fiveHoleOffsetFromBottom),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12)
        ])
    }
}
