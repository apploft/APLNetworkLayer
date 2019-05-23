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
    private static let msgContentsOfUrlNotLoaded:StaticString = "Contents of URL '%@' could not be loaded"
    private static let msgDataNotDecoded:StaticString = "Data could not be decoded"
    
    
    /**
     Creates an object of data type T, which contains data decoded from a data object.
     
     - Parameter data: Data object, which will be decoded
     - Parameter keyCodingStrategy: Key decoding strategy, e.g. convertFromSnakeCase or useDefaultKeys  (optional)
     
     - Returns: Object of data type T containing decoded data
     */
    
    public static func fromData<T: Decodable>(data: Data, keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> T {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyCodingStrategy
        
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            let logger = OSLog(subsystem: subsystem, category:  "error");
            os_log(msgDataNotDecoded, log: logger, type: .debug)
            throw JSONDataDecoder.DecoderError.dataCouldNotBeDecoded
        }
    }
    
    
    /**
     Creates an object of data type T, which contains data decoded from contents of file url.
     
     - Parameter fileUrl: URL object, whoose data will be decoded
     - Parameter keyCodingStrategy: Key decoding strategy, e.g. convertFromSnakeCase or useDefaultKeys (optional)
     
     - Returns: Object of data type T containing decoded data
     */
    
    public static func fromURL<T: Decodable>(fileUrl: URL, keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> T {
        
        #if DEBUG
            let urlComp = URLComponents(url: fileUrl, resolvingAgainstBaseURL: false)
            assert(urlComp?.scheme == "file")
        #endif

        var data:Data
        do {
            data = try Data(contentsOf: fileUrl)
        } catch {
            let logger = OSLog(subsystem: subsystem, category:  "error");
            os_log(msgContentsOfUrlNotLoaded ,log: logger, type: .debug, fileUrl.absoluteString)
            
            throw JSONDataDecoder.DecoderError.contentsOfUrlCouldNotBeLoaded
        }
        
        return try fromData(data: data)
    }
    
    
    /**
     Creates an object of data type T, which contains data decoded from json file.
     
     - Parameter fileName: Name of the json file
     - Parameter fileExtension: Extension of json file
     - Parameter keyCodingStrategy: Key decoding strategy, e.g. convertFromSnakeCase or useDefaultKeys  (optional)
     
     - Returns: Object of data type T containing decoded data
     */
    public static func fromLocalFile<T: Decodable>(fileName: StaticString, fileExtension: String? = "json", keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> T {
        
        guard let fileUrl = Bundle.main.url(forResource: "\(fileName)", withExtension: fileExtension) else {
            
            let logger = OSLog(subsystem: subsystem, category:  "error");
            if (fileExtension == nil) {
                os_log(msgFileNotFoundWithoutExt, log: logger, type: .debug, "\(fileName)")
            } else {
                os_log(msgFileNotFound, log: logger, type: .debug, "\(fileName)", fileExtension!)
            }
            throw JSONDataDecoder.DecoderError.fileNotFound
        }
        
        return try fromURL(fileUrl: fileUrl)
    }

}
