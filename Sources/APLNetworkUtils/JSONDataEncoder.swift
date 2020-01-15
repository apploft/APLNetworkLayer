//
//  JSONDataEncoder.swift
//  APLNetworkLayer
//
//  Created by apploft on 15.01.2020.
//  Copyright © 2020 apploft GmbH. All rights reserved.

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
    @available(OSX 10.12, *)
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
