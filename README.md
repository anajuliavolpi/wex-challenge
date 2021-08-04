# WEX Challenge


This is a challenge for QA position at WEX Inc. It consists in developing a Robot script that execute the following test cases:  
<br>

```
[Test Setup]
	Open Browser on "www.google.com"
	Search for "Amazon Brasil" and Search
	Navigate to "www.amazon.com.br" Through The Search Page


15% Of Shown Products Should Be Exclusively The Searched Product (Starts With)
	Search For "Iphone" Using The Search Bar
	Count The Total List Of Found Products
    Count Items which its name starts with "Iphone”
	Make Sure At Least "15"% Of Items Found has its name starting with "Iphone”


The Higher Price In The First Page Can't Be Greater Than EUR$2000
	Search For "Iphone" Using The Search Bar
	Find The The Most Expensive Item which its name starts with "Iphone”
	Convert Its Value To EUR Using https://exchangeratesapi.io/ API
	Make Sure The Converted Value Is Not Greater Than EUR$"2000"


Products Different Than The Searched Product Should Be Cheaper Than The Searched Product
	Search For "Iphone" Using The Search Bar
	Find Items which its name doesn’t start with "Iphone”
	Make Sure All Found Products Are Cheaper Than The Cheapest Item which its name starts with "Iphone"
```
<br>

## Built With

The project was built using [Robot Framework](https://github.com/robotframework/robotframework) and some of its libraries:

* [Selenium2Library](https://robotframework.org/Selenium2Library/Selenium2Library.html)
* [BuiltIn](https://robotframework.org/robotframework/latest/libraries/BuiltIn.html)
* [String](https://robotframework.org/robotframework/latest/libraries/String.html)
* [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests)
* [Collections](https://robotframework.org/robotframework/latest/libraries/Collections.html)
  
It also uses [Exchange Rates API](https://exchangeratesapi.io/) to obtain real-time and reliable  exchange rate data for BRL currency.


---
### Ana Júlia Volpi

* anajuliavolpi45@gmail.com
* [LinkedIn](http://linkedin.com/in/ana-julia-volpi/)
* +55 47 992087171
