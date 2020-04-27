//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import XCTest
import Foundation

@testable import APLFormContentCreation

class MultipartFormDataContentTypeTest: XCTestCase {
    
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
    
    //MARK:- ContentTypeValue Test
    func testContentTypeValuePrefix() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let multipartFormDataContentType = MultipartFormDataContentType(dataTransferEntity: dataTransferEntity)
        let expectedContentTypeValuePrefix = "multipart/form-data; boundary=Boundary-"
        
        //When
        let contentTypeValue = multipartFormDataContentType.getContentTypeValue()
        
        //Then
        XCTAssertTrue(contentTypeValue.contains(expectedContentTypeValuePrefix))
    }
    
    func testContentTypeValueLength() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let multipartFormDataContentType = MultipartFormDataContentType(dataTransferEntity: dataTransferEntity)
        let expectedContentTypeValuePrefix = "multipart/form-data; boundary=Boundary-"
        let expectedContentTypeValuePrefixLength = expectedContentTypeValuePrefix.count
        let uuidLength = UUID().uuidString.count
        
        //When
        let contentTypeValue = multipartFormDataContentType.getContentTypeValue()
        
        //Then
        XCTAssertEqual(contentTypeValue.count, expectedContentTypeValuePrefixLength + uuidLength)
    }
    
    //MARK:- BoundryCount Tests
    func testBoundryCountForOneTransferEntityAndOneParameter() {
        //Given
        let parameters: [String: String] = ["testKey": "testValue"]
        let dataTransferEntity = createDataTransferEntity()
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntity: dataTransferEntity,
            parameters: parameters)
        let expectedBoundryCount = 4
        let boundryPrefix = "--"
        
        //When
        let boundryCount = self.count(of: boundryPrefix, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(boundryCount)
        
        //Then
        XCTAssertEqual(boundryCount, expectedBoundryCount)
    }
    
    func testBoundryCountForThreeTransferEntitiesAndThreeParameter() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let parameters: [String: String] = ["testKey1": "testValue1",
                                            "testKey2": "testValue2",
                                            "testKey3": "testValue3"]
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntities: [dataTransferEntity,
                                     dataTransferEntity,
                                     dataTransferEntity],
            parameters: parameters)
        
        let expectedBoundryCount = 8
        let boundryPrefix = "--"
        
        //When
        let boundryCount = self.count(of: boundryPrefix, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(boundryCount)
        
        //Then
        XCTAssertEqual(boundryCount, expectedBoundryCount)
    }
    
    //MARK:- Content-DispositionCount Tests
    func testContentDispositionCountForOneTransferEntityAndOneParameter() {
        //Given
        let parameters: [String: String] = ["testKey": "testValue"]
        let dataTransferEntity = createDataTransferEntity()
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntity: dataTransferEntity,
            parameters: parameters)
        let expectedContentDispositionCount = 2
        let contentDispositionPrefix = "Content-Disposition: form-data"
        
        //When
        let contentDispositionCount = self.count(of: contentDispositionPrefix, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(contentDispositionCount)
        
        //Then
        XCTAssertEqual(contentDispositionCount, expectedContentDispositionCount)
    }
    
    func testContentDispositionCountForThreeTransferEntitiesAndThreeParameter() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let parameters: [String: String] = ["testKey1": "testValue1",
                                            "testKey2": "testValue2",
                                            "testKey3": "testValue3"]
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntities: [dataTransferEntity,
                                     dataTransferEntity,
                                     dataTransferEntity],
            parameters: parameters)
        
        let expectedContentDispositionCount = 6
        let contentDispositionPrefix = "Content-Disposition: form-data"
        
        //When
        let contentDispositionCount = self.count(of: contentDispositionPrefix, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(contentDispositionCount)
        
        //Then
        XCTAssertEqual(contentDispositionCount, expectedContentDispositionCount)
    }
    
    //MARK:- Test ContentType
    //Cannot test for images since the body cannot be converted into a string
    func testContentTypeForBinaryData() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntity: dataTransferEntity)
        let expectedContentTypeString = "Content-Type: \(ContentType.binary.rawValue)"
        
        //When
        let dataContainsContentTypeString = self.dataContains(
            substring: expectedContentTypeString, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(dataContainsContentTypeString)
        
        //Then
        XCTAssertTrue(dataContainsContentTypeString!)
    }
    
    func testContentTypeForText() {
        //Given
        let textTransferEntity = createTextTransferEntity()
        XCTAssertNotNil(textTransferEntity)
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntity: textTransferEntity!)
        let expectedContentTypeString = "Content-Type: \(ContentType.text.rawValue)"
        
        //When
        let dataContainsContentTypeString = self.dataContains(
            substring: expectedContentTypeString, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(dataContainsContentTypeString)
        
        //Then
        XCTAssertTrue(dataContainsContentTypeString!)
    }
    
    //MARK:- Test name & fileName
    //Cannot test for images since the body cannot be converted into a string
    func testNameAndFileNameForBinaryData() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntity: dataTransferEntity)
        let expectedNameAndFileNameString = "name=\"\(dataName)\"; filename=\"\(dataFileName)\""
        
        //When
        let dataContainsNameAndFileNameString = self.dataContains(
            substring: expectedNameAndFileNameString, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(dataContainsNameAndFileNameString)
        
        //Then
        XCTAssertTrue(dataContainsNameAndFileNameString!)
    }
    
    func testNameForText() {
        //Given
        let textTransferEntity = createTextTransferEntity()
        XCTAssertNotNil(textTransferEntity)
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntity: textTransferEntity!)
        let expectedNameString = "name=\"\(textName)\""
        
        //When
        let dataContainsNameString = self.dataContains(
            substring: expectedNameString, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(dataContainsNameString)
        
        //Then
        XCTAssertTrue(dataContainsNameString!)
    }
    
    func testEqualNamesForMultipleFiles() {
        //Given
        let dataTransferEntity = createDataTransferEntity()
        let nameForTransferFiles = "data-files"
        let multipartFormDataContentType = MultipartFormDataContentType(
            dataTransferEntities: [dataTransferEntity,
                                     dataTransferEntity,
                                     dataTransferEntity],
            nameForTransferFiles: nameForTransferFiles)
        
        let expectedEqualNames = 3
        
        //When
        let namesCount = self.count(of: nameForTransferFiles, in: multipartFormDataContentType.getBody())
        XCTAssertNotNil(namesCount)
        
        //Then
        XCTAssertEqual(namesCount, expectedEqualNames)
    }
    
    //MARK:- Helpers
    private func count(of substring: String, in data: Data) -> Int? {
        let dataString = String.init(data: data, encoding: .utf8)
        let substringComponentsInDataString = (dataString?.components(separatedBy:substring))
        let substringCount = substringComponentsInDataString == nil ? nil : substringComponentsInDataString!.count - 1
        return substringCount
    }
    
    private func dataContains(substring: String, in data: Data) -> Bool? {
        let dataString = String.init(data: data, encoding: .utf8)
        return dataString?.contains(substring)
    }
    
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
