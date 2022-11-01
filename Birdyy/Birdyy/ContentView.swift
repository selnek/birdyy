//
//  ContentView.swift
//  Birdyy
//
//  Created by Selnekovic on 01/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var classificator = Classification()
    
    var body: some View {
        Text("\(classificator.value)")
            .padding()
            .onAppear( perform: {classificator.start()
                classificator.getValue()
            } )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
