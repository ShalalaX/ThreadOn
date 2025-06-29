import Foundation
import MultipeerConnectivity
import AVFoundation

class MultipeerManager: NSObject {
    private let serviceType = "threadon-chat"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!

    var onMessageReceived: ((String) -> Void)?
    var audioStream: AVAudioPlayerNode?
    private var audioEngine: AVAudioEngine?

    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }

    func startBrowsing() {
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        advertiser.delegate = self
        browser.delegate = self
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }

    func send(text: String) {
        if session.connectedPeers.count > 0 {
            if let data = text.data(using: .utf8) {
                try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
        }
    }

    func startAudioStreaming() {
        audioEngine = AVAudioEngine()
        audioStream = AVAudioPlayerNode()
        guard let audioStream = audioStream, let audioEngine = audioEngine else { return }

        audioEngine.attach(audioStream)
        let mixer = audioEngine.mainMixerNode
        audioEngine.connect(audioStream, to: mixer, format: mixer.outputFormat(forBus: 0))

        try? audioEngine.start()
    }

    func send(audio data: Data) {
        if session.connectedPeers.count > 0 {
            try? session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        }
    }
}

extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            onMessageReceived?(message)
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}
