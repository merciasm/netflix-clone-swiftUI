//
//  TimeViewModel.swift
//  junglerocks-ios
//
//  Created by Pedro Freddi on 07/08/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import RxSwift
import SwiftUI

enum TimeListInfo {
    case projectActivity(project: Project, worklogs: [Worklog], isExpanded: Bool)
    case otherActivity(type: String, worklogs: [Worklog], isExpanded: Bool)
    case timeLog(worklog: Worklog)
}

struct ProjectInfo: Identifiable {
    let id = UUID()
    let project: Project
    let worklogs: [Worklog]
}

struct ActivityInfo: Identifiable {
    let id = UUID()
    let type: String
    let worklogs: [Worklog]
}

class TimeViewModel: ObservableObject {

    init(timeRepository: TimeRepository, projectRepository: ProjectRepository) {
        isLoading = true
        self.timeRepository = timeRepository
        self.projectRepository = projectRepository
        self.fetchWorklogs()
        self.fetchProjects()
        self.timeInfoList.subscribe(onNext: { [weak self] section in
            self?.timeInfoSubject.onNext(section)
        }).disposed(by: disposeBag)
    }

    // MARK: Variables
    // TODO: Continue to implement the behavior subject
    typealias Section = (header: String, content: [TimeListInfo])
    private let disposeBag = DisposeBag()
    private let timeRepository: TimeRepository
    private let projectRepository: ProjectRepository
    private var expandedCellsSubject = BehaviorSubject<[String]>(value: [])
    private var projects: [Project] = []
    private var timeInfoList: Observable<[TimeViewModel.Section]> {
        return Observable.combineLatest(timeRepository.worklogsSubject, projectRepository.projectsSubject, expandedCellsSubject).map { (worklogs, projects, expandedCells) -> [TimeViewModel.Section] in
            self.projects = projects
            self.worklogs = worklogs
            return self.createTimeLists(worklogs: worklogs, projects: projects, expandedCells: expandedCells)
        }
    }
    var timeInfoSubject = BehaviorSubject<[Section]>(value: [])

    @Published var worklogs: [Worklog] = []
    @Published var projectActivitiesList: [ProjectInfo] = []
    @Published var otherActivitiesList: [ActivityInfo] = []
    @Published var chartTime: [ChartCellModel] = []
    @Published var isLoading = false
    @Published var projectTimeSpent = ""
    @Published var activityTimeSpent = ""

    private func createTimeLists(worklogs: [Worklog], projects: [Project], expandedCells: [String]) -> [TimeViewModel.Section] {
        guard worklogs.count > 0, projects.count > 0 else {
            return []
        }
        var output: [TimeViewModel.Section] = []
        let worklogMap = Dictionary(grouping: worklogs, by: { worklog in worklog.issue?.projectKey ?? "other" })

        var otherActivitiesMap: [String: [Worklog]] = [:]
        if let otherWorklogs = worklogMap["other"] {
            otherActivitiesMap = Dictionary(grouping: otherWorklogs, by: { worklog in worklog.category })
        }

        var projectActivities: [TimeListInfo] = []

        for project in projects {
            if let worklogs = worklogMap[project.key] {
                projectActivitiesList.append(ProjectInfo(project: project, worklogs: worklogs))
                projectActivities.append(.projectActivity(project: project, worklogs: worklogs, isExpanded: expandedCells.contains(project.key)))
            }
        }

        output.append((header: "Projects", content: projectActivities))

        var otherActivities: [TimeListInfo] = []

        for key in otherActivitiesMap.keys {
            if let otherWorklogsByCategory = otherActivitiesMap[key] {
                otherActivitiesList.append(ActivityInfo(type: key, worklogs: otherWorklogsByCategory))
                otherActivities.append(.otherActivity(type: key, worklogs: otherWorklogsByCategory, isExpanded: expandedCells.contains(key)))
            }
        }

        setupChartData()
        setupActivityTime()

        output.append((header: "Other Activities", content: otherActivities))
        isLoading = false
        return output
    }

    func setupChartData() {
        let colors: [Color] = [.blue, .yellow, .red, .green, .pink, .black, .orange, .purple, .gray, .init(UIColor.brown)] // TODO: change this later
        var counter = 0

        if projectActivitiesList.count < 11 {
            for project in projectActivitiesList {
                let totalTime = project.worklogs.reduce(0, { accumulatedResult, worklog -> Int in
                    return (accumulatedResult + worklog.timeSpent)
                })
                chartTime.append(ChartCellModel(color: colors[counter], value: CGFloat(totalTime), name: project.project.name))
                counter += 1
            }
        } else { // Workaround
            for project in projectActivitiesList {
                let totalTime = project.worklogs.reduce(0, { accumulatedResult, worklog -> Int in
                    return (accumulatedResult + worklog.timeSpent)
                })
                chartTime.append(ChartCellModel(color: .black, value: CGFloat(totalTime), name: project.project.name))
                counter += 1
            }
        }
    }

    func setupActivityTime() {
        var activityTotal = 0
        var projectTotal = 0
        for activity in otherActivitiesList {
            activityTotal += activity.worklogs.reduce(0, { accumulatedResult, worklog -> Int in
                return (accumulatedResult + worklog.timeSpent)
            })
        }
        activityTimeSpent = activityTotal.getTimeSpentString()

        for project in projectActivitiesList {
            projectTotal += project.worklogs.reduce(0, { accumulatedResult, worklog -> Int in
                return (accumulatedResult + worklog.timeSpent)
            })
        }
        projectTimeSpent = projectTotal.getTimeSpentString()
    }

    func onCellClicked(timeListInfo: TimeListInfo) {
        var expandedCells: [String] = (try? expandedCellsSubject.value()) ?? []
        switch timeListInfo {
        case .projectActivity(let project, _, let isExpanded):
            if isExpanded {
                expandedCells.removeAll(where: { key in
                    key == project.key
                })
            } else {
                expandedCells.append(project.key)
            }
        case .otherActivity(let type, _, let isExpanded):
            if isExpanded {
                expandedCells.removeAll(where: { key in
                    key == type
                })
            } else {
                expandedCells.append(type)
            }
        case .timeLog:
            // TODO: Handles a click in the Timelogs
            break
        }
        expandedCellsSubject.onNext(expandedCells)
    }

    // MARK: Private

    private func fetchWorklogs() {
        timeRepository.fetchWorklogs()
    }

    private func fetchProjects() {
        projectRepository.fetchProjects()
    }
}
