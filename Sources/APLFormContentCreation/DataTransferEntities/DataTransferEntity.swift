//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/// Content types are used in multipart/form-data requests. Each DataTransferEntity needs a content type to properly
///  generate the body of the request.
public enum ContentType: String {
    case binary = "application/octet-stream"
    case text = "text/plain"
    case css = "text/css"
    case html = "text/html"
    case javaScript = "text/javascript"
    case imagePNG = "image/png"
    case imageJPEG = "image/jpeg"
    case imageGIF = "image/gif"
    case imageSVG = "image/svg+xml"
    case audioMP3 = "audio/mpeg"
    case videoMP4 = "video/mp4"
}

/// A class for storing data and its associated propoperties like its content type. This class can be used as a data structure
/// when creating multipart/form-data or application/x-www-form-urlencoded requests.
public class DataTransferEntity {
    
    //MARK:- Properties
    /// The data object which will be transmitted.
    public var data: Data
    /// The content type of the stored data object.
    public var contentType: ContentType
    /// The name indicating what the stored data contains.
    public var name: String?
    /// The filename of the stored data.
    public var fileName: String?
    
    //MARK:- Init
    /**
     Creates a DataTransferEntity with the given parameters.
     
     - Parameter data: The data object which will be transmitted. Mandatory parameter.
     - Parameter contentType: The content type of the data. Mandatory parameter.
     - Parameter name: The name indicating what the data contains. Default value is nil.
     - Parameter fileName: The filename of the data. Default value is nil.
     */
    public init(data: Data, contentType: ContentType,
                name: String? = nil, fileName: String? = nil) {
        self.data = data
        self.contentType = contentType
        self.name = name
        self.fileName = fileName
    }
}
