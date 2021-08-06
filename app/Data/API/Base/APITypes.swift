//
//  APITypes.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error, Equatable {
    typealias APIErrorDataResponse = DataResponse<Data, AFError>?

    case internetConnection
    case noStatusCode(_ response: APIErrorDataResponse)
    case invalidStatusCode(_ response: APIErrorDataResponse, _ statusCode: Int)
    case objectMapping(_ response: APIErrorDataResponse, _ error: Error?)
    case noData(_ response: APIErrorDataResponse)
    case convertResponse(_ response: APIErrorDataResponse)
    case invalidToken(_ response: APIErrorDataResponse)
    case unkown(_ response: APIErrorDataResponse)

    var localizedDescription: String {
        // TODO
        switch self {
        case .invalidStatusCode(_, let statusCode): return "Invalid status code (\(statusCode))"
        default: return "Something wrong happened"
        }
    }

    var debugDescription: String {
        switch self {
        case .internetConnection: return ""
        case .noStatusCode: return "Could not get status code"
        case .invalidStatusCode(_, let statusCode): return "Invalid status code (\(statusCode))"
        case .objectMapping(_, let error):
            if let error = error as? DecodingError {
                return "Could not decode object.\nReturn type on API Request must be of type APIResponseEmpty if response is empty.\n\(error.localizedDescription)"
            }
            return "Could not decode object."
        case .noData: return "Could not get data"
        case .convertResponse: return "Could not convert response"
        case .invalidToken: return "Invalid token"
        case .unkown: return "Unkown"
        }
    }

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.internetConnection, .internetConnection),
             (.noStatusCode, .noStatusCode),
             (.objectMapping, .objectMapping),
             (.noData, .noData),
             (.convertResponse, .convertResponse),
             (.invalidToken, .invalidToken),
             (.unkown, .unkown): return true
        case (.invalidStatusCode(_, let lhsCode), .invalidStatusCode(_, let rhsCode)):
            return lhsCode == rhsCode
        default: return false
        }
    }
}

enum APIResult<T: Decodable> {
    case success(T)
    case failure(APIError)
}

typealias APIRequest = Request

struct APIResponseEmpty: Decodable { }
