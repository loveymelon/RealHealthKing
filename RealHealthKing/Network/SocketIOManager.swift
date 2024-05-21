//
//  SocketIOManager.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/21/24.
//

import Foundation
import SocketIO

class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    let baseURL = APIKey.baseURL.rawValue
    
    private init() { }
    
}

extension SocketIOManager {
    func startNetwork(roomId: String, completionHandler: @escaping (ChatRoomsModel) -> Void) {
        
        manager = SocketManager(socketURL: URL(string: baseURL) ?? URL(fileURLWithPath: ""), config: [.log(true), .compress])
        
        socket = manager.socket(forNamespace: roomId)
        
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected", data, ack)
        } // connect될때 신호
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected", data, ack)
        }// 연결이 끊길때 신호
        
        // [Any] > Data > Struct
        socket.on("chat") { dataArray, ack in
            print("chat received", dataArray, ack)
            
            if let data = dataArray.first {
                
                do {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    
                    let decodedData = try JSONDecoder().decode(ChatRoomsModel.self, from: result)
                    
                    completionHandler(decodedData)
                    
                } catch {
                    print(error)
                }
                
            }
        }
    }
}
