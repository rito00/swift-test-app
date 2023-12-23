//
//  TimeView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import SwiftUI

struct TimeView: View {
    @StateObject var viewModel = TimeViewModel()
    
    var body: some View {
        currentTimeView()
        
        Section("タイマー"){
            // カウントダウン表示
            Text("\(viewModel.remainingTimeFormatted)")
                .font(.largeTitle)
            
            HStack {
                timePickerView(selection: $viewModel.timeSelection)
            }
            .frame(height: 150)
        
            
            HStack {
                Button(action: {
                    viewModel.clearTimer()
                }) {
                    Text("キャンセル")
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .background(viewModel.totalTimeSeconds == 0 ? Color.gray : Color.red)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.startTimer()
                }) {
                    Text("開始")
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                        .brightness(0.7)
                        .background(.green)
                        .brightness(viewModel.totalTimeSeconds == 0 ? -0.6 : 0)
                        .clipShape(Circle())
                }
                .disabled(viewModel.totalTimeSeconds == 0)
            }
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
    }
    
    private func currentTimeView() -> some View {
        withAnimation(.easeInOut(duration: 10.0)) {
            Text(viewModel.currentTime)
                .font(.largeTitle)
                .bold()
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 3)
                )
                .padding()
        }
    }
    
    private func timePickerView(selection: Binding<(hours: Int, minutes: Int, seconds: Int)>) -> some View {
        HStack {
            // hours
            Picker("時間", selection: selection.hours) {
                ForEach(0..<24, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .clipped()
            Text("時間")
                .font(.headline)
            
            // minutes
            Picker("分", selection: selection.minutes) {
                ForEach(0..<60, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .clipped()
            Text("分")
                .font(.headline)
            
            // seconds
            Picker("秒", selection: selection.seconds) {
                ForEach(0..<60, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .clipped()
            Text("秒")
                .font(.headline)
            
        }
        .padding()
    }
}

#Preview {
    TimeView()
}
