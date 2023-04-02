//
//  LogScreen.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI

struct LogScreen: View{
    
    var body: some View{
        
                ZStack {
                    VStack{
                        PageTitleSection()
                        TextbooksSection()
                    }
                    AddTextbookButton()
                    Spacer()
                }
        
        .modifier(BaseText())
    }
}

struct PageTitleSection: View{
    var body: some View{
        VStack(alignment: .leading) {
            HStack(){
                Text("教材の選択")
                    .modifier(PageTitle())
                Spacer()
            }
        }
        .padding()
    }
}

struct TextbooksSection: View{
    @ObservedObject var logVM = LogViewModel()
    
    // コンテンツ表示のレイアウト指定（4列ずつの配列）
    private var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View{
        ScrollView {
            VStack(alignment: .leading) {
                HStack(){
                    Text("カテゴリなし")
                        .modifier(SectionTitle())
                    Spacer()
                }
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(logVM.textbooks) { textbook in
                        NavigationLink {
                            RecordScreen()
                        } label: {
                            Text(textbook.title)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    init() {
        logVM.getData()
    }
}

struct AddTextbookButton: View{
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("Tapped!!")
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 32))
                })
                .frame(width: 60, height: 60)
                .background(Color.Blue)
                .cornerRadius(30.0)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
            }

        }
    }
}
