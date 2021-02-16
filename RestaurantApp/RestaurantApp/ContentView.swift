//
//  ContentView.swift
//  RestaurantApp
//
//  Created by Fazil P on 16/10/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        MainView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}

struct MainView : View {

    @State var menu = 0
    @State var page = 0

    var body: some View {

        ZStack {

            Color("Color").edgesIgnoringSafeArea(.all)

            VStack {

                ZStack {

                    HStack {

                        Button(action: {}) {

                            Image("Menu")
                                .renderingMode(.original)
                                .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(10)

                        Spacer()

                        Image("pic")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(12)
                    }
                    .padding()

                    Text("Food Items")
                        .font(.system(size: 22))
                }

                HStack(spacing: 15) {

                    Button(action: {
                        self.menu = 0
                    }) {

                        Text("Chinese")
                            .foregroundColor(self.menu == 0 ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    .background(self.menu == 0 ? Color.black : Color.white)
                    .clipShape(Capsule())

                    Button(action: {
                        self.menu = 1
                    }) {

                        Text("Italian")
                            .foregroundColor(self.menu == 1 ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    .background(self.menu == 1 ? Color.black : Color.white)
                    .clipShape(Capsule())

                    Button(action: {
                        self.menu = 2
                    }) {

                        Text("Mexican")
                            .foregroundColor(self.menu == 2 ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    .background(self.menu == 2 ? Color.black : Color.white)
                    .clipShape(Capsule())
                }
                .padding(.top, 30)

                GeometryReader{ g in
                    Carousel(width: UIScreen.main.bounds.width, page: self.$page, height: g.frame(in: .global).height)
                }
                PageControl(page: self.$page)
                    .padding(.top, 20)
            }
            .padding(.vertical)
        }
    }
}



struct List : View {

    @Binding var page : Int

    var body: some View {

        HStack(spacing: 0) {

            ForEach(data){ i in

                Card(page: self.$page, width: UIScreen.main.bounds.width, data: i)

            }
        }
    }
}

struct Card : View {

    @Binding var page : Int

    var width : CGFloat
    var data :Type

    var body: some View {


        VStack{

            VStack{

                Text(self.data.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                Text(self.data.cName)
                    .foregroundColor(.gray)
                    .padding(.vertical)

                Spacer(minLength: 0)

                Image(self.data.image)
                    .resizable()
                    .frame(width: self.width - (self.page == self.data.id ? 100 : 150), height: (self.page == self.data.id ? 250 : 200))
                    .cornerRadius(20)

                Text(self.data.price)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.top, 20)

                Button(action: {}){

                    Text("Buy")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                }
                .background(Color("Color"))
                .clipShape(Capsule())
                .padding(.top, 20)

                Spacer(minLength: 0)
            }

            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.top, 25)
            .padding(.vertical, self.page == data.id ? 0 : 25)
            .padding(.horizontal, self.page == data.id ? 0 : 25)

//            Increasing heigth and width if current page appears
        }
        .frame(width: self.width)
        .animation(.default)
    }
}



struct Carousel : UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Carousel.Coordinator(parent1: self)
    }


    var width : CGFloat
    @Binding var page : Int
    var height : CGFloat

    func makeUIView(context: Context) -> UIScrollView {

//        ScrollView content Size..
        let total = width * CGFloat(data.count)
        let view = UIScrollView()
        view.isPagingEnabled = true
//        1.0 for disabling vertical scroll..

        view.contentSize = CGSize(width: total, height: 1.0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = context.coordinator

//         Now going to embed swiftui view into UIView

        let view1 = UIHostingController(rootView: List(page: self.$page))
        view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
        view1.view.backgroundColor = .clear
        view.addSubview(view1.view)

        return view
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {

    }

    class Coordinator: NSObject,UIScrollViewDelegate {

        var parent : Carousel

        init(parent1: Carousel) {

            parent = parent1
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

//             Using this function for getting current Page

            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)

            self.parent.page = page
        }
    }
}

struct PageControl : UIViewRepresentable {

    @Binding var page : Int

    func makeUIView(context: Context) -> UIPageControl {

        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .black
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        view.numberOfPages = data.count
        return view
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
//        updating page indicator when ener page changes

        DispatchQueue.main.async {

            uiView.currentPage = self.page
        }
    }
}

struct Type : Identifiable {

    var id : Int
    var name : String
    var cName : String
    var price : String
    var image : String
}

var data = [

    Type(id: 0, name: "Soba Noodles", cName: "Chinese", price: "$22", image: "soba"),
    Type(id: 1, name: "Rice Stick Noodles", cName: "Italian", price: "$16", image: "rice"),
    Type(id: 2, name: "Hokkien Noodles", cName: "Chinese", price: "$44", image: "hokkien"),
    Type(id: 3, name: "Mung Bean Noodles", cName: "Chinese", price: "$34", image: "bean"),
    Type(id: 4, name: "udon Noodles", cName: "Chinese", price: "$26", image: "udon")

]

