//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/// The protocol each form content type must implement since it contains the basic
/// functionalities of providing the needed content type value for the header and a generated body of a POST request.
public protocol FormContentType {
    
    /**
     Initilize the form content type with a DataTransferEntity. The DataTransferEntity
     stores the data obejct, which should be transfered and its properties which
     will be added accordingly into the transfered body.
     - Parameter dataTransferEntity: The DataTransferEntity which is used to generate the the body.
    */
    init(dataTransferEntity: DataTransferEntity)
    
    /**
    Returns the generated content type value of the DataTransferEntity. The value should be added to the POST request's header.
     
    *Example*
     
            let contentTypeValue = formContentTypeClass.getContentTypeValue()
            let header = ["Content-Type" : contentTypeValue]
     */
    func getContentTypeValue() -> String
    
    /**
    Returns the generated body of the DataTransferEntity. The body should be added to the POST request.
     
    *Example*
     
            let body = formContentTypeClass.getBody()
     */
    func getBody() -> Data
}
