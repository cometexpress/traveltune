//
//  Constant.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import Foundation

struct Constant {

    static let productName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    
    static let storeId = "6469851530"
    
    static var appVersion: String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
//    static var storeVersion: String {
//        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(Constant.storeId)") else { return "" }
//        let (data, response) = try await URLSession.shared.data(from: url)
//    }
    
    static func getStoreVersion() async throws -> String {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(Constant.storeId)") else { return "" }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
              let result = (json["results"] as? [Any])?.first as? [String: Any],
              let version = result["version"] as? String else {
            return ""
        }
        return version
    }
    
//    static func fetchStoreVersion(with url: URL) async throws -> String? {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
//                let results = json["results"] as? [[String: Any]],
//                let appStoreVersion = results[0]["version"] as? String else {
////                DispatchQueue.main.async {
////                    completion(error?.localizedDescription ?? "")
////                }
//                return ""
//            }
//            
//            DispatchQueue.main.async {
//                completion(appStoreVersion)
//            }
//        }.resume()
//    }
    
    struct HeroID {
        static let themeThumnail = "themeThumnail"
        static let themeOpacity = "themeOpacity"
    }
    
    struct Fonts {
        static let logo = "Pavelt"
    }
    
}
