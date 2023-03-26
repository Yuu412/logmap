//
//  Size.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/26.
//

import SwiftUI

// 画面サイズに関する定義
struct FrameSize{
    // 画面の横幅
    var width: CGFloat{
        UIScreen.main.bounds.width
    }
    // 画面の高さ
    var height: CGFloat{
        UIScreen.main.bounds.height
    }
}
