//
//  HomeVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

final class HomeVC: BaseViewController<HomeView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Network.shared.requestConvertible(
            api: .baseSpots(request: RequestTravelSpots(
                serviceKey: APIKey.dataKey,
                MobileOS: "IOS",
                MobileApp: "AppTest",
                _type: "json",
                numOfRows: "10",
                pageNo: "1",
                langCode: "ko")
            ),
            type: ResponseTravelSpots.self) { response in
                switch response {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            }
    }
    
    override func configureVC() {
        
    }
}
