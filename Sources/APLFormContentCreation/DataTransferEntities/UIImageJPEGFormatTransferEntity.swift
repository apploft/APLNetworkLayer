//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// A wrapper class for storing an image in JPEG Format as Data. It inherites DataTransferEntity and therefore can be
/// used as a data structure when creating a multipart/form-data requests. It should not be used for
/// application/x-www-form-urlencoded request, since images are too big of a payload.
public class UIImageJPEGFormatTransferEntity: DataTransferEntity {
    
    //MARK:- Properties
    /// The UIImage form of the image.
    public var image: UIImage
    
    //MARK:- Init
    /**
     Creates a UIImageJPEGFormatTransferEntity with the given parameters.
     
     - Parameter image: The UIImage object, which is converted into the to be transfered data. Mandatory parameter.
     - Parameter name: The name indicating what the image contains. Default value is nil.
     - Parameter fileName: The filename of the image Object. Default value is nil.
     - Parameter compressionQuality: The compression quality is the quality of the resulting image after the conversion of the UIImage. It is expressed
     as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while
     the value 1.0 represents the least compression (or best quality). Default value is 0.5.
     */
    public init?(image: UIImage, name: String? = nil, fileName: String? = nil,
                 compressionQuality: CGFloat = 0.5) {
        self.image = image
        
        let imageData: Data? = image.jpegData(compressionQuality: compressionQuality)
        
        guard let data = imageData else { return nil }

        super.init(data: data, contentType: .imageJPEG,
                   name: name, fileName: fileName)
    }
}
