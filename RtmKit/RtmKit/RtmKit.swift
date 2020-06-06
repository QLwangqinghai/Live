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
    public let fileManager: RtmFileManager
    
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
        self.fileManager = RtmFileManager(api: api)
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
}


public final class RtmFile: NSObject {
    public let digest: String
    
    public var type: Int?
    public var width: Int?
    public var height: Int?
    public var duration: Double?
    
    public init(digest: String) {
        self.digest = digest
    }
    
//    public func create
    
    
    /*
     et://expiration time

     file: {
     hx: hash
     tp: type
     w:
     h:
     d: duration
     }
     */
}



public final class RtmFileManager: NSObject {
    
    private let api: AgoraRtmKit
    
    fileprivate init(api: AgoraRtmKit) {
        self.api = api
    }
    
//    public func create
    
    
    //MARK: - call
    
//
//    - (void)createFileMessageByUploading:(NSString * _Nonnull)filePath
//                      withRequest: (long long*)requestId
//                      completion:(AgoraRtmUploadFileMediaBlock _Nullable)completionBlock;
//
//    /**
//     Gets an AgoraRtmImageMessage instance by uploading an image to the Agora server.
//
//     The SDK returns the result by the [AgoraRtmUploadImageMediaBlock](AgoraRtmUploadImageMediaBlock) callback. If success, this callback returns a corresponding AgoraRtmMessage instance, and then you can downcast it to AgoraRtmImageMessage according to its type.
//
//     - If the uploaded image is in JPEG, JPG, BMP, or PNG format, the SDK calculates the width and height of the image. You can get the calculated width and height from the received AgoraRtmImageMessage instance.
//     - Otherwise, you need to set the width and height of the uploaded image within the received AgoraRtmImageMessage instance by yourself.
//
//     **NOTE**
//
//     - If you have at hand the media ID of an image on the Agora server, you can call [createImageMessageByMediaId]([AgoraRtmKit createImageMessageByMediaId:]) to create an AgoraRtmImageMessage instance.
//     - To cancel an ongoing upload task, call [cancelMediaUpload]([AgoraRtmKit cancelMediaUpload:completion:]).
//
//     @param filePath The full path to the local image to upload. Must be in UTF-8.
//     @param requestId The unique ID of the upload request.
//     @param completionBlock [AgoraRtmUploadImageMediaBlock](AgoraRtmUploadImageMediaBlock) returns the result of this method call. See AgoraRtmUploadMediaErrorCode for the error codes.
//     */
//    - (void)createImageMessageByUploading:(NSString * _Nonnull)filePath
//                      withRequest: (long long*)requestId
//                      completion:(AgoraRtmUploadImageMediaBlock _Nullable)completionBlock;

    /*
     et://expiration time

     att: {
     hx: hash
     tp: type
     w:
     h:
     d: duration
     }
     */
    

    public typealias ProgressClosure = (Progress) -> Void
    
    private var progressMap: [Int64:ProgressClosure] = [:]

    
    private func _upload(filePath: String, progress: ProgressClosure?, completion: @escaping (String) -> Void) {
        var requestId: Int64 = 0

        self.api.createFileMessage(byUploading: filePath, withRequest: &requestId) { (requestId, fileMessage, code) in
            print("\(code)")
        }
    }
    public func upload(filePath: String, progress: ProgressClosure?, completion: @escaping (String) -> Void) {
        if Thread.isMainThread {
            self._upload(filePath: filePath, progress: progress, completion: completion)
        } else {
            DispatchQueue.main.async {
                self._upload(filePath: filePath, progress: progress, completion: completion)
            }
        }
    }
    
    public func download(mediaId: String, progress: ProgressClosure?, completion: @escaping (Data) -> Void) {
        
        
    }
    public func download(mediaId: String, to filePath: String, progress: ProgressClosure?, completion: @escaping (Data) -> Void) {
                
    }
    
    
    fileprivate func uploading(kit: AgoraRtmKit, requestId: Int64, progress: AgoraRtmMediaOperationProgress) {
        assert(kit == self.api, "")

    }
    fileprivate func downloading(kit: AgoraRtmKit, requestId: Int64, progress: AgoraRtmMediaOperationProgress) {
        assert(kit == self.api, "")

    }
    
}

public final class RtmFileCache: NSObject {
    private override init() {
        super.init()
    }

    public func file(for identifier: String) -> RtmFile? {
        return nil
    }
    
    public static let shared: RtmFileCache = RtmFileCache()
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
