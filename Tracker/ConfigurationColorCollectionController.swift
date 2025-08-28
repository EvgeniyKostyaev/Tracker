//
//  ConfigurationColorCollectionController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.08.2025.
//

import UIKit

enum ConfigurationColorCollectionControllerTheme {
    static let headerTitle: String = "Цвет"
    
    static let cellBorderWidth: CGFloat = 3.0
    static let cellWithoutBorder: CGFloat = 0.0
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

        header.titleLabel.text = ConfigurationColorCollectionControllerTheme.headerTitle

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
        return CGSize(width: collectionView.bounds.width, height: ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewPaddingWidth
        let cellWidth =  availableWidth / CGFloat(ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewCellCount)
        
        return CGSize(width: cellWidth,
                      height: ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewTopInset,
            left: ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewLeftInset,
            bottom: ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewBottomInset,
            right: ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewRightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ConfigurationTrackerViewControllerTheme.CollectionView.collectionViewCellSpacing
    }
}

// MARK: - UICollectionViewDelegate Methods
extension ConfigurationColorCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ConfigurationColorCollectionViewCell
        
        
        if (selectedColor == colors[indexPath.item]) {
            cell?.contentView.layer.borderWidth = ConfigurationColorCollectionControllerTheme.cellWithoutBorder
            
            selectedColor = .clear
        } else {
            cell?.contentView.layer.borderWidth = ConfigurationColorCollectionControllerTheme.cellBorderWidth
            cell?.contentView.layer.borderColor = colors[indexPath.item].withAlphaComponent(ConfigurationTrackerViewControllerTheme.alphaComponent).cgColor
            
            selectedColor = colors[indexPath.item]
        }
        
        onSelectColor?(selectedColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ConfigurationColorCollectionViewCell
        cell?.contentView.layer.borderWidth = ConfigurationColorCollectionControllerTheme.cellWithoutBorder
    }
}

