//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 31/01/2024.
//

import Foundation
import Network

public enum NetworkStatus: String {
    case connected
    case disconnected
}

public enum NetworkType: String {
    case wifi
    case cellular
    case wiredEthernet
    case other
}


@Observable
public class NetworkManager {
    public var isMonitering = true
    public var status: NetworkStatus = .disconnected
    public var pathStatus = NWPath.Status.requiresConnection
    public var isConnected = false
    
    var monitor: NWPathMonitor?
    
    public var networkType: NetworkType? {
        guard let monitor = monitor else { return nil }
        let type = monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type)
        }.first?.type
        return getNetworkType(interfaceType: type)
    }
    
    private var isStatusSatisfied: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    private var availableNetworkTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    public init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    public func startMonitoring() {
        guard !isMonitering else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkStatus_Monitor")
        monitor?.start(queue: queue)
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if self.pathStatus != path.status {
                    self.pathStatus = path.status
                    self.status = self.pathStatus == .satisfied ? .connected : .disconnected
                    self.isConnected = self.status == .connected ? true : false
                }
            }
        }
        isMonitering = true
    }
    
    public func stopMonitoring() {
        guard isMonitering, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitering = false
    }
    
    private func getNetworkType(interfaceType: NWInterface.InterfaceType?) -> NetworkType {
        switch interfaceType {
        case .wifi:
            return .wifi
        case .cellular:
            return .cellular
        case .wiredEthernet:
            return .wiredEthernet
        default:
            return .other
        }
    }
}
