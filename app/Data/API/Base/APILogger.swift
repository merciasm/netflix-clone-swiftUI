//
//  APILogger.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 8/5/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation
import Alamofire

public enum APILoggerLevel {
    /// Do not log requests or responses.
    case off

    /// Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
    case info

    /// Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
    case debug

    static func highestLoggerLevel(_ first: APILoggerLevel, _ second: APILoggerLevel) -> APILoggerLevel {
        switch (first, second) {
        case (.info, _), (_, .info): return .info
        case (.debug, _), (_, .debug): return .debug
        default: return .off
        }
    }
}

public class APILogger {

    /// The shared network activity logger for the system.
    public static let shared = APILogger()

    /// The level of logging detail. See APILoggerLevel enum for possible values. .debug by default.
    public var level: APILoggerLevel

    private var requestsLoggerLevel: [String: APILoggerLevel] = [:]

    /// Omit requests which match the specified predicate, if provided.
    public var filterPredicate: NSPredicate?

    // MARK: Life cycle

    init() {
        level = .debug
    }

    deinit {
        stopLogging()
    }

    // MARK: - Logging

    /// Start logging requests and responses.
    public func startLogging() {
        stopLogging()

        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(
            self,
            selector: #selector(APILogger.requestDidStart(notification:)),
            name: Request.didResumeNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(APILogger.requestDidFinish(notification:)),
            name: Request.didFinishNotification,
            object: nil
        )
    }

    /// Stop logging requests and responses

    public func stopLogging() {
        NotificationCenter.default.removeObserver(self)
    }

    public func addRequestToLogger(request: DataRequest, loggerLevel: APILoggerLevel) {
        requestsLoggerLevel[request.id.uuidString] = loggerLevel
    }

    public func removeRequestFromLogger(requestId: UUID) {
        requestsLoggerLevel[requestId.uuidString] = nil
    }

    // MARK: - Private - Notifications

    @objc private func requestDidStart(notification: Notification) {
        guard let dataRequest = notification.request as? DataRequest,
            let requestLoggerLevel = requestsLoggerLevel[dataRequest.id.uuidString],
            let task = dataRequest.task,
            let request = task.originalRequest,
            let httpMethod = request.httpMethod,
            let requestURL = request.url else { return }

        let loggerLevel = self.getLoggerLevel(forRequestLoggerLevel: requestLoggerLevel)

        if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
            return
        }

        switch loggerLevel {
        case .debug:
            self.logDivider()

            log.d("\(httpMethod) '\(requestURL.absoluteString)':")

            if let httpHeadersFields = request.allHTTPHeaderFields {
                self.logHeaders(headers: httpHeadersFields)
            }

            if let httpBody = request.httpBody, let httpBodyString = String(data: httpBody, encoding: .utf8) {
                log.d("Body:", httpBodyString.prettyPrintedJSONString ?? httpBodyString, separator: "\n")
            }
        case .info:
            self.logDivider()

            log.d("\(httpMethod) '\(requestURL.absoluteString)'")
        default:
            break
        }
    }

    @objc private func requestDidFinish(notification: Notification) {
        guard let dataRequest = notification.request as? DataRequest,
            let requestLoggerLevel = requestsLoggerLevel[dataRequest.id.uuidString],
            let task = dataRequest.task,
            let metrics = dataRequest.metrics,
            let request = task.originalRequest,
            let httpMethod = request.httpMethod,
            let requestURL = request.url
            else {
                return
        }

        let loggerLevel = self.getLoggerLevel(forRequestLoggerLevel: requestLoggerLevel)
        removeRequestFromLogger(requestId: dataRequest.id)

        if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
            return
        }

        let elapsedTime = metrics.taskInterval.duration

        if let error = task.error {
            switch loggerLevel {
            case .debug, .info:
                self.logDivider()

                log.d("[Error] \(httpMethod) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:", error)
            default:
                break
            }
        } else {
            guard let response = task.response as? HTTPURLResponse else {
                return
            }

            switch loggerLevel {
            case .debug:
                self.logDivider()

                log.d("\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")

                self.logHeaders(headers: response.allHeaderFields)

                guard let data = dataRequest.data else { break }

                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        log.d(prettyString)
                    }
                } catch {
                    if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        log.d(string)
                    }
                }
            case .info:
                self.logDivider()

                log.d("\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]")
            default:
                break
            }
        }
    }

    // MARK: Private - Helper methods

    private func getLoggerLevel(forRequestLoggerLevel loggerLevel: APILoggerLevel) -> APILoggerLevel {
        return APILoggerLevel.highestLoggerLevel(loggerLevel, self.level)
    }
}

fileprivate extension APILogger {
    func logDivider(_ count: Int = 40) {
        log.d("\n", String(repeating: "-", count: count), separator: "")
    }

    func logHeaders(headers: [AnyHashable: Any]) {
        log.d("Headers:", "[", separator: "\n")
        for (key, value) in headers {
            log.d("  \(key): \(value)")
        }
        log.d("]")
    }
}

fileprivate extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

fileprivate extension String {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription

        let data = self.data(using: .utf8)

        return data?.prettyPrintedJSONString
    }
}
