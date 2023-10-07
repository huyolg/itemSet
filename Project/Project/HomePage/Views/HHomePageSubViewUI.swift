//
//  HHomePageSubView.swift
//  Project
//
//  Created by 胡某人 on 2023/10/7.
//

import SwiftUI

struct HHomePageSubViewUI: View {
    @State private var dataSource: [PageConfig] = HConfig.loadConfigControllers("homePages")
    var body: some View {
        
        return NavigationView{
                    List{
                        ForEach(dataSource, id: \.self) { message in
                            NavigationLink(destination: DetailView(imageName: message.titleName)) {
                                Text(message.titleName)
                            }
                        }
                    }
//                    .navigationBarTitle("Picture List")
                }
//        List($dataSource) {$item in

//            if #available(iOS 16.0, *) {
//                Table(of: PageConfig.self) {
//                    TableColumn("TitleName", value: \.titleName)
//                } rows: {
//                    ForEach(dataSource) { member in
//                        TableRow(member)
//                    }
//                }
//            } else {
//                // Fallback on earlier versions
//                VStack {
//                    HStack {
//                        Text(item.titleName)
//                    }
//                }
//            }
            
//            if #available(iOS 16.0, *) {
//                        Label("Row \(item.titleName)", systemImage: "\(0).circle")
//                            .alignmentGuide(.listRowSeparatorLeading, computeValue: { dimension in
//                                dimension[.leading]
//                            })
//            } else {
//                // Fallback on earlier versions
//
//            }
//        }
    }
}

struct DetailView : View { //定义一个遵循View协议的结构体，作为导航的目标页面
    var imageName : String //表示需要显示的图片的名称
    var body: some View{
        Text(imageName)
    }
}

struct HHomePageSubViewUI_Previews: PreviewProvider {
    static var previews: some View {
        HHomePageSubViewUI()
    }
}
