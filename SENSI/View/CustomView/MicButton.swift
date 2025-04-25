//
//  MicButton.swift
//  SENSI
//
//  Created by Shahad Bagarish on 15/04/2025.
//

import SwiftUI
import Speech
import AVFoundation

struct MicButton: View {
    
    @State private var inputText = ""
    @State private var responseText = ""
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    
    var isRecording: Bool
    var action: () -> Void
    
    @EnvironmentObject var chatService: ChatServiceViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    
//    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    var body: some View {
        
        Button(action: action) {
            Image(systemName: isRecording ? "mic.fill" : "mic")
                .font(.system(size: 24))
                .foregroundColor(.accent)
            //                .padding()
            //                .background(Circle().fill(Color.gray.opacity(0)))
        }
        .shadow(radius: isRecording ? 5 : 0)
        .onAppear(){
            do {
                try requestPermissions()
            } catch {
                print(error.localizedDescription)
            }
             
        }
    }
    func requestPermissions() throws {
        let authStatus = SFSpeechRecognizer.authorizationStatus()

        guard authStatus == .authorized else {
            throw RecognizerError.notAuthorizedToRecognize
        }

        let recordPermission = AVAudioSession.sharedInstance().recordPermission
        guard recordPermission == .granted else {
            throw RecognizerError.notPermiredToRecord
        }
    }
    
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermiredToRecord
        case recognizerIsUnavailable

        var message: String {
            switch self {
            case .nilRecognizer:
                return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize:
                return "Not authorized to recognize speech"
            case .notPermiredToRecord:
                return "Not permitted to record audio"
            case .recognizerIsUnavailable:
                return "Recognizer is not available"
            }
        }
    }

}

