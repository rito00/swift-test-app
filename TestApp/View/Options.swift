//
//  Options.swift
//  Test App
//
//  Created by 伊藤陸斗 on 2023/12/09.
//

import SwiftUI

struct OptionsView: View {
    @State private var inputText = ""
    @State private var selectedOption = ""
    private  let options = ["オプション1", "オプション2", "オプション3"]
    
    var body: some View {
        Form {
            Section(header: Text("テキスト入力")) {
                TextField("ここに入力", text: $inputText)
            }
            
            Section(header: Text("オプション選択")) {
                Picker("選択してください", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        //                            Text(self.options[$0])
                        Text(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Text("入力されたテキスト: \(inputText)")
                Text("選択されたオプション: \(selectedOption)")
            }
        }
        .navigationBarTitle("Options", displayMode: .inline)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}

#Preview {
    OptionsView()
}
