//
//  MapView.swift
//  Eco_bin
//
//  Created by JWON on 2021/05/31.
//

import SwiftUI
import MapKit
import Firebase

struct MapView: View {
    @ObservedObject var viewmodel: FilterViewModel
    
    @State var showingMappinPopup: Bool = false
    @State var currentPosition: String = ""
    @State var currentContent: String = ""
    @State var currentCor: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 35.88827717110396, longitude: 128.61075861566593)
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.88827717110396, longitude: 128.61075861566593) , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: FilterViewModel.bins[viewmodel.choosedTab]!){ bin in
                MapAnnotation(coordinate: bin.location) {
                    ZStack{
                        Image(bin.content)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .onTapGesture{
                                showingMappinPopup = true
                                currentPosition = FilterViewModel.findPosition(location: bin, choosedTab: viewmodel.choosedTab)
                                currentContent = FilterViewModel.findContent(location: bin, choosedTab: viewmodel.choosedTab)
                                currentCor = FilterViewModel.findCor(location: bin, choosedTab: viewmodel.choosedTab)
                            }
                    }
                }
            }
            .popup(isPresented: $showingMappinPopup, view: {
                MapPopup(showingMappinPopup: $showingMappinPopup, currentPosition: $currentPosition, currentContent: $currentContent, currentCor: $currentCor)
                    .frame(minWidth: 0, maxWidth: 400, minHeight: 0, maxHeight: 800)
                    .cornerRadius(100)
            })
        }
        .zIndex(showingMappinPopup ? 30 : 0)
    }
}

struct MapPopup: View {
    
    @EnvironmentObject  var  userAuth: UserAuth
    let user = Auth.auth().currentUser
    let ref: DatabaseReference! = Database.database().reference()
    
    @State var isAlert:Bool = false
    
    @Binding var showingMappinPopup: Bool
    @Binding var currentPosition: String
    @Binding var currentContent: String
    @Binding var currentCor: CLLocationCoordinate2D
    
    init(showingMappinPopup: Binding<Bool> = .constant(true), currentPosition: Binding<String>, currentContent: Binding<String>, currentCor: Binding<CLLocationCoordinate2D>){
        _showingMappinPopup = showingMappinPopup
        _currentPosition = currentPosition
        _currentContent = currentContent
        _currentCor = currentCor
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("????????? ?????????")
                    .font(.system(size: 32))
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
            }
            .frame(width:350, height:200)
            .background(Color.green)
            
            HStack{
                if(currentContent == "?????????"){
                    Image("batteries")
                        .resizable()
        //                .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
        //                .clipped()
                        .cornerRadius(150)
                }else if(currentContent == "?????????") {
                    Image("broken")
                        .resizable()
        //                .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
        //                .clipped()
                        .cornerRadius(150)
                }else if(currentContent == "???????????????") {
                    Image("trash")
                        .resizable()
        //                .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
        //                .clipped()
                        .cornerRadius(150)
                }
                
                VStack(spacing: 5){
                    Text(currentContent).font(.system(size: 28))
                        .fontWeight(.semibold)
//                    Text("??????").foregroundColor(Color.gray)
                    Text(currentPosition).foregroundColor(Color.gray)
                }
                .padding(.leading, 30)
            }
            .offset(y:-55)
//            .padding(.leading, 10)
            
//            .offset(x:65, y:-145)
            
            
            Spacer()
            
            Text("????????? ??? 10M ?????? ????????? ??? ????????? ???????????????. ?????? ?????? ??? ?????? ?????? ?????? ??? ????????????.")
                .frame(width: 250)
                .foregroundColor(Color.gray)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 90){
                Text("??? ??????").foregroundColor(Color.black)
                    .font(.system(size: 20)).onTapGesture{
                        let arr =  user?.email?.components(separatedBy: ".")
                        var normal = UserAuth.userInfo.normal_count
                        var battery = UserAuth.userInfo.battery_count
                        var lamp = UserAuth.userInfo.lamp_count
                        
                        let ball_count = UserAuth.userInfo.ball_count + 1
                        UserAuth.userInfo.ball_count = UserAuth.userInfo.ball_count + 1
                        
                        if currentContent == "???????????????" {
                            normal = normal + 1
                            UserAuth.userInfo.normal_count = normal
                        }
                        else if currentContent == "?????????" {
                            battery = battery + 1
                            UserAuth.userInfo.battery_count = battery
                        }
                        else if currentContent == "?????????" {
                            lamp = lamp + 1
                            UserAuth.userInfo.lamp_count = lamp
                        }
                        
                        let post = ["id": UserAuth.userInfo.id,
                                    "username": UserAuth.userInfo.user_name,
                                    "num": UserAuth.userInfo.phone_number,
                                    "balls": ball_count,
                                    "gifts": UserAuth.userInfo.gift_count,
                                    "normal": normal,
                                    "battery": battery,
                                    "lamp": lamp] as [String : Any]
                        print(post)
                        ref.updateChildValues(["\(arr![0])/users/": post])
                        print("update success")
                        isAlert = true
                    }.alert(isPresented: $isAlert, content: {
                        Alert(title: Text("?????? ???????????????!"))
                    })
                Text("????????????").foregroundColor(Color.black)
                    .font(.system(size: 20))
                    .onTapGesture {
                        showingMappinPopup = false
                    }
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
    }
    
}
