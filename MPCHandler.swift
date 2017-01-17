//
//  MPCHandler.swift
//  Lernquiz
//
//  Created by Lisa Lohner on 17.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//
import MultipeerConnectivity
import UIKit

class MPCHandler: NSObject, MCSessionDelegate {
    
    var peerID:MCPeerID!
    var session:MCSession!
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    
    func setupPeerWithDisplayName (displayName:String){
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "my-game", session: session)
    }
    
    func advertiseSelf(advertise:Bool){
        if advertise{
            adverstiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser!.start()
        }else{
            advertiser!.stop()
            advertiser = nil
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerID, "state":state.toRaw()]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
    NSNotificationCenter.defaultCenter().postNotificationName("MPC_DidChangeStateNotification", object: nil, userInfo: userInfo)
        })
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data":data, "peerID":peerID]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
    NSNotificationCenter.defaultCenter().postNotificationName("MPC_DidReceiveDataNotification", object: nil, userInfo: userInfo)
        })
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        <#code#>
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        <#code#>
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
}
