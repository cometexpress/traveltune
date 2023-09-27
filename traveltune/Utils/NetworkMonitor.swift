//
//  NetworkMonitor.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private init() { }
    private let monitor = NWPathMonitor()
    
    var isConnected = false
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func checkNetwork(successHandler:() -> Void, failHandler: () -> Void) {
        print("네트워크 연결상태 = \(isConnected)")
        switch isConnected {
        case true: successHandler()
        case false: failHandler()
        }
    }
}
