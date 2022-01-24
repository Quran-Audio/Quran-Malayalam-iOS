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
    
    
    //MARK: Favourites
    func getFavourites() -> [Int] {
        guard let favourites = UserDefaults.standard.object(forKey: "QMFavourites") as? [Int] else {
            return []
        }
        return favourites
    }
    
    func setFavourite(index:Int) {
        var favourites = getFavourites()
        if !favourites.contains(index) {
            favourites.append(index)
            UserDefaults.standard.set(favourites, forKey: "QMFavourites")
        }
    }
    
    func removeFavourite(chapterIndex:Int) {
        var favourites = getFavourites()
        if let index = favourites.firstIndex(of: chapterIndex) {
            favourites.remove(at: index)
        }
        UserDefaults.standard.set(favourites, forKey: "QMFavourites")
    }
    
    func isFavourite(index:Int) -> Bool {
        let favourites = getFavourites()
        return favourites.contains(index) ? true : false
    }
    
    //MARK: Downnloaded
    func getDownloads() -> [Int] {
        guard let downloads = UserDefaults.standard.object(forKey: "QMDownloads") as? [Int] else {
            return []
        }
        return downloads
    }
    
    func setDownloads(index:Int) {
        var downloads = getDownloads()
        if !downloads.contains(index) {
            downloads.append(index)
            UserDefaults.standard.set(downloads, forKey: "QMDownloads")
        }
    }
    
    func isDownloaded(index:Int) -> Bool {
        let downloads = getDownloads()
        return downloads.contains(index) ? true : false
    }
    
    func deleteDownloaded(chapter:ChapterModel) {
        var downloads = getDownloads()
        if let index = downloads.firstIndex(of: chapter.index) {
            deleteFile(chapter: chapter)
            downloads.remove(at: index)
        }
        UserDefaults.standard.set(downloads, forKey: "QMDownloads")
    }
    
    
    private func deleteFile(chapter:ChapterModel) {
        do {
            let directory = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let localUrl = directory
                .appendingPathComponent(chapter.fileName)
            if FileManager.default.fileExists(atPath: localUrl.path) {
                try FileManager.default.removeItem(atPath: localUrl.path)
            }
        }catch {
            print("Error \(error)")
        }
    }
}
