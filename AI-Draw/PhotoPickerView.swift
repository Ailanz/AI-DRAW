//
//  PhotoPickerView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-30.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var image : UIImage
    var onImgChange: (_ image: UIImage) -> Void

    
    var body: some View {

        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Select photo")
            }.onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        print("Updating Img")
                        let uiimage = UIImage(data: data)
                        image = uiimage ?? UIImage()
                        onImgChange(image)
                    }
                }
            }
    }
}


