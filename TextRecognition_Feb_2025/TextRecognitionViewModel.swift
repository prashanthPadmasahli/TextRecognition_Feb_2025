//
//  TextRecognitionViewModel.swift
//  TextRecognition_Feb_2025
//
//  Created by mac on 05/02/25.
//

import Foundation
import PhotosUI
import SwiftUI
import Vision

class TextRecognitionViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var recognizedText = ""
    
    func loadItem(item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.selectedImage = uiImage
                        self.recognizeText(from: uiImage)
                    }
                }
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
    
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let text = observations.compactMap { $0.topCandidates(1).first?.string }
                DispatchQueue.main.async {
                    self.recognizedText = text.joined(separator: "\n")
                }
            }
        }
        
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform text recognition: \(error.localizedDescription)")
            }
        }
    }
}
