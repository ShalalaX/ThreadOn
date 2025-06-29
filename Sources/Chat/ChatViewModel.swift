import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [String] = []
    private let multipeer = MultipeerManager()

    func start() {
        multipeer.startBrowsing()
        multipeer.onMessageReceived = { [weak self] message in
            DispatchQueue.main.async {
                self?.messages.append(message)
            }
        }
    }

    func send(_ text: String) {
        messages.append(text)
        multipeer.send(text: text)
    }
}
