//
//  ModalDetailsView.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 26.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import SwiftUI
import Combine

extension ModalDetailsView {

    struct Routing: Equatable {
        var countryDetailsPresented: Bool = false
    }
}

extension ModalDetailsView.Routing: CustomStringConvertible {
    var description: String {
        return "ModalDetailsView.Routing, countryDetailsPresented: \(countryDetailsPresented)"
    }
}

private extension ModalDetailsView {
    
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.modalDetails)
    }
}

struct ModalDetailsView: View {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.modalDetails)
    }

    let country: Country
    @Binding var isDisplayed: Bool
    let inspection = Inspection<Self>()
    
    var body: some View {
        NavigationView {
            VStack {
                country.flag.map { url in
                    HStack {
                        Spacer()
                        SVGImageView(imageURL: url)
                            .frame(width: 300, height: 200)
                        Spacer()
                    }
                }
                closeButton.padding(.top, 40)
                nextButton.padding(.top, 40)
                
                navigations
            }
            .navigationBarTitle(Text(country.name), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(routingUpdate) { self.routingState = $0 }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        .attachEnvironmentOverrides()
    }
    
    private var navigations: some View {
        Group {
            NavigationLink(
                destination: CountryDetails(country: country),
                isActive: routingBinding.countryDetailsPresented,
                label: { EmptyView() })
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            self.injected.appState[\.routing.modalDetails.countryDetailsPresented] = true
        }, label: { Text("Show country") })
    }

    private var closeButton: some View {
        Button(action: {
            self.isDisplayed = false
        }, label: { Text("Close") })
    }
}

#if DEBUG
struct ModalDetailsView_Previews: PreviewProvider {
    
    @State static var isDisplayed: Bool = true
    
    static var previews: some View {
        ModalDetailsView(country: Country.mockedData[0], isDisplayed: $isDisplayed)
            .inject(.preview)
    }
}
#endif
