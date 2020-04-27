//
// Created by apploft on 20.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// A wrapper class for storing an image in PNG form as Data. It inherites DataTransferEntity and therefore can be
/// used as a data structure when creating a multipart/form-data requests. It should not be used for
/// application/x-www-form-urlencoded request, since images are too big of a payload.
public class UIImagePNGFormatTransferEntity: DataTransferEntity {
    
    //MARK:- Properties
    /// The UIImage form of the image.
    public var image: UIImage
    
    //MARK:- Init
    /**
     Creates a UIImagePNGFormatTransferEntity with the given parameters.
     
     - Parameter image: The UIImage object, which is converted into the to be transfered data. Mandatory parameter.
     - Parameter name: The name indicating what the image contains. Default value is nil.
     - Parameter fileName: The filename of the image Object. Default value is nil.
     */
    public init?(image: UIImage, name: String? = nil, fileName: String? = nil) {
        self.image = image
        let imageData: Data? = image.pngData()
        
        guard let data = imageData else { return nil }

        super.init(data: data, contentType: .imagePNG,
                   name: name, fileName: fileName)
    }
}
