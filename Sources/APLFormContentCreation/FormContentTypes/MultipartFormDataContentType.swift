//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/**
This class is for creating multipart/form-data POST requests. It is initialized with dataTransferEntity and
after initialization the content type value and the content length for the header, as well as the body of the
transfare data are generated for the POST request.
The Boundary format: --Boundary-XXXX
This form content type should be used for binary (non-alphanumeric) data or a significantly sized payload, like images.

   *Example*

    let textTransferEntity = TextTransferEntity(text: "Test")
    let multipartFormDataContentType = MultipartFormDataContentType(dataTransferEntity: textTransferEntity)
   
    let contentTypeValue = multipartFormDataContentType.getContentTypeValue()
    let contentLength =  multipartFormDataContentType.getContentLength()
    header["Content-Type"] =  contentTypeValue
    header["content-length"] = contentLength
 
    let body = multipartFormDataContentType.getBody()
*/

public class MultipartFormDataContentType: FormContentType {
    
    //MARK:- Properties
    private var dataTransferEntities: [DataTransferEntity]
    private var parameters: [String: String]? = nil
    
    private let boundary = "Boundary-\(UUID().uuidString)"
    private var body = Data()
    
    private var nameForTransferFiles: String = "files"
    private var singleFileTransfer: Bool {
        return dataTransferEntities.count == 1
    }
    
    //MARK:- Init
    required public init(dataTransferEntity: DataTransferEntity) {
        self.dataTransferEntities = [dataTransferEntity]
        appendDataTransferEntitiesToBody()
    }
    
    /**
     Initilize the MultipartFormDataContentType with the DataTransferEntity and with
     additional parameters to transfer. The DataTransferEntity stores the data obejct,
     which should be transfered and its properties which will be added accordingly
     into the generated body.
     - Parameter dataTransferEntity: The DataTransferEntity which is used to generate the body.
     - Parameter parameters: Parameters which can be added additionally to the generated body. Parameters consist of a key and a value.
     */
    public init(dataTransferEntity: DataTransferEntity,
                parameters: [String: String]? = nil) {
        self.dataTransferEntities = [dataTransferEntity]
        self.parameters = parameters
        appendParametersToBody()
        appendDataTransferEntitiesToBody()
    }
    
    /**
     Initilize the MultipartFormDataContentType with an array of DataTransferEntity and with
     additional parameters to transfer. The DataTransferEntities store all the data obejcts,
     which should be transfered and their properties which will be added accordingly
     into the generated body.
     - Parameter dataTransferEntities: The DataTransferEntities which are used to generate the body.
     - Parameter parameters: Parameters which can be added additionally to the request. Parametes consist of a key and a value.
     - Parameter nameForTransferFiles: If more than one DataTransferEntity is injected,
     this is the name all of the transfered files will be labled with, since based on RFC 7578:
     'multiple files must be sent with the same "name" parameter.'
     */
    public init(dataTransferEntities: [DataTransferEntity],
         parameters: [String: String]? = nil, nameForTransferFiles: String  = "files") {
        self.dataTransferEntities = dataTransferEntities
        self.parameters = parameters
        self.nameForTransferFiles = nameForTransferFiles
        appendParametersToBody()
        appendDataTransferEntitiesToBody()
    }
    
    //MARK:- Interface
    /**
    Returns the content length of the generated body. The content lenght should be added to the POST request's header.
     
    *Example*
     
            let contentLength = multipartFormDataContentType.getContentLength()
            let header = ["content-length" : contentLength]
     */
    public func getContentLength() -> String {
        return "\(self.body.count)"
    }
    
    public func getContentTypeValue() -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    public func getBody() -> Data {
        return self.body
    }
    
    //MARK:-
    private func appendParametersToBody() {
        guard let parameters = self.parameters else { return }
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
    }
    
    private func appendDataTransferEntitiesToBody() {
        for dataTransferEntity in dataTransferEntities {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data")
            
            //RFC 7578: 'multiple files must be sent with the same "name" parameter.'
            if let name = singleFileTransfer ? dataTransferEntity.name : nameForTransferFiles {
                body.append("; name=\"\(name)\"")
            }
            if let fileName = dataTransferEntity.fileName {
                body.append("; filename=\"\(fileName)\"")
            }
            body.append("\r\n")
            body.append("Content-Type: \(dataTransferEntity.contentType.rawValue)")
            body.append("\r\n\r\n")
            body.append(dataTransferEntity.data)
            body.append("\r\n")
        }
        body.append("--\(boundary)--\r\n")
    }
}

private extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`,
    /// this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
