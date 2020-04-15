//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import XCTest
import Foundation

@testable import APLFormContentCreation

class ApplicationURLEncodedContentTypeTest: XCTestCase {

    //MARK:- Properties
    //Information of Mocked TextTransferEntity
    let text = "Pablo"
    let textName = "Username"
    
    //Information of Mocked DataTransferEntity
    let data = Data([0x04, 0x02, 0x04, 0x00, 0x00, 0x00])
    let dataName = "Random File"
    let dataFileName = "random.exe"
    
    //Information of Mocked ImageTransferEntity
    lazy var image = self.createMockedImage(with: .white)!
    let imageName = "Image of Color Pink"
    let compressionQuality: CGFloat = 0.5
    
    let expectedContentType = "application/x-www-form-urlencoded"
    
    //MARK:- Creation Functions Of TransferEntities
    private func createDataTransferEntity() -> DataTransferEntity {
        return DataTransferEntity(data: data, contentType: .binary, name: dataName, fileName: dataFileName)
    }
    
    private func createTextTransferEntity() -> TextTransferEntity? {
        return TextTransferEntity(text: text,
                                    name: textName)
    }
    
    private func createPNGImageTransferEntity() -> UIImagePNGFormatTransferEntity? {
        let uiImagePNGFormTransferEntity = UIImagePNGFormatTransferEntity(image: image,
                                                              name: imageName)
        return uiImagePNGFormTransferEntity
    }
    
    private func createJPEGImageTransferEntity() -> UIImageJPEGFormatTransferEntity? {
        let uiImageJPEGFormTransferEntity = UIImageJPEGFormatTransferEntity(image: image,
                                                              name: imageName,
                                                              compressionQuality: compressionQuality)
        return uiImageJPEGFormTransferEntity
    }
    
    //MARK:- Test Content Type
    func testContentTypeValueOfTextTransfer() {
        //Given
        let textTransferEntity = createTextTransferEntity()
        XCTAssertNotNil(textTransferEntity)
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: textTransferEntity!)
        let contentType = applicationURLEncodedContentType
        
        //When
        let contentTypeValue = contentType.getContentTypeValue()
        
        //Then
        XCTAssertEqual(contentTypeValue, expectedContentType)
    }
    
    func testContentTypeValueOfDataTransfer() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: dataTransferEntity)
        let contentType = applicationURLEncodedContentType
        
        //When
        let contentTypeValue = contentType.getContentTypeValue()
        
        //Then
        XCTAssertEqual(contentTypeValue, expectedContentType)
    }
    
    func testContentTypeValueOfImageTransferInJPEGForm() {
        //Given
        let imageJPEGFormTransferEntity = createJPEGImageTransferEntity()
        XCTAssertNotNil(imageJPEGFormTransferEntity)
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: imageJPEGFormTransferEntity!)
        let contentType = applicationURLEncodedContentType
        
        //When
        let contentTypeValue = contentType.getContentTypeValue()
        
        //Then
        XCTAssertEqual(contentTypeValue, expectedContentType)
    }
    
    func testContentTypeValueOfImageTransferInPNGForm() {
        //Given
        let imagePNGFormTransferEntity = createPNGImageTransferEntity()
        XCTAssertNotNil(imagePNGFormTransferEntity)
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: imagePNGFormTransferEntity!)
        let contentType = applicationURLEncodedContentType
        
        //When
        let contentTypeValue = contentType.getContentTypeValue()
        
        //Then
        XCTAssertEqual(contentTypeValue, expectedContentType)
    }
    
    //MARK:- Test Body
    func testBodyOfTextTransfer() {
        //Given
        let textTransferEntity = createTextTransferEntity()
        XCTAssertNotNil(textTransferEntity)
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: textTransferEntity!)
        let expectedBody = "Pablo".data(using: .utf8)
        XCTAssertNotNil(expectedBody)
        
        //When
        let body = applicationURLEncodedContentType.getBody()
        
        //Then
        XCTAssertEqual(expectedBody, body)
    }
    
    func testBodyOfDataTransfer() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: dataTransferEntity)
        let expectedBody = dataTransferEntity.data
        
        //When
        let body = applicationURLEncodedContentType.getBody()
        
        //Then
        XCTAssertEqual(expectedBody, body)
    }
    
    func testBodyOfJPEGImage() {
        //Given
        let imageJPEGFormTransferEntity = createJPEGImageTransferEntity()
        XCTAssertNotNil(imageJPEGFormTransferEntity)
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: imageJPEGFormTransferEntity!)
        
        //When
        let imageData = image.jpegData(compressionQuality: compressionQuality)
        XCTAssertNotNil(imageData)
        let body = applicationURLEncodedContentType.getBody()
        
        //Then
        XCTAssertEqual(imageData, body)
    }
    
    func testBodyOfPNGImage() {
        //Given
        let imagePNGFormTransferEntity = createPNGImageTransferEntity()
        XCTAssertNotNil(imagePNGFormTransferEntity)
        let applicationURLEncodedContentType = ApplicationURLEncodedContentType(dataTransferEntity: imagePNGFormTransferEntity!)
        
        //When
        let imageData = image.pngData()
        XCTAssertNotNil(imageData)
        let body = applicationURLEncodedContentType.getBody()
        
        //Then
        XCTAssertEqual(imageData, body)
    }
    
    //MARK:- Helpers
    func createMockedImage(with color: UIColor) -> UIImage? {
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
