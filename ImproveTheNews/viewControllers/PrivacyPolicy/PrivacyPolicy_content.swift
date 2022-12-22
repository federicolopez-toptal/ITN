//
//  PrivacyPolicy_content.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/12/2022.
//

import Foundation

extension PrivacyPolicyViewController {

    func subTitles(_ index: Int) -> String {
        let data = [
            "What personal data we collect and why we collect it",
            "Cookies",
            "Analytics",
            "Embedded and linked content from other websites",
            "Who we share your data with",
            "How long we retain your data",
            "What rights you have over your data",
            "Additional information",
            "What data breach procedures we have in place",
            "What third parties we receive data from",
            "What automated decision making and/or profiling we do with user data",
            "Industry regulatory disclosure requirements"
        ]
        
        return data[index-1]
    }

    func paragraphs(_ index: Int) -> String {
        let data = [
            "This site is provided as a free public service with no commercial aspirations whatsoever, so we will never share personal data about you with anybody unless legally forced to. The hosting provider for the website (currently AWS) may store IP addresses for security reasons and to maintain the integrity of the hosting platform. These are deleted when they are no longer needed.",
            "We use cookies to store your slider settings for as long as possible, to save you the hassle of re-setting them every time you return to the site. The length of time with which the cookies remain in your browser is also determined by the user preferences set in your browser.",
            "To prevent server overload, track site growth and research usage patterns, we keep a secure permanent log of site visits consisting of access times, pages visited, IP addresses and slider settings. These data will never be shared, but high-level analysis of user interests may be used for future research, for example to determine whether user interest in various news topics differs from the proportions in which these topics are written about in media.",
            "All articles you may read as a result of visiting our site are hosted on external news sites, so from a privacy perspective, reading them is equivalent to visiting those sites directly. These news sites may collect data about you, use cookies, embed additional third-party tracking, and monitor your interaction with that embedded content, including tracing your interaction with embedded content if you have an account and are logged in to that website.",
            "We will not share your data unless legally forced to.",
            "If you fill out the feedback form, your feedback and its metadata are retained indefinitely, so we can keep track of any suggestions you may have and hopefully implement them. We also do not delete the above-mentioned analytics data, to keep open the possibility of future research.",
            "If you have used this site, you can use our [0] to request to receive an exported file of all data we hold about you. You can also request that we erase any personal data we hold about you. If you any privacy-specific concerns, please fill out our [1].",
            "Any data you’ve provided us is stored on a secure server.",
            "If a data breach occurs on one of our servers, we cannot email our users about it since we do not collect names or contact information.",
            "We do not receive data from third parties.",
            "We do not use user data for automated decision making or profiling.",
            "We are not part of a regulated industry."
        ]
        
        return data[index-1]
    }
    
    func linkTexts(_ index: Int) -> [String] {
        if(index==7) {
            return ["feedback form", "feedback form"]
        } else {
            return []
        }
    }
    
    func urls(_ index: Int) -> [String] {
        if(index==7) {
            return ["local://feedbackForm", "local://feedbackForm"]
        } else {
            return []
        }
    }

}
