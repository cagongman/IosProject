//
//  TipView.swift
//  Eco_bin
//
//  Created by JWON on 2021/06/17.
//

import SwiftUI

//struct TipView: View {
//    var body: some View {
//        Home()
//    }
//}

struct TipView: View {
    
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 30
    @State var op : CGFloat = 0
    
    @Binding var showingPopup: Bool
    
    @State var data = [

        Card(id: 0, img: "lamp_bin", name: "lamp", show: false),
        Card(id: 1, img: "battery_bin", name: "batery", show: false),


    ]
    
    var body : some View{
        
        ScrollView{
            VStack{
                
                Spacer()
                
                HStack(spacing: 15){
                    
                    ForEach(data){i in
                        CardView(data: i)
                        .offset(x: self.x)
                        .highPriorityGesture(DragGesture()
                        
                            .onChanged({ (value) in
                                
                                if value.translation.width > 0{
                                    
                                    self.x = value.location.x
                                }
                                else{
                                    
                                    self.x = value.location.x - self.screen
                                }
                                
                            })
                            .onEnded({ (value) in

                                if value.translation.width > 0{
                                    
                                    
                                    if value.translation.width > ((self.screen - 80) / 2) && Int(self.count) != 0{
                                        
                                        
                                        self.count -= 1
                                        self.updateHeight(value: Int(self.count))
                                        self.x = -((self.screen + 15) * self.count)
                                    }
                                    else{
                                        
                                        self.x = -((self.screen + 15) * self.count)
                                    }
                                }
                                else{
                                    
                                    
                                    if -value.translation.width > ((self.screen - 80) / 2) && Int(self.count) !=  (self.data.count - 1){
                                        
                                        self.count += 1
                                        self.updateHeight(value: Int(self.count))
                                        self.x = -((self.screen + 15) * self.count)
                                    }
                                    else{
                                        
                                        self.x = -((self.screen + 15) * self.count)
                                    }
                                }
                            })
                        )
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .offset(x: self.op)
                
//                closeButton()
//                Spacer()
            }
            .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
            
            .animation(.spring())
            .onAppear {
                
                self.op = ((self.screen + 15) * CGFloat(self.data.count / 2)) - (self.data.count % 2 == 0 ? ((self.screen + 15) / 2) : 0)
                
                self.data[0].show = true
            }
        }
    }
    
    func closeButton() -> some View{
        Button(action:{
            self.showingPopup = false
        }, label:{
            Text("닫기")
                .font(.system(size: 14))
                .foregroundColor(Color.black)
                .fontWeight(.bold)
        })
        .frame(width: 100, height: 40)
        .background(Color.white)
        .cornerRadius(20)
    }

    
    func updateHeight(value : Int){
        
        
        for i in 0..<data.count{
            
            data[i].show = false
        }
        
        data[value].show = true
    }
}

struct CardView : View {
    
    var data : Card
    
    var body : some View{
        
        VStack(alignment: .leading, spacing: 0){
            
            Image(data.img)
            .resizable()
            
            Text(data.name)
                .fontWeight(.bold)
                .padding(.vertical, 13)
                .padding(.leading)
            
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 700)
        .background(Color.green) //card background
        .cornerRadius(25)
    }
}

struct Card : Identifiable {
    
    var id : Int
    var img : String
    var name : String
    var show : Bool
}
