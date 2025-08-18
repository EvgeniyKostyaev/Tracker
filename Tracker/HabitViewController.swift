//
//  HabitViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 19.08.2025.
//

final class HabitViewController: BaseTrackerFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая привычка"
        configureRows(with: ["Категория", "Расписание"])
    }
}
