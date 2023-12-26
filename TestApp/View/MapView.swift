//
//  MapView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/26.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion()
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic) // ←ここ追加
    
//    let initialPosition: MapCameraPosition = {
//        let center = CLLocationCoordinate2D(
//            latitude: 35.710057714926265,  // 緯度
//            longitude: 139.76 // 経度
//        )
//        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        let region = MKCoordinateRegion(center: center, span: span)
//        return .region(region)
//    }()

    var body: some View {
        Map(position: $position){
            UserAnnotation(anchor: .center) // ←ここ追加
        }
        .edgesIgnoringSafeArea(.all)

    }
}

struct LocationButton: View {
    
    @Binding var position: MapCameraPosition
    
    var body: some View {
        
        Button {
            position = .userLocation(fallback: .automatic)
        } label: {
            Label("ふるさと",systemImage: "location.circle")
        }
    }
}

#Preview {
    MapView()
}
