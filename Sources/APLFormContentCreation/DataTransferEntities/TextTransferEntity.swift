//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/// A wrapper class for storing Text as Data. This class inherites from DataTransferEntity and therefore
/// can be used as a data structure when creating a multipart/form-data
/// or application/x-www-form-urlencoded request.
public class TextTransferEntity: DataTransferEntity {
    
    //MARK:- Properties
    public var text: String
    
    //MARK:- Init
    /**
     Creates a TextTransferEntity with the given parameters.
     
     - Parameter text: The String object, which is generated into data for transfer. Mandatory parameter.
     - Parameter name: The name indicating what the text contains. Default value is nil.
     - Parameter encoding: The encoding format, which should be used when converting the text into data. Default value: .utf8
     */
    public init?(text: String, name: String? = nil, encoding: String.Encoding = .utf8) {
        guard let data = text.data(using: encoding) else { return nil }
        self.text = text
        super.init(data: data, contentType: .text,
                   name: name)
    }
}
