//
//  App.swift
//  rs-ios
//

import SwiftUI

import slib

@main
struct iosApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView().onAppear {
				SwiftLibPrint()
			}
		}
	}
}
