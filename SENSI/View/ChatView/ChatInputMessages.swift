//
//  ChatInputMessages.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/03/2025.
//

import SwiftUI
import Speech
import AVFoundation

struct ChatInputMessages: View {
    @Binding var inputText: String
    @Binding var isLoading: Bool
    @Binding var isRecording: Bool
    @Binding var responseText: String
    
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    var sendMessage: () async -> Void

    var body: some View {
        HStack {
            HStack{
                TextField("Type a message...", text: $inputText, axis: .vertical)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .lineLimit(5)
                
                Spacer()
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                
//                MicButton(isRecording: isRecording, action: isRecording ? stopRecording : startRecording)
                
                
                
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 10)
            
            HStack{
                
                AsyncButton {
                    await sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(isLoading ? Color.gray : .accent)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                }
            }
        }
        .padding()
    }
    
    func startRecording() {
        print("Recording function triggered")

        // Stop any previous session
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionTask?.cancel()
        }

        isRecording = true
        inputText = ""

        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")),
              recognizer.isAvailable else {
            print("Speech recognizer not available")
            return
        }

        // Setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error)")
            return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
            return
        }

        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
            }

            guard let result = result else {
                print("No result returned")
                return
            }

            if result.isFinal {
                DispatchQueue.main.async {
                    inputText = result.bestTranscription.formattedString
                    stopRecording()
                    print("DEBUG: \(inputText)")
                }
            }
        }
    }



    func stopRecording() {
        print("stop recording")
        isRecording = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
}
