//
// Created by apploft on 20.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import XCTest
import Foundation

@testable import APLFormContentCreation

class UIImagePNGFormatTransferEntityTest: XCTestCase {
    
    //MARK:- Properties
    lazy var image = self.createMockedImage(with: .systemPink)!
    let imageName = "Image of Color Pink"
    
    //MARK:- Creation Function Of Entity
    private func createImagePNGFormTransferEntity() -> UIImagePNGFormatTransferEntity? {
        return UIImagePNGFormatTransferEntity(image: image,
                                              name: imageName)

    }
    
    //MARK:- Data Tests
    func testImageConversionDataEqual() {
        //Given
        let imagePNGFormTransferEntity = createImagePNGFormTransferEntity()
        XCTAssertNotNil(imagePNGFormTransferEntity)
        
        //When
        let recreatedImageData = image.pngData()
        XCTAssertNotNil(recreatedImageData)
        
        //Then
        XCTAssertEqual(imagePNGFormTransferEntity!.data, recreatedImageData)
    }
    
    func testImageConversionDataNotEqual() {
        //Given
        let imageTransferEntity = createImagePNGFormTransferEntity()
        XCTAssertNotNil(imageTransferEntity)
        let wrongImage = self.createMockedImage(with: .black)
        XCTAssertNotNil(wrongImage)
        
        //When
        let wrongImageData = wrongImage!.pngData()
        XCTAssertNotNil(wrongImageData)
        
        //Then
        XCTAssertNotEqual(imageTransferEntity!.data, wrongImageData)
    }

    //MARK:- Name Tests
    func testNameEqual() {
        //Given
        let imageTransferEntity = createImagePNGFormTransferEntity()
        XCTAssertNotNil(imageTransferEntity)
        let nameOfTransferEntity = imageTransferEntity!.name
        
        //Then
        XCTAssertEqual(nameOfTransferEntity, imageName)
    }
    
    func testNameNotEqual() {
        //Given
        let imageTransferEntity = createImagePNGFormTransferEntity()
        XCTAssertNotNil(imageTransferEntity)
        let nameOfTransferEntity = imageTransferEntity!.name
        let wrongName = "wrong name"
        
        //Then
        XCTAssertNotEqual(nameOfTransferEntity, wrongName)
    }

    //MARK:- Helpers
    private func createMockedImage(with color: UIColor) -> UIImage? {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        return UIImage.init(cgImage: cgImage)
    }
}
