//
//  FAQ_content.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/03/2023.
//

import Foundation
import UIKit

extension FAQViewController {

    func titles(_ index: Int) -> String {
        let data = [
            "Have you rebranded?",
            "Why might I like Verity?",
            "Why should I read narratives I disagree with?",
            "Why don't you block all \"disinformation\"?",
            "What's establishment bias?",
            "How does Verity's news aggregation work?",
            "Is there a Verity app?",
            "Won't Verity contribute to filter bubbles?",
            "Who’s behind this?",
            "Is the Improve the News Foundation political?",
            "What are the values of the Improve the News Foundation?",
            "What’s your privacy policy?",
            "How can I help?",
            "How can I contact you with feedback?"
        ]
        
        return data[index-1]
    }
    
    func mainContent_A() -> String {
        return """
        Verity is a free news site created by the Improve the News Foundation (ITN), an apolitical American non-profit. It aims to counter misuses of artificial intelligence that have resulted in a distorted online news environment, where alternative facts often overshadow scientific truths, and fractured narratives contribute to social discord. Verity’s aim is to empower people to discover the complete and nuanced truth behind every major news story. It does this by separating facts from narratives. This even includes “nerd narratives” from the Metaculus forecasting community. Verity is also a powerful news aggregator facilitating viewing news from multiple perspectives.

        The Improve the News Foundation was founded in October 2020 as a 501c(3) non-profit organization in the United States by MIT Prof. [0]. Its team initially consisted of MIT researchers, but has since grown to include a broad group of international collaborators. The Foundation’s mission is to empower people to rise above controversies and understand the world in a nuanced way. Its vision is a world with less hate and more understanding, where society has reasoned compassion, constructive discourse, and well-informed decision-making. [1]
        """
    }
    
    func mainContent_B() -> String {
            return """
        Verity is a free news site created by the Improve the News Foundation (ITN), an apolitical American non-profit. It aims to counter misuses of artificial intelligence... [0]
        """
        
    }
    
    func contents(_ index: Int) -> String {
        let data = [
            "Yes, we initiated a rebranding process in August 2023. Although the Improve the News Foundation has maintained its original name, we've introduced a distinct name, Verity, for our news site, inspired by the Latin word \"veritas\", meaning \"truth\". We're working to significantly expand our truth-seeking mission by rolling out powerful new tools on this site that we hope you'll find useful. Our vision is that a shared understanding of what's actually happening in the world will enable humanity to collaborate toward a better future for everyone.",
            """
            1. You’re busy: Most people lack the time to read a range of sources to get an unbiased understanding of what’s really going on. Verity does this for you, conveniently summarizing trustworthy facts – with source links that you can verify yourself.
            
            2. Your voice is heard and respected: Facts aside, you’ll also find fairly presented competing narratives – including your own – regardless of where your home is on the political spectrum.
            
            3. It’s useful to know what other people think: By understanding other people’s arguments, you understand why they do what they do – and have a better chance of persuading them.
            
            4. You won’t get mind-hacked: Many website algorithms push you (for ad revenue) into a filter bubble by reinforcing the narratives you impulse-click on. Just as it's healthier to choose what you eat deliberately rather than impulsively, it's more empowering to choose your news diet deliberately with sliders, as explained in [0].
            
            5. You’re bored: Many news outlets are so partisan that their coverage gets boringly narrow. Quality debates about important controversies can be quite interesting!
            
            6. You don’t want to be part of the problem: If you spend your time consuming biased news that others profit from, you’re feeding the incentive structure that makes people in power manipulate you and others.
            """,
            "It's oft-argued that we should silence those we are convinced are wrong, to avoid giving them a platform. We strongly disagree. Even more important than their freedom to speak, is your freedom to hear. We believe that you're good at calling \"bs\" when you see it, and reject the patronizing premise that your mind is too frail to read poor arguments without falling for them. Moreover, to truly understand a political or military battle, we need to understand both sides' arguments. The better we understand poor arguments, the more successfully we can defeat them. Also, when someone blocks information, how can you be sure they’re trying to protect you rather than themselves?",
            "Because figuring out the truth can be hard! If it were simple enough to be delegated to a corporate or governmental fact-checking committee, we would no longer need science, and MIT should fire its researchers. Top physicists spent centuries believing in the wrong theory of gravity, and truth-finding gets no easier when politics and vested interests enter; the Ministry of Truth in Orwell’s novel 1984 reminds us that one of the oldest propaganda tricks is to accuse the other side of spreading disinformation.",
//            "When we used Machine Learning to objectively classify a million news articles by their bias [0], the algorithm uncovered two main bias axes: the well-known left-right bias as well as establishment bias. The establishment view is what all big parties and powers agree on, which varies between countries and over time. For example, the old establishment view that women shouldn’t be allowed to vote was successfully challenged. Verity makes it easy for you to compare the perspectives of the pro-establishment mainstream media with those of smaller establishment-critical news outlets that you won’t find in most other news aggregators.",
            "When we used Machine Learning to objectively classify a million news articles by their bias [0], the algorithm uncovered two main bias axes: the well-known left-right bias as well as establishment bias. The establishment view is what all big parties and powers agree on, which varies between countries and over time. For example, the old establishment view that women shouldn’t be allowed to vote was successfully challenged. Verity makes it easy for you to compare the perspectives of the pro-establishment mainstream media with those of smaller establishment-critical news outlets that you won’t find in most other news aggregators.\n\nTwo bias sliders correspond to these two bias axes, letting you choose the political stance of your news sources. The left-right slider uses a classification of media outlets based on political leaning, mainly from [1]. The establishment slider classifies media outlets based on how close they are to power (see, e.g., Wikipedia’s lists of [2], libertarian and [3] alternative media and [4] classification): does the news source normally accept or challenge claims by powerful entities such as the government and large corporations? Rather than leaving them alone, you’ll probably enjoy spicing things up by occasionally sliding them to see what those you disagree with cover various topics.",
            
            "The free information sources on our site are powered by machine-learning (ML) and crowdsourcing. We use ML to classify all articles by topics for the news aggregator topics; we’ve shared our code on GitHub; please let us know if you’d like to help us improve it! We also use ML to group together articles about the same story, so that you can compare and contrast their perspectives using our sliders. To produce a story page (example [0]), our editorial team then extracts both the key facts (that all articles agree on) and the key narratives (where the articles differ). We also do academic research on media bias – [1] is a paper on how media bias can be objectively measured from raw data without human input.",
            "Yes: We have free apps for iOS [0] and Android [1].",
            "There's a rich scientific literature on how click-optimizing algorithms at Facebook, Google,etc. have polarized and divided society into groups that each get exposed only to ideas they already agree with. So won't giving people choices such as the left-right slider on this site exacerbate the problem? [0] from David Rand's MIT group suggests the opposite: that people become less susceptible to fake news and bias when given easy access to a range of information, enabling what Kahneman calls \"system 2\" deliberation instead of \"system 1\" impulsive clicking and reacting. Their work also suggests that many people are interested in opinions disagreeing with their own, if expressed in a nuanced and respectful way, but are rarely exposed to this. So let’s not rush to blame consumers rather than providers of news.",
            "The Improve the News Foundation began in 2020 as an MIT research project led by Prof. [0] on machine learning for news classification. Huge thanks to Khaled Shehada, Mindy Long and Arun Wongprommoon for creating the initial news aggregator [1], [2] and [3] and to Tim Woolley for design help. To enable scaling up, ITN was incorporated as a philanthropically funded 501c(3) non-profit organization. Our site and apps will always be free and without ads.",
            "No. Although we respect that people across the political spectrum disagree on how the world ought to be, we believe that news should help everyone agree on how the world is. We therefore work to separate opinion (“ought”) from fact (“is”). We seek to build a team that’s well-balanced across the political spectrum, and encourage it to treat media bias from all sides in the same way.",
            """
            • Scientific truth seeking: We believe that democracy works best when voters know the truth and that science is humanity's best truth-finding system.
            
            • Political impartiality: Although we respect that people across the political spectrum disagree on how the world ought to be, news should help everyone agree on how the world is. We therefore work to separate opinion (“ought”) from fact (“is”).
            
            • Privacy and security: We seek to counter humanity’s currently dominant form of news consumption - where online news feeds managed by algorithms of powerful technology companies treat newsreaders’ attention and personal data as a product to sell to advertisers.
            
            • Empowerment: We consider it patronizing and anti-democratic for governments and companies to decide which facts news readers should see and which narratives are correct for them. We trust our users to think for themselves, empowering them with tools to quickly and easily find whatever facts and narratives they are interested in.
            """,
            "Our informal privacy policy is “don’t be creepy”. We’re not trying to profit from you, and we'll never share or sell your data. You’ll find our full privacy policy [0].",
            // --------
            

            """
            If you’d like to support us with a donation, we hope to launch a donation page soon.\nIf you’d like to work for us, please email [0]. We hire for a wide variety of roles including those in software engineering, quality assurance, data curation, editorial, multimedia, social media and operations. If you have ideas or suggestions for improving our site or apps, please fill out this [1]. Thanks in advance!
            """,
            
            "This is work in progress, and as you can easily tell, there's lots of room for improvement! Please help us make it better by providing your feedback [0]."
        ]
        
        return data[index-1]
    }
    
    func images(_ index: Int) -> (UIImage, CGSize)? {
//        if(index==4) {
//            return (UIImage(named: "galileo")!, CGSize(width: 468, height: 175))
//        } else

//        if(index==5) {
//            return (UIImage(named: "einstein")!, CGSize(width: 1280, height: 216))
//        } else {
//            return nil
//        }

        return nil
    }
    
    func linkedTexts(_ index: Int) -> [String] {
        if(index == 2) {
            return ["this video"]
        } else if(index == 5) {
            return ["here", "here", "left", "right", "this"]
        } else if(index == 6) {
            return ["here", "here"]
        } else if(index == 7) {
            return ["here", "here"]
        } else if(index == 8) {
            return ["Recent work"]
        } else if(index == 9) {
            return ["Max Tegmark", "website", "iOS app", "Android app"]
        } else if(index == 12) {
            return ["here"]
        } else if(index == 13) {
            return ["contact@improvethenews.org", "feedback form"]
        }  else if(index == 14) {
            return ["here"]
        }
        
        return []
    }
    
    func urls(_ index: Int) -> [String] {
        if(index == 2) {
            return ["https://www.youtube.com/watch?v=PRLF17Pb6vo"]
        } else if(index == 5) {
            return ["https://arxiv.org/abs/2109.00024", "https://www.allsides.com/media-bias",
                    "https://en.wikipedia.org/wiki/Alternative_media_(U.S._political_left)",
                    "https://en.wikipedia.org/wiki/Alternative_media_(U.S._political_right)",
                    "https://swprs.org/media-navigator/"]
        } else if(index == 6) {
            return ["https://www.improvethenews.org/story/2022/scotus-blocks-revised-state-map-for-wisconsin",
                    "https://arxiv.org/abs/2109.00024"]
        } else if(index == 7) {
            return ["https://apps.apple.com/us/app/improve-the-news/id1554856339",
                    "https://play.google.com/store/apps/details?id=com.improvethenews.projecta&pli=1"]
        } else if(index == 8) {
            return ["https://psyarxiv.com/29b4j"]
        } else if(index == 9) {
            return ["https://space.mit.edu/home/tegmark/home.html", "https://www.improvethenews.org/",
                    "https://apps.apple.com/us/app/improve-the-news/id1554856339",
                    "https://play.google.com/store/apps/details?id=com.improvethenews.projecta&pli=1"]
        } else if(index == 12) {
            return ["local://privacyPolicy"]
        } else if(index == 13) {
            return ["mailto:contact@improvethenews.org", "local://feedbackForm"]
        }  else if(index == 14) {
            return ["local://feedbackForm"]
        }
        
        return []
    }

}
