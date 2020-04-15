//
// Created by apploft on 07.04.20.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/
//

import XCTest
import Foundation

@testable import APLFormContentCreation

class TextTransferEntityTest: XCTestCase {
    
    //MARK:- Properties
    let text = "This is a test."
    
    //MARK:- Data Tests
    func testTextConversionIntoDataEqual() {
        //Given
        let textTransferEntity = TextTransferEntity(text: text, encoding: .utf8)
        XCTAssertNotNil(textTransferEntity)
        let textDataOfTransferEntity = textTransferEntity!.data
        
        //When
        let recreatedTextData = text.data(using: .utf8)
        XCTAssertNotNil(recreatedTextData)
        
        //Then
        XCTAssertEqual(textDataOfTransferEntity, recreatedTextData)
    }
    
    func testTextConversionIntoDataNotEqual() {
        //Given
        let textTransferEntity = TextTransferEntity(text: text, encoding: .utf8)
        XCTAssertNotNil(textTransferEntity)
        let textDataOfTransferEntity = textTransferEntity!.data
        let wrongText = "Wrong Text"
        
        //When
        let wrongTextData = wrongText.data(using: .utf8)
        XCTAssertNotNil(wrongTextData)
        
        //Then
        XCTAssertNotEqual(textDataOfTransferEntity, wrongTextData)
    }
}
