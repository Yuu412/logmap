//
//  CustomDatePicker.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/23.
//

import SwiftUI

struct CustomDatePicker: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var reportVM: ReportViewModel
    @State var currentMonth: Int = 0
    @State var displayDate: Date = Date()
    
    
    var body: some View {
        VStack(spacing: 25) {
            let days = ["日", "月", "火", "水", "木", "金", "土"]
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2 )
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                
                
            }
            .padding(.horizontal)
            
            // Day View...
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            
            //Date
            // Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background(
                            Circle()
                                .fill(Color.Blue)
                                .opacity(isSameDay(date1: value.date, date2: reportVM.baseDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            reportVM.changeBaseDate(newDate: value.date)
                            reportVM.changeTargetDate(newDate: value.date)
                            dismiss()
                        }
                }
            }
            
        }
        .padding(.horizontal)
        .onChange(of: currentMonth) { newValue in
            // update month
            self.displayDate = getCurrentMonth()
        }
        .onAppear{
            self.displayDate = reportVM.baseDate
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .baseTextModifier()
                    .fontWeight(.bold)
                    .foregroundColor(isSameDay(date1: value.date , date2: reportVM.baseDate) ? .white : .primary)
                    .frame(maxWidth: .infinity)
    
                Spacer()
            }
        }
        .padding(.vertical, 9)
        .frame(height: 45, alignment: .top)
        
    }
    // Checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
        
    }
    
    
    // Extraing year and month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: self.displayDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // Getting Current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        // Getting Current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            let dateValue =  DateValue(day: day, date: date)
            return dateValue
        }
        
        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // geting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        
        // getting date...
        return range!.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1 , to: startDate)!
        }
        
    }
    
    
}
