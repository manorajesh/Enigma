//
//  NumeralPicker.swift
//  Engima
//
//  Created by Mano Rajesh on 6/21/23.
//

import SwiftUI

struct NumeralPicker: View {
    let numeralSystems: [String: [String]] = [
        "Western Arabic": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
        "Eastern Arabic": ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"],
        "Devanagari": ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"],
        "Bengali": ["০", "১", "২", "৩", "৪", "৫", "৬", "৭", "৮", "৯"],
        "Chinese": ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"],
        "Persian": ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"],
        "Tamil": ["௦", "௧", "௨", "௩", "௪", "௫", "௬", "௭", "௮", "௯"],
        "Thai": ["๐", "๑", "๒", "๓", "๔", "๕", "๖", "๗", "๘", "๙"],
        "Gujarati": ["૦", "૧", "૨", "૩", "૪", "૫", "૬", "૭", "૮", "૯"],
        "Gurmukhi": ["੦", "੧", "੨", "੩", "੪", "੫", "੬", "੭", "੮", "੯"]
    ]
    
    @AppStorage("language")
    var selectedSystem = "Devanagari"
    
    @AppStorage("numberSystem")
    var numberSystem: [String] = ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"]
    
    var body: some View {
        VStack {
            Picker("Select numeral system", selection: $selectedSystem) {
                ForEach(numeralSystems.keys.sorted(), id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: selectedSystem) { newValue in
                numberSystem = numeralSystems[newValue]!
            }
            .frame(height: 150)
            
            LazyHStack {
                ForEach(0..<10, id: \.self) { index in
                    VStack {
                        Text("\(index)")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.gray)
                        Text("\(numberSystem[index])")
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
        }
    }
}

struct NumeralPicker_Previews: PreviewProvider {
    static var previews: some View {
        NumeralPicker()
    }
}

