//
//  TabBarViewModel.swift
//  Carousel Demo
//
//  Created by Jeet Gandhi on 27/4/21.
//

import Foundation
import Combine

public class TabBarViewModel: ObservableObject {
    @Published var selectedTab = 0
    let cancelBag = CancelBag()
    
    init() {
        self.selectedTab = 0
      //  tabChange()
    }
    
    func tabChange() {
        $selectedTab.sink { (tab) in
            print(tab)
        }
        .cancel(with: cancelBag)
    }
}
