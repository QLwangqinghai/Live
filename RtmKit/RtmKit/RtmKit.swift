//
//  RtmKit.swift
//  RtmKit
//
//  Created by clf on 2020/5/13.
//  Copyright © 2020 haoqi. All rights reserved.
//

import UIKit
import AgoraRtmKit

public final class RtmKit: NSObject, AgoraRtmDelegate {
    public enum DisconnectedReason {
        case notLogin
        case loginFailure
        case loginTimeout
        case bannedByServer
        case remoteLogin
        case other
    }
    
    public enum ConnectState {
        case connecting
        case connected
        case reconnecting
        case disconnected(_ reason: DisconnectedReason)
    }
    
    private let api: AgoraRtmKit
    public dynamic private(set) var state: ConnectState
    public override init() {
        let api = AgoraRtmKit(appId: "f5d079b7a3eb43b28bd4b0914c96b624", delegate: nil)!
        self.api = api
        self.state = .disconnected(.notLogin)
        super.init()
        self.api.agoraRtmDelegate = self
    }
    
    public func rtmKit(_ kit: AgoraRtmKit, peersOnlineStatusChanged onlineStatus: [AgoraRtmPeerOnlineStatus]) {
        
    }

    public func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        
    }
    public func rtmKit(_ kit: AgoraRtmKit, fileMessageReceived message: AgoraRtmFileMessage, fromPeer peerId: String) {
        
    }
    public func rtmKit(_ kit: AgoraRtmKit, imageMessageReceived message: AgoraRtmImageMessage, fromPeer peerId: String) {
        assert(kit == self.api, "")
        
    }
    public func rtmKit(_ kit: AgoraRtmKit, media requestId: Int64, uploadingProgress progress: AgoraRtmMediaOperationProgress) {
        assert(kit == self.api, "")

    }
    public func rtmKit(_ kit: AgoraRtmKit, media requestId: Int64, downloadingProgress progress: AgoraRtmMediaOperationProgress) {
        assert(kit == self.api, "")

    }
    public func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        assert(kit == self.api, "")
        
        func mapReason(_ reason: AgoraRtmConnectionChangeReason) -> DisconnectedReason {
            let r: DisconnectedReason
            switch reason {
            case .bannedByServer:
                r = .bannedByServer
                break;
            case .interrupted:
                r = .other
                break;
            case .login:
                r = .other
                break;
            case .loginFailure:
                r = .loginFailure
                break;
            case .loginSuccess:
                r = .other
                break;
            case .loginTimeout:
                r = .loginTimeout
                break;
            case .logout:
                r = .notLogin
                break;
            case .remoteLogin:
                r = .remoteLogin
                break;
            default:
                r = .other
                break;
            }
            return r
        }
        
        let s: ConnectState
        switch state {
        case .disconnected:
            s = .disconnected(mapReason(reason))
            break;
        case .aborted:
            s = .disconnected(mapReason(reason))
            break;
        case .connected:
            s = .connected
            break;
        case .connecting:
            s = .connecting
            break;
        case .reconnecting:
            s = .reconnecting
            break;
        default:
            s = .disconnected(.other)
            break;
        }
        self.state = s
    }
    public func rtmKitTokenDidExpire(_ kit: AgoraRtmKit) {
        assert(kit == self.api, "")

    }
    
    public final class Channel: NSObject, AgoraRtmChannelDelegate {
        private let api: AgoraRtmChannel
        
        public init(api: AgoraRtmChannel) {
            self.api = api
            super.init()
            self.api.channelDelegate = self
        }
        
        public func channel(_ channel: AgoraRtmChannel, memberCount count: Int32) {
            
        }
        public func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
            
        }
        public func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
            
        }
        
        public func channel(_ channel: AgoraRtmChannel, attributeUpdate attributes: [AgoraRtmChannelAttribute]) {
            
        }
        
        public func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
            
        }
        public func channel(_ channel: AgoraRtmChannel, fileMessageReceived message: AgoraRtmFileMessage, from member: AgoraRtmMember) {
            
        }
        public func channel(_ channel: AgoraRtmChannel, imageMessageReceived message: AgoraRtmImageMessage, from member: AgoraRtmMember) {
            
        }
    }

    
    
}
