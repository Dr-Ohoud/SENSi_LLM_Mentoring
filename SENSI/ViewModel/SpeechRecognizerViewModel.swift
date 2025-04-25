//
//  SpeechRecognizerViewModel.swift
//  SENSI
//
//  Created by Shahad Bagarish on 25/04/2025.
//
import Foundation
import Speech

 
final class SpeechRecognizer: ObservableObject {
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
    
    @Published var transcript = ""

    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var synthesizer = AVSpeechSynthesizer()
    private var recognizer: SFSpeechRecognizer?
    
    init () {
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        Task(priority: .background){
            do{
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                
                
            } catch {
                recognizationError(error)
            }
        }
    }
    
//    func rest() {
//        Task?.cancel()
//        audioEngine?.stop()
//        audioEngine = nil
//        recognitionRequest = nil
////        Task = nil
//    }
//    
    private func recognizationError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
            print("Speech recognition error: \(error.localizedDescription)")
        }
        
        transcript = "<<\(errorMessage)>>"
    }
    
    
}
