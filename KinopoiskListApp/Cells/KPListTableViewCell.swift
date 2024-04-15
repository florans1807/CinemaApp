//
//  KPListTableViewCell.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 12.04.2024.
//

import UIKit
import Kingfisher
import SnapKit

final class KPListTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "KPListTableViewCell"
    
    private let kpListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        //imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let kpListNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 3
        //label.backgroundColor = .green
        return label
    }()
    
    let labelRowId: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textAlignment = .left
        label.isSkeletonable = true
        //label.backgroundColor = .green
        return label
    }()
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = .red
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func commonInit() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.isSkeletonable = true
        //stackView.backgroundColor = .orange
        stackView.addArrangedSubview(labelRowId)
        stackView.addArrangedSubview(kpListImageView)
        stackView.addArrangedSubview(kpListNameLabel)
        
        contentView.addSubview(stackView)
        
        //Setup Constraints
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
                .inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
        }
        
        labelRowId.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.width.equalTo(15)
        }
        
        kpListImageView.snp.makeConstraints { make in
            make.width.equalTo(kpListImageView.snp.height)
        }
        
        kpListNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure UI Data with KPList
    func configure(with collection: KPList) {
        guard let imageURL = URL(string: collection.cover.url) else { return }
        kpListImageView.kf.indicatorType = .activity
        kpListImageView.kf.setImage(
            with: imageURL,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        kpListNameLabel.text = collection.name
    }
}