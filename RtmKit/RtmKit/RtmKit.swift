//
//  RtmKit.swift
//  RtmKit
//
//  Created by clf on 2020/5/13.
//  Copyright © 2020 haoqi. All rights reserved.
//

import UIKit
import AgoraRtmKit



/*
 id:16
 module:4
 type:4
 */

public class BaseMessage {
    public let id: String
    public let senderId: String
    public let time: Int64
    public let isOfflineMessage: Bool
}

public class Message: BaseMessage {
    public let recerverId: String

    public class Text {
        public let text: String
    }
    
    public class Image {
        public let text: String
    }
    
    public class File {
        public let mediaId: String
        public let hash: String
    }
    
    public class Asset {
        public let mediaId: String
        public let hash: String
    }
    
    public enum ContentType: UInt {
        case text = 1
        case raw
        case file
    }
}

public class ChannelMessage: BaseMessage {
    public let channelId: String

    public enum ContentType: UInt {
        case text = 1
        case raw
        case file
    }
}


public class F {
    public let hash: String
    public let fileSize: Int64
    
    
    //jpg jpeg png gif wav mp3 mp4 m4a heif heic pdf zip ts
    public let fileType: Bool
}


public class RtmMessage {
    public let id: String
    public let senderId: String
    public let time: Int64
    public let isOfflineMessage: Bool
    public let isCannelMessage: Bool
    
    //isCannelMessage == true 时，recerverId 为channelId
    public let recerverId: String

    public let body: Data
    public let name: String
    public let mediaId: String
}


//public class RtmMessage {
//    public enum MessageType: UInt {
//        case text = 1
//        case raw
//        case file
//    }
//
//    public let time: Int64
//    public let text: String
//    public let isOfflineMessage: Bool
//
//}


public protocol RtmKitDelegate: class {

}


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
    public let fileRequest: RtmFileRequest
    
    public dynamic private(set) var state: ConnectState {
        didSet(old) {
            print("state changed from:\(old) to:\(self.state)")
        }
    }
    
    public private(set) var account: String
    public private(set) var token: String?

    public init(account: String) {
        self.account = account
        let api = AgoraRtmKit(appId: "f5d079b7a3eb43b28bd4b0914c96b624", delegate: nil)!
        self.api = api
        self.state = .disconnected(.notLogin)
        self.fileRequest = RtmFileRequest(api: api)
        super.init()
        self.api.agoraRtmDelegate = self
    }
    
    //MARK: - call

    public func login(token: String?) {
        self.api.login(byToken: token, user: self.account) { (code) in
            
        }
    }
    public func createChannel(id: String) -> RtmChannel? {
        guard let channel: AgoraRtmChannel = self.api.createChannel(withId: id, delegate: nil) else {
            return nil
        }
        return RtmChannel(kit: self, api: channel)
    }

    
    //MARK: - callbacks
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
        if Thread.isMainThread {
            self.fileRequest.uploading(kit: kit, requestId: requestId, progress: progress)
        } else {
            DispatchQueue.main.async {
                self.fileRequest.uploading(kit: kit, requestId: requestId, progress: progress)
            }
        }
    }
    public func rtmKit(_ kit: AgoraRtmKit, media requestId: Int64, downloadingProgress progress: AgoraRtmMediaOperationProgress) {
        assert(kit == self.api, "")
        if Thread.isMainThread {
            self.fileRequest.downloading(kit: kit, requestId: requestId, progress: progress)
        } else {
            DispatchQueue.main.async {
                self.fileRequest.downloading(kit: kit, requestId: requestId, progress: progress)
            }
        }
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
}

public class MessageManager {
    
    
}

public struct RtmError: Error {
    public var code: Int
    public var message: String
}

public final class RtmFileRequest {
    private let api: AgoraRtmKit
    
    fileprivate init(api: AgoraRtmKit) {
        self.api = api
    }

    public struct FileProgress {
        public var total: Int64
        public var current: Int64
    }
    
    public typealias ProgressClosure = (FileProgress) -> Void
    private var progressMap: [Int64:ProgressClosure] = [:]
    
    private func _upload(filePath: String, progress: ProgressClosure?, queue: DispatchQueue, completion: @escaping (Result<String, RtmError>) -> Void) {
        var requestId: Int64 = 0

        self.api.createFileMessage(byUploading: filePath, withRequest: &requestId) { (rid, fileMessage, code) in
            let result: Result<String, RtmError>
            if .ok == code {
                if let message: AgoraRtmFileMessage = fileMessage {
                    result = .success(message.mediaId)
                } else {
                    result = .failure(RtmError(code: code.rawValue, message: "未知错误"))
                }
            } else {
                result = .failure(RtmError(code: code.rawValue, message: ""))
            }
            DispatchQueue.main.async {
                self.progressMap.removeValue(forKey: rid)
            }
            queue.async {
                completion(result)
            }
        }
        if let p = progress {
            self.progressMap[requestId] = p
        }
    }
    public func upload(filePath: String, progress: ProgressClosure?, queue: DispatchQueue, completion: @escaping (Result<String, RtmError>) -> Void) {
        if Thread.isMainThread {
            self._upload(filePath: filePath, progress: progress, queue: queue, completion: completion)
        } else {
            DispatchQueue.main.async {
                self._upload(filePath: filePath, progress: progress, queue: queue, completion: completion)
            }
        }
    }

    private func _download(mediaId: String, progress: ProgressClosure?, queue: DispatchQueue, completion: @escaping (Result<Data, RtmError>) -> Void) {
        var requestId: Int64 = 0
        self.api.downloadMedia(toMemory: mediaId, withRequest: &requestId) { (rid, data, code) in
            let result: Result<Data, RtmError>
            if .ok == code {
                if let v = data {
                    result = .success(v)
                } else {
                    result = .success(Data())
                }
            } else {
                result = .failure(RtmError(code: code.rawValue, message: ""))
            }
            DispatchQueue.main.async {
                self.progressMap.removeValue(forKey: rid)
            }
            queue.async {
                completion(result)
            }
        }
        if let p = progress {
            self.progressMap[requestId] = p
        }
    }
    private func _download(mediaId: String, to filePath: String, progress: ProgressClosure?, queue: DispatchQueue, completion: @escaping (Result<String, RtmError>) -> Void) {
        
        var requestId: Int64 = 0
        self.api.downloadMedia(mediaId, toFile: filePath, withRequest: &requestId) { (rid, code) in
            let result: Result<String, RtmError>
            if .ok == code {
                result = .success(filePath)
            } else {
                result = .failure(RtmError(code: code.rawValue, message: ""))
            }

            DispatchQueue.main.async {
                self.progressMap.removeValue(forKey: rid)
            }
            queue.async {
                completion(result)
            }
        }
        if let p = progress {
            self.progressMap[requestId] = p
        }
    }
    
    public func download(mediaId: String, progress: ProgressClosure?, queue: DispatchQueue, completion: @escaping (Result<Data, RtmError>) -> Void) {
        
        if Thread.isMainThread {
            self._download(mediaId: mediaId, progress: progress, queue:queue, completion: completion);
        } else {
            DispatchQueue.main.async {
                self._download(mediaId: mediaId, progress: progress, queue:queue, completion: completion);
            }
        }
    }
    public func download(mediaId: String, to filePath: String, progress: ProgressClosure?, queue: DispatchQueue, completion: @escaping (Result<String, RtmError>) -> Void) {
        if Thread.isMainThread {
            self._download(mediaId: mediaId, to: filePath, progress: progress, queue:queue, completion: completion);
        } else {
            DispatchQueue.main.async {
                self._download(mediaId: mediaId, to: filePath, progress: progress, queue:queue, completion: completion);
            }
        }
    }
    
    fileprivate func uploading(kit: AgoraRtmKit, requestId: Int64, progress: AgoraRtmMediaOperationProgress) {
        assert(kit == self.api, "")
        guard let closure: ProgressClosure = self.progressMap[requestId] else {
            return
        }
        let p = FileProgress(total: progress.totalSize, current: progress.currentSize)
        closure(p)
    }
    fileprivate func downloading(kit: AgoraRtmKit, requestId: Int64, progress: AgoraRtmMediaOperationProgress) {
        assert(kit == self.api, "")
        guard let closure: ProgressClosure = self.progressMap[requestId] else {
            return
        }
        let p = FileProgress(total: progress.totalSize, current: progress.currentSize)
        closure(p)
    }
}


public final class RtmChannel: NSObject, AgoraRtmChannelDelegate {
    private let api: AgoraRtmChannel
    private let kit: RtmKit
    fileprivate init(kit: RtmKit, api: AgoraRtmChannel) {
        self.kit = kit
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
