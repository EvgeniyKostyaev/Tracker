//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

private enum Theme {
    static let spacingStackView: CGFloat = 10.0
    static let infoValueFontSizeLabel: CGFloat = 34.0
    static let infoTitleFontSizeLabel: CGFloat = 16.0
    static let numberOfLinesLabel: Int = 1
    static let infoStackViewConstraint: CGFloat = 14.0
    
    enum EmptyStateView {
        static let emptyStateViewLeadingConstraint: CGFloat = 16.0
        static let emptyStateViewTrailingConstraint: CGFloat = -16.0
    }
    
    enum InfoContainerView {
        static let infoViewTopConstraint: CGFloat = 40.0
        static let infoViewLeadingConstraint: CGFloat = 16.0
        static let infoViewTrailingConstraint: CGFloat = -16.0
        static let infoViewHeightConstraint: CGFloat = 90.0
        
        static let infoViewGradientBorderLineWidth: CGFloat = 1.0
        static let infoViewGradientBorderCornerRadius: CGFloat = 16.0
    }
}

final class StatisticViewController: UIViewController {
    
    // MARK: - Private Properties
    private let trackerRecordDataProvider = TrackerRecordDataProvider.shared
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(image: UIImage(resource: .nothingAnalize), text: "statistic_empty_satate_title".localized)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        return emptyStateView
    }()
    
    private lazy var infoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView  = UIStackView(arrangedSubviews: [infoValueLabel, infoTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = Theme.spacingStackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: Theme.infoValueFontSizeLabel, weight: .bold)
        label.numberOfLines = Theme.numberOfLinesLabel
        return label
    }()
    
    private lazy var infoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "statistic_trackers_complited".localized
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: Theme.infoTitleFontSizeLabel, weight: .medium)
        label.numberOfLines = Theme.numberOfLinesLabel
        return label
    }()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        setupTitle()
        setupLayout()
        
        updateStatisticUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        infoContainerView.setGradientBorder(
            colors: [
                .trackerColorCollection1,
                .trackerColorCollection9,
                .trackerColorCollection3
            ],
            lineWidth: Theme.InfoContainerView.infoViewGradientBorderLineWidth,
            cornerRadius: Theme.InfoContainerView.infoViewGradientBorderCornerRadius
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    private func setupTitle() {
        title = "common_statistic".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupLayout() {
        view.addSubview(emptyStateView)
        view.addSubview(infoContainerView)
        infoContainerView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.EmptyStateView.emptyStateViewLeadingConstraint),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.EmptyStateView.emptyStateViewTrailingConstraint),
            
            infoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.InfoContainerView.infoViewTopConstraint),
            infoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.InfoContainerView.infoViewLeadingConstraint),
            infoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.InfoContainerView.infoViewTrailingConstraint),
            infoContainerView.heightAnchor.constraint(equalToConstant: Theme.InfoContainerView.infoViewHeightConstraint),
            
            infoStackView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: Theme.infoStackViewConstraint),
            infoStackView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: Theme.infoStackViewConstraint),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -Theme.infoStackViewConstraint),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -Theme.infoStackViewConstraint)
        ])
    }
    
    private func updateStatisticUI() {
        let trackersComplitedCount = trackersComplitedCount()
        
        if (trackersComplitedCount > 0) {
            infoContainerView.isHidden = false
            infoValueLabel.text = String(trackersComplitedCount)
            
            emptyStateView.isHidden = true
        } else {
            emptyStateView.isHidden = false
            infoContainerView.isHidden = true
        }
    }
    
    private func trackersComplitedCount() -> Int {
        return trackerRecordDataProvider.trackerRecords.count
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRecordsUpdate),
            name: TrackerRecordDataProvider.recordsDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func handleRecordsUpdate() {
        updateStatisticUI()
    }
}
