//
//  APIRequestableResponseValidator.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation
import Alamofire

struct APIRequestableResponseValidator {

    // MARK: Variables

    var response: DataResponse<Data, AFError>?
    var statusCode: Int = -1
    var data: Data = Data()

    // MARK: Modifier initializers

    @discardableResult
    func with(statusCode: Int?) throws -> APIRequestableResponseValidator {
        guard let statusCode = statusCode else { throw APIError.noStatusCode(response) }
        return APIRequestableResponseValidator(response: response, statusCode: statusCode, data: data)
    }

    @discardableResult
    func with(data: Data?) throws -> APIRequestableResponseValidator {
        guard let data = data else { throw APIError.noData(response) }
        return APIRequestableResponseValidator(response: response, statusCode: statusCode, data: data)
    }

    // MARK: Validators

    @discardableResult
    func validate(statusCodeInRange range: ClosedRange<Int>) throws -> APIRequestableResponseValidator {
        guard range ~= statusCode else { throw APIError.invalidStatusCode(response, statusCode) }
        return self
    }

    @discardableResult
    func validateUnauthorizedStatusCode() throws -> APIRequestableResponseValidator {
        guard statusCode != 401 else { throw APIError.invalidToken(response) }
        return self
    }

    // MARK: Tranformation methods

    func toDataConverter() -> APIRequestableDataConverter {
        return APIRequestableDataConverter(fromResponseValidator: self)
    }
}
