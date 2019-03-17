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
        
        let message = Message(text: message)
        print(sessions.connectedPeers)
        do {
            try self.sessions.send(try JSONEncoder().encode(message), toPeers: sessions.connectedPeers, with: .reliable)
            
            completionHandler?(true, nil)
        } catch let err {
            completionHandler?(false, err)
        }
        
        self.delegate?.didReceiveMessage(text: message.text, fromUser: username, toUser: userID)
    }
    
    func connectWithUser(username: String) {
        let neededPeer = currentPeers.filter({$0.displayName == username})
        if (neededPeer.count > 0) {
            browser.invitePeer(neededPeer.first!, to: sessions, withContext: nil, timeout: TimeInterval(exactly: 10) ?? TimeInterval())
            
        }
    }
    
    func disconnectWithUser(username: String) {
        let neededPeer = currentPeers.filter({$0.displayName == username})
        if (neededPeer.count > 0) {
            self.sessions.disconnect()
        }
    }
    
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    weak var delegate: CommunicatorDelegate?
    
    var online: Bool = false
    
    var username: String
    
    var userPeerID: MCPeerID
    
    var currentPeers: [MCPeerID] = []
    
    var sessions: MCSession
    
    var browser: MCNearbyServiceBrowser
    
    var advertiser: MCNearbyServiceAdvertiser
    
    init(username: String) {
        online = true
        
        self.username = username
        self.userPeerID = MCPeerID(displayName: self.username)
        
        print("MY PEER \(userPeerID.displayName)")
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
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "tinkoff-chat", discoveryInfo: ["userName": self.username], session: sessions)
        mcAdvertiserAssistant.start()
    }
}


extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from \(peerID)")
        if (self.sessions.connectedPeers.count == 0) {
            invitationHandler(true, self.sessions)
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
        
        self.delegate?.didFoundUser(userID: peerID.displayName, username: info!["userName"])
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate?.didLostUser(userID: peerID.displayName)
        self.currentPeers.removeAll(where: {$0 == peerID})
    }
    
    
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if (state == .connected) {
            print(self.sessions.connectedPeers.count)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Did receive data from \(peerID.displayName)")
        do {
            let message = try JSONDecoder().decode(Message.self, from: data)
            self.delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: userPeerID.displayName)
        } catch let err {
            print(err)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Did receive stream from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Did start receiving resource \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("did finish receiving resource \(peerID.displayName)")
    }
    
    
}
