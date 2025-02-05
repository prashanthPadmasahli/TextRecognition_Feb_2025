//
//  ContentView.swift
//  TextRecognition_Feb_2025
//
//  Created by mac on 05/02/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = TextRecognitionViewModel()
    
    var body: some View {
        VStack {
            if let img = viewModel.selectedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(10)
            }
            
            PhotosPicker(selection: $viewModel.selectedItem, matching: .images, photoLibrary: .shared()) {
                Label("Select Image", systemImage: "photo")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: viewModel.selectedItem) { newItem in
                if let newItem {
                    viewModel.loadItem(item: newItem)
                }
            }
            
            if !viewModel.recognizedText.isEmpty {
                ScrollView {
                    Text(viewModel.recognizedText)
                        .padding()
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
