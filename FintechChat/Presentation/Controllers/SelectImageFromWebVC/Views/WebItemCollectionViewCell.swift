//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol IWebItemCollectionViewCell: UICollectionViewCell {
    var cellImageView: UIImageView { get set }

    func configure(with: IPixabyImageInfo, model: IImageDownloadingService?)
    
    static var reuseIdentifier: String { get set }
}

class WebItemCollectionViewCell: UICollectionViewCell, IWebItemCollectionViewCell {
    
    static var reuseIdentifier: String = "WebItemCollectionViewCell"
    
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "picture_placeholder")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var selectedIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "success")
        imageView.alpha = 0
        return imageView
    }()
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                UIView.animate(withDuration: 0.3) {
                    self.selectedIconImageView.alpha = 1
                }
            } else {
                self.selectedIconImageView.alpha = 0
            }
            super.isSelected = newValue
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageView.image = #imageLiteral(resourceName: "picture_placeholder")
        self.selectedIconImageView.alpha = 0
    }

    func configure(with: IPixabyImageInfo, model: IImageDownloadingService?) {
        model?.downloadImage(type: .preview, forUrl: with.previewUrl, completion: { (image) in
            DispatchQueue.main.async {
                self.cellImageView.image = image
            }
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        Logger.log(cellImageView.frame.debugDescription)
        Logger.log(self.contentView.frame.debugDescription)
        Logger.log(self.selectedIconImageView.frame.debugDescription)
        Logger.log("")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = .blue
        self.contentView.clipsToBounds = true
        let helperView = UIView()
        //helperView.backgroundColor = .black
        helperView.addSubview(self.cellImageView)
        helperView.insertSubview(self.selectedIconImageView, at: 1)
        self.selectedIconImageView.anchor(top: helperView.topAnchor, left: nil, bottom: nil, right: helperView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        self.selectedIconImageView.heightAnchor.constraint(equalTo: helperView.heightAnchor, multiplier: 0.23).isActive = true
        cellImageView.anchor(top: helperView.topAnchor, left: helperView.leftAnchor, bottom:
                helperView.bottomAnchor, right: helperView.rightAnchor, paddingTop: 0, paddingLeft: 0,
                paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.contentView.addSubview(helperView)
        helperView.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, right: self.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
