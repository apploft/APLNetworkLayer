//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/**
This class is for creating application/x-www-form-urlencoded POST requests. It is initialized with transfer data and
after initialization the content type value for the header and the body of the transfare data are generated for the POST
request.
This form content type should be used for transmiting plain text or small payloads. Otherwiserwise use MultipartFormDataContentType.

   *Example*

    let textTransferEntity = TextTransferEntity(text: "Test")
    let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: textTransferEntity)
   
    let contentTypeValue = applicationURLEncodedContentType.getContentTypeValue()
    let header = ["content type" : contentTypeValue]
 
    let body = applicationURLEncodedContentType.getBody()
*/
public class ApplicationURLEncodedContentType: FormContentType {
    
    //MARK:- Properties
    private var dataTransferEntity: DataTransferEntity
    
    //MARK:- Init
    required public init(dataTransferEntity: DataTransferEntity) {
        self.dataTransferEntity = dataTransferEntity
    }
    
    //MARK:- Interface
    public func getContentTypeValue() -> String {
        return "application/x-www-form-urlencoded"
    }
    
    public func getBody() -> Data {
        return self.dataTransferEntity.data
    }
}
