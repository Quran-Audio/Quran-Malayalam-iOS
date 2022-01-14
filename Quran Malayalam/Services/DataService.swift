//
//  DataService.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 14/01/22.
//

import Foundation

class DataService {
    static var shared = DataService()
    private init() {}
    
    func loadData() -> DataModel? {
        guard let path = Bundle.main.path(forResource: "Data", ofType: "json") else {
            print("Invalid file")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let chapterMetaData = try decoder.decode(DataModel.self, from: data)
            return chapterMetaData
        } catch DecodingError.keyNotFound(let key, let context) {
            Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        return nil
    }
}
