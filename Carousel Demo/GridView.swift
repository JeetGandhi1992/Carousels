//
//  GridView.swift
//  Carousel Demo
//
//  Created by Jeet Gandhi on 27/4/21.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let imgColor: Color
}

struct GridView: View {
    
    let items = [
        Item(title: "Home", image: "house.fill", imgColor: .orange),
        Item(title: "Money", image: "dollarsign.square.fill", imgColor: .green),
        Item(title: "Bank", image: "banknote.fill", imgColor: Color.black.opacity(0.8)),
        Item(title: "Vacation", image: "airplane", imgColor: .green),
        Item(title: "User", image: "person.fill", imgColor: .blue),
        Item(title: "Charts", image: "chart.bar.fill", imgColor: .orange),
        Item(title: "Support", image: "message.fill", imgColor: .purple)
    ]
    
    @State private var orientation: UIDeviceOrientation = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? .portrait : .landscapeLeft
    let spacing: CGFloat = 10
    @State  private var numberOfColumns = 3
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: spacing),
                            count: numberOfColumns)
        
        ScrollView {
            headerView
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(items) { item in
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        ItemView(item: item)
                    }
                    .buttonStyle(ItemButtonStyle(cornerRadius: 20))
                }
            }
            .padding(.horizontal)
            .offset(y: -50)
        }
        .background(Color.white)
        .ignoresSafeArea()
        .onAppear {
            orientation = UIDevice.current.orientation == .unknown ? orientation : UIDevice.current.orientation
        }
        .onRotate { newOrientation in
            print( newOrientation == .unknown)
            orientation = newOrientation == .unknown ? orientation : newOrientation
            numberOfColumns = orientation.isPortrait ? 2 : 4
        }
    }
    
    var headerView: some View {
        VStack(spacing: 5) {
            Image(systemName: "person.fill")
                .font(.system(size: 100))
                .foregroundColor(Color.red)
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .onTapGesture {
                    numberOfColumns = [1, 2, 3, 4]
                        .filter { $0 != numberOfColumns }
                        .randomElement() ?? 3
                }
            Text("Tap the above image")
                .font(.title3)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
        .frame(height: 350)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
    
}

struct ItemButtonStyle: ButtonStyle {
    
    let cornerRadius: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
            if configuration.isPressed {
                Color.black.opacity(0.2)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, y: 5)
    }
    
}

struct ItemView: View {
    let item: Item
    
    var body: some View {
        GeometryReader { reader in
            
            let fontSize = min(reader.size.width * 0.2, 28)
            let imageWidth: CGFloat = min(50, reader.size.width * 0.6)
            
            VStack(spacing: 5) {
                Image(systemName: item.image)
                    .font(.system(size: 50))
                    .foregroundColor(item.imgColor)
                    .frame(width: imageWidth)
                Text(item.title)
                    .font(.system(size: fontSize))
                    .bold()
                    .foregroundColor(Color.black.opacity(0.8))
            }
            .frame(width: reader.size.width,
                   height: reader.size.height)
            .background(Color.white)
        }
        .frame(height: 150)
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .shadow(color: Color.black.opacity(0.2), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, y: 5)
    }
    
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
