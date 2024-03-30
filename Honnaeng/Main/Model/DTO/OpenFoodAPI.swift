//
//  Sample.swift
//  Honnaeng
//
//  Created by Rarla on 3/30/24.
//

import Foundation

struct OpenFoodAPI: Decodable {
    let serviceId: ServiceId

    enum CodingKeys: String, CodingKey {
        case serviceId = "C005"
    }
}

struct ServiceId: Decodable {
    let totalCount: String
    let row: [Row]
    let result: Result

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case result = "RESULT"
        case row
    }
}

struct Result: Decodable {
    let msg, code: String

    enum CodingKeys: String, CodingKey {
        case msg = "MSG"
        case code = "CODE"
    }
}

struct Row: Decodable {
    let name, group: String
//    let clsbizDt, siteAddr, prdlstReportNo, prmsDt, barCD, pogDaycnt, bsshNm, endDt, indutyNm: String

    enum CodingKeys: String, CodingKey {
        case name = "PRDLST_NM"
        case group = "PRDLST_DCNM"
//        case clsbizDt = "CLSBIZ_DT"
//        case siteAddr = "SITE_ADDR"
//        case prdlstReportNo = "PRDLST_REPORT_NO"
//        case prmsDt = "PRMS_DT"
//        case barCD = "BAR_CD"
//        case pogDaycnt = "POG_DAYCNT"
//        case bsshNm = "BSSH_NM"
//        case endDt = "END_DT"
//        case indutyNm = "INDUTY_NM"
    }
}
