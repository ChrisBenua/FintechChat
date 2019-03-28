//
//  Communicator.swift
//  FintechChat
//
//  Created by Ирина Улитина on 15/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Communicator {
    
    func sendMessage(message: String, to userID: String, completionHandler: ((_ success: Bool, _ error : Error?) -> ())?)
    
    var delegate: CommunicatorDelegate? { get set }
    
    var online: Bool { get set }
}


protocol CommunicatorDelegate : class {
    //discovering
    func didFoundUser(userID: String, username: String?)
    
    func didLostUser(userID: String)
    
    //errors
    
    func failedToStartBrowsingForUsers(error: Error)
    
    func failedToStartAdvertising(error: Error)
    
    //messages
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
}


class MultipeerCommunicator: NSObject, Communicator {
    
    func sendMessage(message: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        
        let message = CodableMessage(text: message)
        Logger.log(sessions.connectedPeers.debugDescription)
        do {
            if let session = allSessions[userID] {
                try session.send(try JSONEncoder().encode(message), toPeers: session.connectedPeers, with: .reliable)
            }
            
            completionHandler?(true, nil)
        } catch let err {
            completionHandler?(false, err)
        }
        
        self.delegate?.didReceiveMessage(text: message.text, fromUser: self.userPeerID.displayName, toUser: userID)
    }
    
    func connectWithUser(username: String) {
        /*let neededPeer = currentPeers.filter({$0.displayName == username})
        if (neededPeer.count > 0) {
            browser.invitePeer(neededPeer.first!, to: sessions, withContext: nil, timeout: TimeInterval(exactly: 10) ?? TimeInterval())
            
        }*/
        let neededPeer = currentPeers.filter({$0.displayName == username})
        if let session = self.allSessions[username], neededPeer.count > 0 {
            browser.invitePeer(neededPeer.first!, to: session, withContext: nil, timeout: TimeInterval(exactly: 10) ?? TimeInterval())
        }
    }
    
    func disconnectWithUser(username: String) {
        Logger.log(self.sessions.connectedPeers.debugDescription)
        //self.sessions.disconnect()
        
        Logger.log(self.sessions.connectedPeers.debugDescription)
        
    }
    
    weak var onDisconnectDelegate: OnUserDisconnectedDelegate?
    
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    var lastState: MCSessionState = MCSessionState.notConnected
    
    weak var delegate: CommunicatorDelegate?
    
    var online: Bool = false
    
    var username: String
    
    var userPeerID: MCPeerID
    
    var currentPeers: [MCPeerID] = []
    
    var sessions: MCSession
    
    var browser: MCNearbyServiceBrowser
    
    var advertiser: MCNearbyServiceAdvertiser
    
     var allSessions: [String: MCSession] = [String: MCSession]()
    
    func didEnterConversation() {
        self.advertiser.stopAdvertisingPeer()
    }
    
    func didLeaveConversation() {
        self.advertiser.startAdvertisingPeer()
    }
    
    func reinitAdvertiser(newUserName: String) {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
        self.username = newUserName
        self.userPeerID = MCPeerID(displayName: UIDevice.current.name)
        self.sessions = MCSession(peer: self.userPeerID)

        
        self.advertiser = MCNearbyServiceAdvertiser(peer: userPeerID, discoveryInfo: ["userName": self.username], serviceType: "tinkoff-chat")
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
        
        self.browser = MCNearbyServiceBrowser(peer: userPeerID,
                                              serviceType: "tinkoff-chat")
        self.browser.startBrowsingForPeers()
        
       // mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "tinkoff-chat", discoveryInfo: ["userName": self.username], session: sessions)
        //mcAdvertiserAssistant.start()
        
    }
    
    init(username: String) {
        online = true
        
        self.username = username
        self.userPeerID = MCPeerID(displayName: UIDevice.current.name)
        
        Logger.log("MY PEER \(userPeerID.displayName)")
        self.sessions = MCSession(peer: self.userPeerID)
        self.browser = MCNearbyServiceBrowser(peer: userPeerID,
                                    serviceType: "tinkoff-chat")
        self.advertiser = MCNearbyServiceAdvertiser(peer: userPeerID, discoveryInfo: ["userName": self.username], serviceType: "tinkoff-chat")
        
        super.init()

        self.advertiser.delegate = self
        self.browser.delegate = self
        self.sessions.delegate = self
        
        
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
        //mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "tinkoff-chat", discoveryInfo: ["userName": self.username], session: sessions)
        //mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "tinkoff-chat", discoveryInfo: ["userName": self.username], session: sessions)
        //mcAdvertiserAssistant.start()
    }
}


extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        Logger.log("Received invitation from \(peerID)")
        if (!self.sessions.connectedPeers.contains(peerID) && self.sessions.connectedPeers.count < 1) {
            invitationHandler(true, self.sessions)
        } else {
            invitationHandler(false, nil)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        self.delegate?.failedToStartAdvertising(error: error)
    }
}



extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        self.delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        self.currentPeers.append(peerID)
        
        let displayName = peerID.displayName
        
        if allSessions[displayName] == nil {
            let session = MCSession(peer: userPeerID)
            session.delegate = self
            
            self.allSessions[displayName] = session
        }
        
        
        self.delegate?.didFoundUser(userID: peerID.displayName, username: info!["userName"])
        //self.delegate?.failedToStartBrowsingForUsers(error: NSError(domain: "shit", code: 1, userInfo: nil))

    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate?.didLostUser(userID: peerID.displayName)
        self.allSessions[peerID.displayName]?.disconnect()
        //onDisconnectDelegate?.userDidDisconnected(state: state)
        self.currentPeers.removeAll(where: {$0 == peerID})
    }
    
    
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        self.lastState = state
        
        if (state == .connected) {
            //Logger.log("Connected " + self.sessions.connectedPeers.first!.debugDescription)
        }
        if (state == .notConnected) {
            Logger.log("DisconnectedPeer")
        }
        onDisconnectDelegate?.userDidDisconnected(state: state)

        Logger.log("All Connected Peers: \(session.connectedPeers.count)")

    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        Logger.log("Did receive data from \(peerID.displayName)")
        do {
            let message = try JSONDecoder().decode(CodableMessage.self, from: data)
            self.delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: userPeerID.displayName)
        } catch let err {
            Logger.log(err.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        Logger.log("Did receive stream from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        Logger.log("Did start receiving resource \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        Logger.log("did finish receiving resource \(peerID.displayName)")
    }
    
    
}
