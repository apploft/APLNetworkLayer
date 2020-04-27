//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import XCTest
import Foundation

@testable import APLFormContentCreation

class DataTransferEntityTest: XCTestCase {
    
    //MARK:- Properties
    let data = Data([0x04, 0x02, 0x04, 0x00, 0x00, 0x00])
    let dataName = "Random File"
    let dataFileName = "random.exe"
    
    lazy var dataTransferEntity: DataTransferEntity =
        DataTransferEntity(data: data, contentType: .binary, name: dataName, fileName: dataFileName)
    
    //MARK:- Data Tests
    func testDataEqual() {
        //Given
        let dataOfTransferEntity = dataTransferEntity.data
        
        //Then
        XCTAssertEqual(dataOfTransferEntity, data)
    }
    
    func testFileDataNotEqual() {
        //Given
        let dataOfTransferEntity = dataTransferEntity.data
        let wrongFileData = Data([0x01])
        
        //Then
        XCTAssertNotEqual(dataOfTransferEntity, wrongFileData)
    }

    //MARK:- Name Tests
    func testNameEqual() {
        //Given
        let nameOfTransferEntity = dataTransferEntity.name
        
        //Then
        XCTAssertEqual(nameOfTransferEntity, dataName)
    }
    
    func testNameNotEqual() {
        //Given
        let nameOfTransferEntity = dataTransferEntity.name
        let wrongName = "wrong name"
        
        //Then
        XCTAssertNotEqual(nameOfTransferEntity, wrongName)
    }
    
    //MARK:- FileName Tests
    func testFileNameEqual() {
        //Given
        let fileNameOfTransferEntity = dataTransferEntity.fileName
        
        //Then
        XCTAssertEqual(fileNameOfTransferEntity, dataFileName)
    }
    
    func testFileNameNotEqual() {
        //Given
        let fileNameOfTransferEntity = dataTransferEntity.fileName
        let wrongFileName = "wrong fileName"
        
        //Then
        XCTAssertNotEqual(fileNameOfTransferEntity, wrongFileName)
    }
}
