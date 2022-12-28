//
//  Color.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/28/22.
//

import SwiftUI

// Create an extension on 'Color' to customize the app's dark mode support.
extension Color {
    static let theme = ColorTheme()
}

// Create our app's color theme using 'Color Set' in 'Assets' (e.g. we can access the new background color by using 'Color.theme.backgroundColor' in the views).
struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
}
