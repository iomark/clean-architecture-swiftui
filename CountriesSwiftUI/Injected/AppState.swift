//
//  AppState.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting() {
        didSet {
            print("AppState, routing: \n\(routing)")
        }
    }

    var system = System()
}

extension AppState {
    struct UserData: Equatable {
        var countries: Loadable<[Country]> = .notRequested
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        var countriesList = CountriesList.Routing()
        var countryDetails = CountryDetails.Routing()
        var modalDetails = ModalDetailsView.Routing()
    }
}

extension AppState.ViewRouting: CustomStringConvertible {
    var description: String {
        return "AppState.ViewRouting:\n  countriesList: \(countriesList)\n  countryDetails: \(countryDetails)\n  modalDetails: \(modalDetails)\n"
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
        lhs.routing == rhs.routing &&
        lhs.system == rhs.system
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.userData.countries = .loaded(Country.mockedData)
        state.system.isActive = true
        return state
    }
}
#endif
