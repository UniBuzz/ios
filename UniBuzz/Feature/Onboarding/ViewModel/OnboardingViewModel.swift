//
//  OnboardingViewModel.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 24/10/22.
//

import Foundation

class OnboardingViewModel {
    
    var slides: [OnboardingSlides] = [
        OnboardingSlides(heading: "Post Anonymously!", description: "Share your thoughts, stories, and struggle as college students!", image: "onboarding1"),
        OnboardingSlides(heading: "Build a friendship", description: "Befriend someone and build your relationship with them through levels with gamification!", image: "onboarding2"),
        OnboardingSlides(heading: "We’ll accompany you as you adjust in college", description: "We understand that everything is changing for you. But, we want to make it better.", image: "onboarding3")
    ]
    
    func saveToUserDefault() {
        UserDefaults.standard.set(true, forKey: "onboarded")
    }
    
}
