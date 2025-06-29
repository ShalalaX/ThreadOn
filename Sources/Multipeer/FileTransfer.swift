import Foundation
import MultipeerConnectivity

extension MultipeerManager {
    func send(url: URL) {
        if session.connectedPeers.count > 0 {
            session.sendResource(at: url, withName: url.lastPathComponent, toPeer: session.connectedPeers[0]) { error in
                if let error = error {
                    print("Error sending resource: \(error)")
                }
            }
        }
    }
}
