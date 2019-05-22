//
//  SampleTests.swift
//  SampleTests
//
//  Created by Ahmet Akbal on 22.05.19.
//  Copyright © 2019 Ahmet Akbal. All rights reserved.
//

import XCTest
@testable import Sample
import APLNetworkLayer

class JSONData: Codable {
    var dataOne:String
    var dataTwo:String
    var dataThree:String
}

class SampleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodingJsonFromFile1() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
   
        // File exist and is ok
        var result:JSONData? = try? JSONDataDecoder.fromLocalFile(fileName: "json_simple", fileExtension: "json")
        print(result?.dataOne)
        
        // File does not exist
        result = try? JSONDataDecoder.fromLocalFile(fileName: "json_simpl", fileExtension: "json")
     
        
        // File exist and is ok
        result = try? JSONDataDecoder.fromLocalFile(fileName: "json_simple")
        print(result?.dataTwo)
        
        
        // File does not exists
        do {
            result = try JSONDataDecoder.fromLocalFile(fileName: "json_simpl", fileExtension: nil)
        } catch let Error {
            switch Error {
            case JSONDataDecoder.DecoderError.fileNotFound:
                XCTAssertTrue(true)
            case JSONDataDecoder.DecoderError.contentsOfUrlCouldNotBeLoaded:
                XCTAssertTrue(false)
            case JSONDataDecoder.DecoderError.dataCouldNotBeDecoded:
                XCTAssertTrue(false)
            default: XCTAssertTrue(false)
                
            }
        }
        
        
        // File exists but corrupted
        do {
            result = try JSONDataDecoder.fromLocalFile(fileName: "json_simple_corrupted")
        } catch let Error {
            switch Error {
            case JSONDataDecoder.DecoderError.fileNotFound:
                XCTAssertTrue(false)
            case JSONDataDecoder.DecoderError.contentsOfUrlCouldNotBeLoaded:
                XCTAssertTrue(false)
            case JSONDataDecoder.DecoderError.dataCouldNotBeDecoded:
                XCTAssertTrue(true)
            default: XCTAssertTrue(false)
                
            }
        }
        

        // File exist and is ok
        let fileUrl = Bundle.main.url(forResource: "json_simple", withExtension: "json")
        result = try? JSONDataDecoder.fromURL(fileUrl: fileUrl!)
        print(result?.dataTwo)
        
        // cause assertion
        //let url = URL(string: "wwww.apple.com")
        //result = try? JSONDataDecoder.fromURL(fileUrl: url!)
 
        do {
            let _:JSONData = try JSONDataDecoder.fromData(data: Data())!
        } catch let Error {
            print("fehler \(Error)")
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
