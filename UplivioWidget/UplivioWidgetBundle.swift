//
//  UplivioWidgetBundle.swift
//  UplivioWidget
//
//  Created by Sümeyra Demirtaş on 10/19/24.
//

import WidgetKit
import SwiftUI

@main
struct UplivioWidgetBundle: WidgetBundle {
    var body: some Widget {
        UplivioWidget()
        UplivioWidgetControl()
        UplivioWidgetLiveActivity()
    }
}
