//
//  SurLeQuaiWidgetBundle.swift
//  SurLeQuaiWidget
//
//  Created by Nicolas Klutchnikoff on 24/01/2026.
//

import WidgetKit
import SwiftUI

@main
struct SurLeQuaiWidgetBundle: WidgetBundle {
    var body: some Widget {
        SurLeQuaiWidget()
        SurLeQuaiWidgetControl()
        SurLeQuaiWidgetLiveActivity()
    }
}
