//
//  StreamingVoice.swift
//  SENSI
//
//  Created by Shahad Bagarish on 24/04/2025.
//

//  This view handles:
//  1. Recording user voice and converting it to text
//  2. Sending the transcribed text to OpenAI's streaming API
//  3. Receiving GPT response in real-time and converting it to speech

import SwiftUI
import Speech
import AVFoundation

//struct StreamingVoice: View {
//    @State private var messages: [ChatMessage] = []
//    @State private var isRecording = false
//    @State private var inputText = ""
//    @State private var responseText = ""
//    @State private var synthesizer = AVSpeechSynthesizer()
//    @State private var audioEngine = AVAudioEngine()
//    @State private var recognitionTask: SFSpeechRecognitionTask?
//    
//    @EnvironmentObject var chatService: ChatServiceViewModel
//    @EnvironmentObject var viewModel: AuthViewModel
//
//    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("🎙 Ask Your Mentor by Voice")
//                .font(.title2).bold()
//
//            Text(responseText)
//                .padding()
//                .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(10)
//
//            Button(action: isRecording ? stopRecording : startRecording) {
//                Label(isRecording ? "Stop Recording" : "Start Talking", systemImage: isRecording ? "stop.circle.fill" : "mic.circle.fill")
//                    .font(.title2)
//            }
//            .padding()
//        }
//        .padding()
//        .onAppear(perform: requestPermissions)
//    }
//
//    func requestPermissions() {
//        SFSpeechRecognizer.requestAuthorization { status in
//            if status != .authorized {
//                print("Speech recognition not authorized")
//            }
//        }
//    }
//
//    func startRecording() {
//        isRecording = true
//        responseText = ""
//
//        let request = SFSpeechAudioBufferRecognitionRequest()
//        let inputNode = audioEngine.inputNode
//        let format = inputNode.outputFormat(forBus: 0)
//
//        inputNode.removeTap(onBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
//            request.append(buffer)
//        }
//
//        audioEngine.prepare()
//        try? audioEngine.start()
//
//        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
//            guard let result = result else { return }
//            if result.isFinal {
//                inputText = result.bestTranscription.formattedString
//                stopRecording()
//                Task {
//                    await sendToMentor(prompt: inputText)
//                }
//            }
//        }
//    }
//
//    func stopRecording() {
//        isRecording = false
//        audioEngine.stop()
//        audioEngine.inputNode.removeTap(onBus: 0)
//        recognitionTask?.cancel()
//    }
//
//    func sendToMentor(prompt: String) async {
//        DispatchQueue.main.async {
//            self.responseText = "Mentor is thinking..."
//        }
//      
//        
//        // Append mentor’s response
//        let mentorResponse = await chatService.getChatResponse(prompt: prompt, userViewModel: viewModel)
//        let mentorMessage = ChatMessage(text: mentorResponse, isUser: false)
//
//        messages.append(mentorMessage)
//        // Build system + user message
//        let userMessage = Message(role: "user", content: prompt)
//        var fullMessages: [Message] = [
//            Message(role: "system", content:
//                    "You are mentor, a professional mentor specializing in career transitions and skill development. Please respond in a friendly and supportive tone."),
//            userMessage
//        ]
//
//        fullMessages.append(contentsOf: chatService.chatHistory)
//
//        guard let request = chatService.requestBuilder.buildRequest(messages: fullMessages, url: URL(string: "https://api.openai.com/v1/chat/completions")) else {
//            print("Failed to build streaming request")
//            return
//        }
//
//        let task = URLSession.shared.streamTask(with: request)
//        task.resume()
//
//        task.readData(ofMinLength: 1, maxLength: Int.max, timeout: 60) { data, _, error in
//            guard let data = data, let streamText = String(data: data, encoding: .utf8) else { return }
//
//            let lines = streamText.split(separator: "\n")
//            for line in lines where line.hasPrefix("data: ") {
//                let jsonString = line.replacingOccurrences(of: "data: ", with: "")
//                if jsonString == "[DONE]" { break }
//
//                if let jsonData = jsonString.data(using: .utf8),
//                   let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
//                   let choices = json["choices"] as? [[String: Any]],
//                   let delta = choices.first?["delta"] as? [String: String],
//                   let content = delta["content"] {
//                    DispatchQueue.main.async {
//                        self.responseText += content
//                        self.speak(text: content)
//                    }
//                }
//            }
//        }
//    }
//
//    func speak(text: String) {
//        let utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        synthesizer.speak(utterance)
//    }
//}
