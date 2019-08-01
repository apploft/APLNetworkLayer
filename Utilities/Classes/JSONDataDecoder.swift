//
//  JSONDataDecoderInt.swift
//  TestInterfaceJsonLoader
//
//  Created by Ahmet Akbal on 16.05.19.
//  Copyright © 2019 Ahmet Akbal. All rights reserved.
//

import Foundation
import os.log

extension JSONDataDecoder {
    
    public enum DecoderError: Error {
        case fileNotFound
        case contentsOfUrlCouldNotBeLoaded
        case dataCouldNotBeDecoded
    }
}

public class JSONDataDecoder {
    
    private static let subsystem = "de.apploft.JSONDataDecoder"
    private static let msgFileNotFound:StaticString = "File '%@.%@' not found"
    private static let msgFileNotFoundWithoutExt:StaticString = "File '%@' not found"
    private static let msgContentsOfUrlNotLoaded:StaticString = "Contents of URL '%@' could not be loaded, error '%@'"
    private static let msgDataNotDecoded:StaticString = "Data could not be decoded, error '%@'"
    
    
    /**
     Creates an object of data type T, which contains data decoded from a data object.
     
     - Parameter data: Data object, which will be decoded
     - Parameter keyCodingStrategy: Key decoding strategy, e.g. convertFromSnakeCase or useDefaultKeys  (optional)
     - Parameter dateDecodingStrategy: Date decoding stategy for handling of date properties

     - Returns: Object of data type T containing decoded data
     */
    
    public static func fromData<T: Decodable>(data: Data, keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) throws -> T {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyCodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy

        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch let error {
            let logger = OSLog(subsystem: subsystem, category:  "error");
            let debugInfo = error as CustomDebugStringConvertible
            os_log(msgDataNotDecoded, log: logger, type: .debug, debugInfo.debugDescription )
            throw JSONDataDecoder.DecoderError.dataCouldNotBeDecoded
        }
    }
    
    
    /**
     Creates an object of data type T, which contains data decoded from contents of file url.
     
     - Parameter fileUrl: URL object, whoose data will be decoded
     - Parameter keyCodingStrategy: Key decoding strategy, e.g. convertFromSnakeCase or useDefaultKeys (optional)
     - Parameter dateDecodingStrategy: Date decoding stategy for handling of date properties

     - Returns: Object of data type T containing decoded data
     */
    
    public static func fromFileURL<T: Decodable>(_ fileUrl: URL, keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) throws -> T {
        
        #if DEBUG
            let urlComp = URLComponents(url: fileUrl, resolvingAgainstBaseURL: false)
            assert(urlComp?.scheme == "file")
        #endif

        var data:Data

        do {
            data = try Data(contentsOf: fileUrl)
        } catch let error {
            let logger = OSLog(subsystem: subsystem, category:  "error");
            let debugInfo = error as CustomDebugStringConvertible
            os_log(msgContentsOfUrlNotLoaded ,log: logger, type: .debug, fileUrl.absoluteString, debugInfo.debugDescription)
            throw JSONDataDecoder.DecoderError.contentsOfUrlCouldNotBeLoaded
        }
        
        return try fromData(data: data, keyCodingStrategy: keyCodingStrategy, dateDecodingStrategy: dateDecodingStrategy)
    }
    
    
    /**
     Creates an object of data type T, which contains data decoded from json file.
     
     - Parameter fileName: Name of the json file
     - Parameter fileExtension: Extension of json file
     - Parameter keyCodingStrategy: Key decoding strategy, e.g. convertFromSnakeCase or useDefaultKeys  (optional)
     - Parameter dateDecodingStrategy: Date decoding stategy for handling of date properties
     
     - Returns: Object of data type T containing decoded data
     */
    public static func fromLocalFileNamed<T: Decodable>(_ fileName: StaticString, fileExtension: String? = "json", keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) throws -> T {
        
        guard let fileUrl = Bundle.main.url(forResource: "\(fileName)", withExtension: fileExtension) else {
            let logger = OSLog(subsystem: subsystem, category:  "error");

            if (fileExtension == nil) {
                os_log(msgFileNotFoundWithoutExt, log: logger, type: .debug, "\(fileName)")
            } else {
                os_log(msgFileNotFound, log: logger, type: .debug, "\(fileName)", fileExtension!)
            }
            throw JSONDataDecoder.DecoderError.fileNotFound
        }

        return try fromFileURL(fileUrl, keyCodingStrategy: keyCodingStrategy, dateDecodingStrategy: dateDecodingStrategy)
    }

}
