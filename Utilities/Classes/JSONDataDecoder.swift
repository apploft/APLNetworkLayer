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
            let logger = OSLog(subsystem: "de.apploft.JSONDataDecoder", category:  "error");
            os_log("Data could not be decoded", log: logger, type: .debug)
            throw JSONDataDecoder.DecoderError.dataCouldNotBeDecoded
        }
    }
    
    
    /**
     Creates an object of data type T, which contains data decoded from conttents of file url.
     
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
            let logger = OSLog(subsystem: "de.apploft.JSONDataDecoder", category:  "error");
            os_log("Contents of URL could not be loaded", log: logger, type: .debug)
            throw JSONDataDecoder.DecoderError.contentsOfUrlCouldNotBeLoaded
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyCodingStrategy
        
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            let logger = OSLog(subsystem: "de.apploft.JSONDataDecoder", category:  "error");
            os_log("Data could not be decoded", log: logger, type: .debug)
            throw JSONDataDecoder.DecoderError.dataCouldNotBeDecoded
        }
    }
    
    
    /**
     Creates an object of data type T, which contains data decoded from json file.
     
     - Parameter fileName: Name of the json file
     - Parameter fileExtension: Extension of json file
     - Parameter keyCodingStrategy: Key decoding strategy, e.g. convertFromSnakeCase or useDefaultKeys  (optional)
     
     - Returns: Object of data type T containing decoded data
     */
    public static func fromLocalFile<T: Decodable>(fileName: StaticString, fileExtension: String? = "json", keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> T {
        
        if let fileUrl = Bundle.main.url(forResource: "\(fileName)", withExtension: fileExtension) {
            
            var data:Data
            do {
                data = try Data(contentsOf: fileUrl)
            } catch {
                let logger = OSLog(subsystem: "de.apploft.JSONDataDecoder", category:  "error");
                os_log("Contents of URL could not be loaded", log: logger, type: .debug)
                throw JSONDataDecoder.DecoderError.contentsOfUrlCouldNotBeLoaded
            }
                
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = keyCodingStrategy
            
            do {
                let object = try decoder.decode(T.self, from: data)
                return object
            } catch {
                let logger = OSLog(subsystem: "de.apploft.JSONDataDecoder", category:  "error");
                os_log("Data could not be decoded", log: logger, type: .debug)
                throw JSONDataDecoder.DecoderError.dataCouldNotBeDecoded
            }
            
        } else {
            let logger = OSLog(subsystem: "de.apploft.JSONDataDecoder", category:  "error");
            os_log("File not found", log: logger, type: .debug)
            throw JSONDataDecoder.DecoderError.fileNotFound
        }
    }

}
