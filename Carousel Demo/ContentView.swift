//
//  ContentView.swift
//  Carousel Demo
//
//  Created by Jeet Gandhi on 20/4/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var orientation = UIDevice.current.orientation
    
    var body: some View {
        GeometryReader { reader in
            CarouselView(size: reader.size, orientation: orientation)
                .background(Color.black)
                .ignoresSafeArea()
            
        }
        .onAppear {
            orientation = UIDevice.current.orientation
        }
        .onRotate { newOrientation in
            orientation = newOrientation == .unknown ? orientation : newOrientation
        }
    }
}

struct CarouselView: View {
    
    let size: CGSize
    
    let padding: CGFloat = 20
    
    let colours: [Color] = [.red, .blue, .orange, .purple, .pink, .green, .yellow, .white]
    
    let emojis = ["✌️", "😂", "😍", "😒", "☺️", "😊", "😘", "😴"]
    
    let orientation: UIDeviceOrientation
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(emojis.indices, id: \.self) { i in
                    let emoji = emojis[i]
                    let colour = colours[i]
                    item(emoji, colour)
                    
                }
            }.padding(.horizontal, padding)
        }
    }
    
    func item(_ emoji: String, _ colour: Color) -> some View {
        let itemWidth = orientation == .portrait ? (size.width - (padding * 5)) : (size.height - (padding * 5))
        
        return GeometryReader { reader in
            let scale = getScale(proxy: reader)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(colour)
                Text(emoji)
                    .font(.system(size: 90))
            }
            .rotation3DEffect(
                getRotationAngle(reader: reader),
                axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
            )
            .scaleEffect(CGSize(width: scale, height: scale))
            .animation(.easeOut(duration: 1))
            .padding(.horizontal)
        }
        .frame(width: itemWidth, height: itemWidth * 1.4)

    }
    
    func getRotationAngle(reader: GeometryProxy) -> Angle {
        let isPortrait = orientation.isPortrait
        let midX = reader.frame(in: .global).midX
        let degrees = Double(midX - size.width / 2 ) /  8
        return Angle(degrees: -degrees * (isPortrait ? 0.5 : 1))
    }
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
//        guard let rootView = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.view else { return 1}
       
        let isPortrait = orientation.isPortrait
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        let midPoint: CGFloat = isPortrait ? (viewFrame.midX / 2) : viewFrame.maxX
        var scale: CGFloat =  0.75
        let deltaXAnimationThreshold: CGFloat = isPortrait ? 75 : 25
        
        let diffFromCenter = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2)
//        let diffFromCenter = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) /  (isPortrait ? 500 : 5000)
        }
        
        return scale
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
