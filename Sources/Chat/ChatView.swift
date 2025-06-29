import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText: String = ""

    var body: some View {
        VStack {
            List(viewModel.messages, id: \ .self) { message in
                Text(message)
            }
            HStack {
                TextField("Message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.send(messageText)
                    messageText = ""
                }
            }.padding()
        }
        .onAppear {
            viewModel.start()
        }
    }
}

#Preview {
    ChatView()
}
