//
//  SpotifyView.swift
//  Carousel Demo
//
//  Created by Jeet Gandhi on 26/4/21.
//

import SwiftUI

struct Song: Identifiable, Equatable {
    var id: String { title }
    let title: String
    let artist: String
    let coverString: String
}

struct SpotifyView: View {
    
    let songs = [
        Song(title: "Trip", artist: "Crocodile ft", coverString: "cover"),
        Song(title: "Trip1", artist: "Crocodile ft1", coverString: "cover1"),
        Song(title: "Trip2", artist: "Crocodile ft2", coverString: "cover2"),
        Song(title: "Trip3", artist: "Crocodile ft3", coverString: "cover3"),
        Song(title: "Trip4", artist: "Crocodile ft4", coverString: "cover4"),
        Song(title: "Trip5", artist: "Crocodile ft5", coverString: "cover5"),
        Song(title: "Trip6", artist: "Crocodile ft6", coverString: "cover6"),
        Song(title: "Trip7", artist: "Crocodile ft7", coverString: "cover7"),
        Song(title: "Trip8", artist: "Crocodile ft8", coverString: "cover8"),
        Song(title: "Trip9", artist: "Crocodile ft9", coverString: "cover9"),
        Song(title: "Trip10", artist: "Crocodile ft10", coverString: "cover10"),
        Song(title: "Trip11", artist: "Crocodile ft11", coverString: "cover1")
    ]
    
    @State private var isPlaying = false
    @State private var isLiked = false
    @State private var selectedSong = Song(title: "Trip", artist: "Crocodile ft", coverString: "cover")
    
    
    let bgColor = Color(hue: 0, saturation: 0, brightness: 0.071)
    
    func getOffsetY(reader: GeometryProxy) -> CGFloat {
        let offsetY: CGFloat = -reader.frame(in: .named("scrollview")).minY
        if offsetY < 0 {
            return offsetY / 1.3
        }
        return offsetY
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { reader in
                
                let offsetY = getOffsetY(reader: reader)
                let height: CGFloat = (reader.size.height - offsetY) + offsetY / 3
                let minHeight: CGFloat = 120
                let opacity = (height - minHeight) / (reader.size.height - minHeight)
                
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.yellow,
                                                               Color.black.opacity(0)]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .scaleEffect(7)
                    Image(selectedSong.coverString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: height > 0 ? height : 0,
                               height: height > 0 ? height : 0)
                        .offset(y: offsetY)
                        .opacity(Double(opacity))
                        .shadow(color: Color.black.opacity(0.5),
                                radius: 30)
                    
                }
                .frame(width: reader.size.width)
            }
            .frame(height: 250)
            albumDetailsView
                .padding(.horizontal)
            Spacer()
                .frame(height: 25)
            songListView
                .padding(.horizontal)
        }
        .background(bgColor.ignoresSafeArea())
    }
    
    var songListView: some View {
        ForEach(songs) { song in
            HStack {
                Image(song.coverString)
                    .resizable()
                    .frame(maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                
                VStack(alignment: .leading, spacing:  5) {
                    Text(song.title)
                        .font(.title3)
                        .bold()
                    Text(song.artist)
                        .bold()
                        .font(.subheadline)
                        .opacity(0.8)
                }
                Spacer()
                Button(action: {
                      selectedSong = song
                  }) {
                    Text(selectedSong == song ? "Pause" : "Play")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                  }
                Image(systemName: "ellipsis")
                    .font(.system(size: 25))
                    .frame(maxHeight: .infinity)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            }
            .frame(height: 60)
            .foregroundColor(.white)
        }
    }
    
    var albumDetailsView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(selectedSong.title)
                    .font(.title)
                    .bold()
                HStack {
                    Image(selectedSong.coverString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text(selectedSong.artist)
                        .font(.title2)
                        .bold()
                }
                Text("Album • 2021")
                
                HStack(spacing: 30) {
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 30))
                            .padding(.top, 10)
                    }
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .frame(maxHeight: .infinity)
                        .offset(y: 5)
                    
                }
            }
            .foregroundColor(.white)
            Spacer()
            Button(action: {
                isPlaying.toggle()
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(.green)
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                }
                .frame(width: 80, height: 80)
            }
        }
        
    }
}

struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyView()
    }
}
