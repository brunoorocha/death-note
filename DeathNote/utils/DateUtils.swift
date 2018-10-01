//
//  DateUtils.swift
//  DeathNote
//
//  Created by Ada 2018 on 27/09/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import Foundation

func getHoursMinutesAndSeconds(from date: Date) -> String {
	return formatter(with: "HH:mm:ss").string(from: date)
}

func getYearMonthAndDay(from date: Date) -> String {
	return formatter(with: "yyyy/MM/dd").string(from: date)
}

private func formatter(with format: String) -> DateFormatter {
	let formatter = DateFormatter()
	formatter.dateFormat = format
	
	return formatter
}

func formatterToLongStyle(with date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    
    return formatter.string(from: date)
}
