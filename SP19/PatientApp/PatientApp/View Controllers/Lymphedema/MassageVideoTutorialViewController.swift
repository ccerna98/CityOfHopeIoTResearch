//
//  MassageVideoTutorialViewController.swift
//  PatientApp
//
//  Created by Engineering on 4/17/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//

import UIKit
import WebKit

class MassageVideoTutorialViewController: UIViewController, UIScrollViewDelegate {

    //connects code to objects on storyboard
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!

    
    //subviews
    let headerView = Header()
    
    //private variables
    private let colorTheme = UIColor(named: "purple")!


            var slides:[Slide] = [];
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                //initializes slides from Slide.swift
                slides = createSlides()
                setupSlideScrollView(slides: slides)
                
                pageControl.numberOfPages = slides.count
                pageControl.currentPage = 0
            
                //puts pageControl onto of scroll view (can't do this in storyboard because then the scrollView will not scroll
                view.bringSubviewToFront(pageControl)
                
                //create the nice header with the necessary constraints
                headerView.updateHeader(text: "Massage Tutorials", color: hsbShadeTint(color: colorTheme, sat: 0.25), fsize: 30)
                self.view.addSubview(headerView)
                headerView.translatesAutoresizingMaskIntoConstraints = false
                headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
                headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            }

            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
            }

            
            func createSlides() -> [Slide] {
                
                //this is to print the descriptions and upload the youtube videos. To add addition youtube videos, just copy and add an additional slide
                let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
                slide1.webView.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/KsJUbY0c324")!))
                slide1.labelTitle.text = "Arm Lymphatic Drainage"
                slide1.labelDesc.text = "Your lymphatic system helps eliminate your body’s waste. A healthy, active lymphatic system uses the natural movements of smooth muscle tissue to do this. If you’ve ever had a surgery on or involving your lymph nodes, your doctor may have suggested lymphatic drainage massage. Above is a video tutorial providing instruction on how to do manual lymphatic drainage in the arms."
                
                let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
                slide2.webView.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/87NdIiSnOjA")!))
                slide2.labelTitle.text = "Leg Lymphatic Drainage"
                slide2.labelDesc.text = "Your lymphatic system helps eliminate your body’s waste. A healthy, active lymphatic system uses the natural movements of smooth muscle tissue to do this. If you’ve ever had a surgery on or involving your lymph nodes, your doctor may have suggested lymphatic drainage massage. Above is a video tutorial providing instruction on how to do manual lymphatic drainage in the legs."
                
        
                //remember to return any additional slides you add
                return [slide1, slide2]
            }
            
            
            func setupSlideScrollView(slides : [Slide]){
                //constrains scrollview on view controller
                scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
                scrollView.isPagingEnabled = true
                
                //creates subviews for each of the different slides that are create in Slide.swift
                for i in 0 ..< slides.count {
                    slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
                    scrollView.addSubview(slides[i])
                }
            }
            
            
            func scrollViewDidScroll(_ scrollView: UIScrollView) {

                // establish page control indexing
                let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
                pageControl.currentPage = Int(pageIndex)
                
                // horizontal
                let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
                let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
                let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
                
                //stop scrolling in the vertical direction
                    if scrollView.contentOffset.y != 0 {
                        scrollView.contentOffset.y = 0
                    }
                
                //changes the pageControl colors as user scrolls
                self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
            }
            
            
            
            
            func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
                if(pageControl.currentPage == 0) {
                    
                    let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 200/255, toGreen: 200/255, toBlue: 200/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                    pageControl.pageIndicatorTintColor = pageUnselectedColor
                
                    
                    let pageSelectedColor: UIColor = fade(fromRed: 100/255, fromGreen: 0/255, fromBlue: 100/255, fromAlpha: 1, toRed: 100/255, toGreen: 0/255, toBlue: 100/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                    pageControl.currentPageIndicatorTintColor = pageSelectedColor
                }
            }
            
            
            func fade(fromRed: CGFloat,
                      fromGreen: CGFloat,
                      fromBlue: CGFloat,
                      fromAlpha: CGFloat,
                      toRed: CGFloat,
                      toGreen: CGFloat,
                      toBlue: CGFloat,
                      toAlpha: CGFloat,
                      withPercentage percentage: CGFloat) -> UIColor {
                
                let red: CGFloat = (toRed - fromRed) * percentage + fromRed
                let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
                let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
                let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
                
                // return the fade colour
                return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
        }
