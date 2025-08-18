//
//  IrregularEventViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 19.08.2025.
//

import Foundation

final class IrregularEventViewController: BaseTrackerFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новое нерегулярное событие"
        configureRows(with: ["Категория"])
    }
}
