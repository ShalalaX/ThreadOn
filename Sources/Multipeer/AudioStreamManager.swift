import Foundation
import AVFoundation

class AudioStreamManager {
    private let audioEngine = AVAudioEngine()
    private let inputNode: AVAudioInputNode
    private let session = AVAudioSession.sharedInstance()

    var onData: ((Data) -> Void)?

    init() {
        inputNode = audioEngine.inputNode
    }

    func start() throws {
        try session.setCategory(.playAndRecord, options: [.allowBluetooth])
        try session.setActive(true)

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, time in
            if let data = buffer.toData() {
                self.onData?(data)
            }
        }
        audioEngine.prepare()
        try audioEngine.start()
    }

    func stop() {
        inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
}

private extension AVAudioPCMBuffer {
    func toData() -> Data? {
        let audioBuffer = self.audioBufferList.pointee.mBuffers
        guard let mData = audioBuffer.mData else { return nil }
        let bufferPointer = mData.bindMemory(to: UInt8.self, capacity: Int(audioBuffer.mDataByteSize))
        return Data(bytes: bufferPointer, count: Int(audioBuffer.mDataByteSize))
    }
}
