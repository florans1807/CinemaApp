//
//  HomeCell.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 20.03.2024.
//

import UIKit
import Kingfisher
import SnapKit

protocol CellModelRepresanteble {
    var viewModel: CellViewModelProtocol? { get }
}

final class KPListCollectionViewCell: UICollectionViewCell, CellModelRepresanteble {
    
    // MARK: - Properties
    var viewModel: CellViewModelProtocol? {
        didSet {
            configure()
        }
    }
    
    private let collectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let kpListNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.sizeToFit()
        return label
    }()
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func commonInit() {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(collectionImageView)
        stackView.addArrangedSubview(kpListNameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        collectionImageView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
    }
    
    private func configure() {
        guard let imageURL = URL(string: viewModel?.imageUrl ?? "") else { return }
        collectionImageView.kf.indicatorType = .activity
        collectionImageView.kf.setImage(
            with: imageURL,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        kpListNameLabel.text = viewModel?.cellItemName
    }
}
