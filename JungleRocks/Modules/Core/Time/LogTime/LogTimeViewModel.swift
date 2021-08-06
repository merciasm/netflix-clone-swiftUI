//
//  LogTimeViewModel.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 14/06/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import SwiftUI

class LogTimeViewModel: ObservableObject {
    @Published var areValidFields = false
    @Published var canDismissView = false
    @Published var showLogTimeError = false
    @Published var logTimeError = ""
    @Published var isLogScreenLoading = false
    private var timeRepository = TimeRepository()
    private var category: String?
    private var timeSpent: Int?
    private var startDate: Date?
    private var endDate: Date?

    func onAddClicked() {
        isLogScreenLoading = true
        guard let timeSpent = timeSpent, let category = category else {
            // TODO handle error case
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.string(from: Date())

        let request = TimeAPIManager.PostWorkLog.RequestBody(category: category, timeSpent: timeSpent, workedAt: date)
        timeRepository.postWorklog(requestBody: request) { [weak self] _ in
            self?.canDismissView = true
            self?.isLogScreenLoading = false
        } onError: {  [weak self] error in
            self?.showLogTimeError = true
            self?.logTimeError = error.debugDescription
            self?.canDismissView = false
            self?.isLogScreenLoading = false
        }

    }

    func onCategorySelected(selectedCategory: String?) {
        if selectedCategory != category {
            category = selectedCategory
            areValidFields = validateFields()
        }
    }

    func onStartDateChange(newStartDate: Date?) {
        if newStartDate != startDate {
            startDate = newStartDate
            areValidFields = validateFields()
        }
    }

    func onEndDateChange(newEndDate: Date?) {
        if newEndDate != endDate {
            endDate = newEndDate
            areValidFields = validateFields()
        }
    }

    func validateFields() -> Bool {
        return validateCategory() && validateTimeSpent()
    }

    func validateCategory() -> Bool {
        guard let selectedCategory = category,
            !selectedCategory.isEmpty else {
                return false
        }
        return true
    }

    func validateTimeSpent() -> Bool {
        guard let fromDate = startDate, let toDate = endDate else {
            return false
        }
        if fromDate > toDate {
            return false
        } else {
            let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: fromDate, to: toDate)
            guard let seconds = diffComponents.second, let hours = diffComponents.hour, let minutes = diffComponents.minute else { return false }
            let totalMinutes = hours * 60 + minutes
            let minutesToSeconds = totalMinutes * 60
            let totalSeconds = minutesToSeconds + seconds
            if totalSeconds > 0 {
                timeSpent = totalSeconds
                return true
            } else {
                return false
            }
        }
    }
}
