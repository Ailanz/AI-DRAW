//
//  MainView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-16.
//

import SwiftUI
import UIKit
import PencilKit

struct DrawingView: View {
    
    @ObservedObject var sideBarView : SideBarView
    @ObservedObject var layerModel : LayersModel
    @State var bgImage : UIImage
    @State var isBgImgSet = false
    @State var imgUtil : ImageUtil
    
    var imageSaver = ImageSaver()
    
    let CLEAR_IMAGE = UIImage()
    //@State var canvasView: PKCanvasView
    
    init(sideBarView: SideBarView, layerModel: LayersModel = LayersModel()) {
        self.sideBarView = sideBarView
        self.layerModel = layerModel
        self.bgImage = CLEAR_IMAGE
        self.imgUtil = ImageUtil(layerModel: layerModel)
    }
    
    var body: some View {
        NavigationStack {
            HStack (alignment: .top, spacing: 0) {
                ZStack {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFit()
                        .zIndex(-Double.infinity)
                    ForEach(layerModel.layers, id: \.id) { layer in
                        layer.canvasView
                            .background(.clear)
                            .padding(0)
                            .zIndex( sideBarView.selectedLayer == layer.layerIndex ? Double.infinity : Double(100 - layer.layerIndex))
                    }
                }.padding(.top, 25)
                
                sideBarView.GetView().background(Color.brown)
                
            }
            .frame(height: UIScreen.main.bounds.height)
            
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    PhotoPickerView(image: bgImage, onImgChange: updateBgImage)
                }
                
                ToolbarItem(placement: .automatic) {
                    Button {
                        clearBgImage()
                    } label : {
                        Text("Clear Background")
                    }
                }
                
                ToolbarItem(placement: .automatic) {
                    Button {
                       saveImage()
                        
                    } label : {
                        Text("Save")
                    }

                }
                
            
                ToolbarItem(placement: .automatic) {
                    ShareLink(item: getFirstLayerImage(),
                              preview: SharePreview("Artwork", image: getFirstLayerImage()))

                }
            }
            .navigationTitle("AI-Draw")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar, .bottomBar)
            .toolbarBackground(.visible, for: .navigationBar, .bottomBar)
            
            .background(.gray)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension DrawingView {
    
    func updateBgImage(image : UIImage) -> Void{
        self.isBgImgSet = true
        self.bgImage = image
    }
    
    func clearBgImage() -> Void{
        self.isBgImgSet = false
        self.bgImage = CLEAR_IMAGE
    }
    
    func getFirstLayerImage() -> Image {
        let firstCanvas = layerModel.layers[0].canvasView!
        
        if firstCanvas.pkCanvasView.drawing.strokes.count == 0 {
            return Image(uiImage: CLEAR_IMAGE)
        }
         
         let photo = firstCanvas.pkCanvasView.drawing.image(from: firstCanvas.pkCanvasView.bounds, scale: 1.0)
        
        return Image(uiImage: photo)
    }
    
    func saveImage ()-> Void {
        let imgToSave = imgUtil.getMergedImage(backgroundImage: isBgImgSet ? bgImage : nil)
        imageSaver.writeToPhotoAlbum(image: imgToSave)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let layersModel = LayersModel()
        DrawingView(sideBarView: SideBarView(layerModel: layersModel), layerModel: layersModel)
    }
}
