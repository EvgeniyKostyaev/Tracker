//
//  ConfigurationColorCollectionController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.08.2025.
//

import UIKit

private enum Theme {
    static let headerTitle: String = "Цвет"
    
    static let cellBorderWidth: CGFloat = 3.0
    static let cellWithoutBorder: CGFloat = 0.0
    
    static let alphaComponent: CGFloat = 0.3
    
    enum CollectionView {
        static let collectionViewHeaderHeight: CGFloat = 44.0
        static let collectionViewCellHeight: CGFloat = 52.0
        static let collectionViewCellCount: Int = 6
        static let collectionViewTopInset: CGFloat = 10.0
        static let collectionViewBottomInset: CGFloat = 0.0
        static let collectionViewLeftInset: CGFloat = 16.0
        static let collectionViewRightInset: CGFloat = 16.0
        static let collectionViewCellSpacing: CGFloat = 10.0
        static let collectionViewPaddingWidth = collectionViewLeftInset + collectionViewRightInset + CGFloat(collectionViewCellCount - 1) * collectionViewCellSpacing
        
        static let collectionViewTopConstraint: CGFloat = 20.0
        static let collectionViewHeightConstraint: CGFloat = 230.0
    }
}

final class ConfigurationColorCollectionController: NSObject {
    
    // MARK: - Public Properties
    var onSelectColor: ((UIColor) -> Void)?
    
    var colors: [UIColor] = []
    var selectedColor: UIColor = .clear
    
    // MARK: - Private Properties
    private var collectionView: UICollectionView?
    
    // MARK: - Initializers
    convenience init(collectionView: UICollectionView) {
        self.init()
        
        self.collectionView = collectionView
        
        collectionView.register(ConfigurationColorCollectionViewCell.self, forCellWithReuseIdentifier: ConfigurationColorCollectionViewCell.identifier)
        collectionView.register(TrackerSupplementaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryHeaderView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource Methods
extension ConfigurationColorCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSupplementaryHeaderView.identifier,
            for: indexPath
        ) as? TrackerSupplementaryHeaderView
        
        guard let header else {
            return UICollectionReusableView()
        }

        header.titleLabel.text = Theme.headerTitle

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfigurationColorCollectionViewCell.identifier, for: indexPath) as? ConfigurationColorCollectionViewCell else { return UICollectionViewCell()}
        
        cell.containerView.backgroundColor = colors[indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension ConfigurationColorCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Theme.CollectionView.collectionViewHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - Theme.CollectionView.collectionViewPaddingWidth
        let cellWidth =  availableWidth / CGFloat(Theme.CollectionView.collectionViewCellCount)
        
        return CGSize(width: cellWidth,
                      height: Theme.CollectionView.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Theme.CollectionView.collectionViewTopInset,
            left: Theme.CollectionView.collectionViewLeftInset,
            bottom: Theme.CollectionView.collectionViewBottomInset,
            right: Theme.CollectionView.collectionViewRightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Theme.CollectionView.collectionViewCellSpacing
    }
}

// MARK: - UICollectionViewDelegate Methods
extension ConfigurationColorCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ConfigurationColorCollectionViewCell
        
        
        if (selectedColor == colors[indexPath.item]) {
            cell?.contentView.layer.borderWidth = Theme.cellWithoutBorder
            
            selectedColor = .clear
        } else {
            cell?.contentView.layer.borderWidth = Theme.cellBorderWidth
            cell?.contentView.layer.borderColor = colors[indexPath.item].withAlphaComponent(Theme.alphaComponent).cgColor
            
            selectedColor = colors[indexPath.item]
        }
        
        onSelectColor?(selectedColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ConfigurationColorCollectionViewCell
        cell?.contentView.layer.borderWidth = Theme.cellWithoutBorder
    }
}

