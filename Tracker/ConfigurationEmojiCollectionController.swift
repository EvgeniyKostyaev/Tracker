//
//  ConfigurationEmojiCollectionController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.08.2025.
//

import UIKit

final class ConfigurationEmojiCollectionController: NSObject {
    
    // MARK: - Public Properties
    var onSelectEmoji: ((String) -> Void)?
    
    var emojies: [String] = []
    var selectedEmoji = String()
    
    // MARK: - Private Properties
    private var collectionView: UICollectionView?
    
    // MARK: - Initializers
    convenience init(collectionView: UICollectionView) {
        self.init()
        
        self.collectionView = collectionView
        
        collectionView.register(ConfigurationEmojiCollectionViewCell.self, forCellWithReuseIdentifier: ConfigurationEmojiCollectionViewCell.identifier)
        collectionView.register(TrackerSupplementaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryHeaderView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
    }
    
    // MARK: - Public methods
    func reloadData() {
        collectionView?.reloadData()
    }
}

// MARK: - UICollectionViewDataSource Methods
extension ConfigurationEmojiCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojies.count
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

        header.titleLabel.text = ConfigurationTrackerViewControllerTheme.collectionViewHeaderTitle

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfigurationEmojiCollectionViewCell.identifier, for: indexPath) as? ConfigurationEmojiCollectionViewCell
        
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = emojies[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension ConfigurationEmojiCollectionController: UICollectionViewDelegateFlowLayout {
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
extension ConfigurationEmojiCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ConfigurationEmojiCollectionViewCell
        
        
        if (selectedEmoji == emojies[indexPath.item]) {
            cell?.backgroundColor = .clear
            
            selectedEmoji = String()
        } else {
            cell?.backgroundColor = .trackerLightGray
            
            selectedEmoji = emojies[indexPath.item]
        }
        
        onSelectEmoji?(selectedEmoji)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ConfigurationEmojiCollectionViewCell
        cell?.backgroundColor = .clear
    }
}

