//
//  HockeyNetCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-10.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

enum HockeyNetHole: Int {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
}

class HockeyNetCell: UITableViewCell {
    private let hockeyNet = UIView()
    private let topLeftHole = UIView()
    private let topRightHole = UIView()
    private let bottomLeftHole = UIView()
    private let bottomRightHole = UIView()
    private let descriptionLabel = UILabel()
    private let smartSnipeLabel = UILabel()
    
    private let sizeOfHole: CGFloat = 46
    private let offsetFromPost: CGFloat = 24.0
    private let offsetFromBottom: CGFloat = 24.0
    private let hockeyNetHeight: CGFloat = 200.0
    private let hockeyNetWidth: CGFloat = 300.0
    
    weak var delegate: HockeyNetDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = SSColors.raisinBlack
        
        self.smartSnipeLabel.text = "SmartSnipe"
        self.smartSnipeLabel.textColor = SSColors.grainYellow
        self.smartSnipeLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        self.descriptionLabel.textColor = SSColors.platinum
        self.descriptionLabel.text = "Select an opening to open it next."
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
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
    
    private func selected(hole: HockeyNetHole) {
        self.deselectAllHoles()
        delegate?.holeWasSelected(hole: hole)
    }
    
    @objc private func selectedTopLeft() {
        self.selected(hole: .topLeft)
        self.topLeftHole.backgroundColor = SSColors.grainYellow
    }
    
    @objc private func selectedTopRight() {
        self.selected(hole: .topRight)
        self.topRightHole.backgroundColor = SSColors.grainYellow
    }
    
    @objc  private func selectedBottomLeft() {
        self.selected(hole: .bottomLeft)
        self.bottomLeftHole.backgroundColor = SSColors.grainYellow
    }
    
    @objc private func selectedBottomRight() {
        self.selected(hole: .bottomRight)
        self.bottomRightHole.backgroundColor = SSColors.grainYellow
    }
    
    private func deselectAllHoles() {
        [self.topLeftHole, self.topRightHole, self.bottomLeftHole, self.bottomRightHole].forEach {
            $0.backgroundColor = .white
        }
    }
    
    private func constructCell() {
        let topLeftGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectedTopLeft))
        let topRightGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectedTopRight))
        let bottomLeftGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectedBottomLeft))
        let bottomRightGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectedBottomRight))
        
        self.topLeftHole.addGestureRecognizer(topLeftGestureRecognizer)
        self.topRightHole.addGestureRecognizer(topRightGestureRecognizer)
        self.bottomLeftHole.addGestureRecognizer(bottomLeftGestureRecognizer)
        self.bottomRightHole.addGestureRecognizer(bottomRightGestureRecognizer)
        
        [self.hockeyNet, self.descriptionLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [self.topLeftHole,
         self.topRightHole,
         self.bottomLeftHole,
         self.bottomRightHole,
         self.smartSnipeLabel].forEach {
            $0.backgroundColor = .white
            self.hockeyNet.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.smartSnipeLabel.backgroundColor = .black
        [self.topLeftHole, self.topRightHole, self.bottomLeftHole, self.bottomRightHole].forEach { hole in
            hole.layer.cornerRadius = sizeOfHole/2
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
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SSMargins.large),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: SSMargins.large)
        ])
    }
}
