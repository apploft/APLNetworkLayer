//
//  JSONDataEncoder.swift
//  APLNetworkLayer
//
//  Created by Tino Rachui on 01.08.19.
//

import Foundation
import os.log

public class JSONDataEncoder {

    public enum EncoderError: Error {
        /// Somehow the model object could not be encoded
        case dataCouldNotBeEncoded
    }

    /// Create a data representation of a model object conforming
    /// to 'Encodable'.
    ///
    /// - Parameters:
    ///   - object: the object to encode
    ///   - keyEncodingStrategy: the key encoding strategy, default is 'convertToSnakeCase'
    ///   - dateEncodingStrategy: date encoding strategy, default is 'iso8601'
    /// - Returns: a data representation of the provided model object
    /// - Throws: an error and logs an error to the error console
    public static func encodeObject<T: Encodable>(_ object: T, keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601) throws -> Data {
        let jsonEncoder = JSONEncoder()

        jsonEncoder.keyEncodingStrategy = keyEncodingStrategy
        jsonEncoder.dateEncodingStrategy = dateEncodingStrategy

        do {
            return try jsonEncoder.encode(object)
        } catch let error {
            let logger = OSLog(subsystem: subsystem, category:  "error");
            let debugInfo = error as CustomDebugStringConvertible
            os_log(msgDataNotDecoded, log: logger, type: .debug, debugInfo.debugDescription)
            throw EncoderError.dataCouldNotBeEncoded
        }
    }

    private static let subsystem = "de.apploft.JSONDataEncoder"
    private static let msgDataNotDecoded:StaticString = "Data could not be encoded, error '%@'"
}
