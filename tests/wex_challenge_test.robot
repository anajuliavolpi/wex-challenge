*** Settings ***
Resource	init.robot

Suite Setup	SUITE:Setup
Suite Teardown	SUITE:Teardown

*** Variables ***
${GOOGLE_URL}       http://www.google.com/
${SEARCH_TERM}      Amazon Brasil

# API Variables
${API_KEY}          afd9e9620c34b5c655ec256bbd8d972f
${API_ENDPOINT}     http://api.exchangeratesapi.io/v1
${API_ARGS}         /latest?access_key=${API_KEY}&format=1/

*** Test Cases ***
15% Of Shown Products Should Be Exclusively The Searched Product (Starts With)
    SUITE:Search    id=twotabsearchtextbox  Iphone
    Sleep   8s
    ${COUNT}=   Get Element Count   xpath=//div[starts-with(@class, "sg-col-4-of-12 s-result-item s-asin sg-col-4-of-16")]
    Log To Console  \n=============== OUTPUT ===============
    Log To Console  \n>> Total of found products: ${COUNT}
    @{IPHONE_LIST}=    SUITE:Get List Of Products  ${TRUE}  ${COUNT}
    ${COUNT_IPHONE}=    Get Length  ${IPHONE_LIST}

    ${ITEMS_FOUND}=    Evaluate    ${COUNT}*0.15
    Log To Console  \n>> 15% of found products: ${ITEMS_FOUND}
	${AT_LEAST_15PERCENT}=     Run Keyword And Return Status      Should Be True   ${COUNT_IPHONE} > ${ITEMS_FOUND}

    Log To Console      \n>> Total of products starting with Iphone: ${COUNT_IPHONE}
	Run Keyword If      ${AT_LEAST_15PERCENT} == ${TRUE}     Log To Console      \n>> At least 15% of items found has its name starting with Iphone
	...     ELSE    Log To Console      \n>> Less than 15% of items found has its name starting with Iphone
    Log To Console  \n======================================\n

The Higher Price In The First Page Can't Be Greater Than EUR$2000
    SUITE:Search    id=twotabsearchtextbox  Iphone
    Sleep   8s
    ${COUNT}=   Get Element Count   xpath=//div[starts-with(@class, "sg-col-4-of-12 s-result-item s-asin sg-col-4-of-16")]
    Log To Console  \n=============== OUTPUT ===============
    Log To Console  \n>> Total of found products: ${COUNT}
    @{IPHONE_LIST}=    SUITE:Get List Of Products  ${TRUE}  ${COUNT}
    ${MAX_VALUE}=    Evaluate    max(@{IPHONE_LIST})
    Log to Console  \n>> Most expensive Iphone: R$${MAX_VALUE}
    SUITE:API Call                                           #Make API Call
    SUITE:BRL Currency      ${RESPONSE}                      #Get BRL Currency
    ${EUR_PRICE}=    SUITE:Convert     ${MAX_VALUE}          #Convert to EUR
    ${EUR_PRICE}=   Evaluate    round(${EUR_PRICE},2)
    Log To Console  \n>> BRL Price: R$${MAX_VALUE} | EUR Price: EUR$${EUR_PRICE}
    Run Keyword If      ${EUR_PRICE} <= 2000     Log To Console      >> The Iphone price is not greater than EUR$2000\n
    Log To Console  \n======================================\n

Products Different Than The Searched Product Should Be Cheaper Than The Searched Product
    SUITE:Search    id=twotabsearchtextbox  Iphone
    Sleep   8s
    ${COUNT}=   Get Element Count   xpath=//div[starts-with(@class, "sg-col-4-of-12 s-result-item s-asin sg-col-4-of-16")]
    Log To Console  \n=============== OUTPUT ===============
    Log To Console  \n>> Total of found products: ${COUNT}

    @{IPHONE_LIST}=    SUITE:Get List Of Products  ${TRUE}  ${COUNT}
    ${MIN_VALUE}=    Evaluate    min(@{IPHONE_LIST})
    Log to Console  \n>> Cheapest Iphone: R$${MIN_VALUE}

    @{NON_IPHONE_LIST}=    SUITE:Get List Of Products  ${FALSE}     ${COUNT}
    ${IS_CHEAPEST}=     Set Variable    ${TRUE}
    FOR     ${PRICE}    IN    @{NON_IPHONE_LIST}
        ${IS_CHEAPEST}=    Set Variable If   ${PRICE} > ${MIN_VALUE}    ${FALSE}    ${TRUE}
    END
    Run Keyword If  ${IS_CHEAPEST} == ${TRUE}   Log To Console  \n>> All found products are cheaper than the cheapest Iphone
    ...     ELSE    Log To Console  \n>> There is a product that is not cheaper than the cheapest iphone
    Log To Console  \n======================================\n

*** Keywords ***
SUITE:Setup
	Open Browser    ${GOOGLE_URL}
	SUITE:Search    name=q  ${SEARCH_TERM}
	Wait Until Element Is Visible    xpath=//cite[contains(.,'https://www.amazon.com.br')]
	Click Element    xpath=//cite[contains(.,'https://www.amazon.com.br')]

SUITE:Teardown
	Close Window

SUITE:Search
	[Arguments]     ${ELEMENT}  ${SEARCH_TERM}
	Wait Until Element Is Visible   ${ELEMENT}
	Input Text  ${ELEMENT}  ${SEARCH_TERM}
	Press Keys   ${ELEMENT}  ENTER

SUITE:API Call
    Create Session  getCurrencyRates    ${API_ENDPOINT}
    ${RESPONSE}=    Get On Session     getCurrencyRates    ${API_ARGS}
    Set Global Variable     ${RESPONSE}

SUITE:BRL Currency
    [Arguments]  ${CURR_RESPONSE}
    ${BRL_CURR}=   Get From Dictionary  ${CURR_RESPONSE.json()["rates"]}    BRL
    Set Global Variable     ${BRL_CURR}

SUITE:Convert
    [Arguments]  ${BRL_VALUE}
    ${EUR_PRICE}=   Evaluate    ${BRL_VALUE} / ${BRL_CURR}
    [Return]    ${EUR_PRICE}

SUITE:Get List Of Products
    [Arguments]     ${IPHONE}   ${COUNT}
    @{LIST}=    Create List
    FOR     ${I}    IN RANGE    ${COUNT}
        ${TEXT}=        Get Text    xpath=//div[@data-index="${I}"]//span[@class="a-size-base-plus a-color-base a-text-normal"]
        ${TEXT_FORMATTED}=  Convert to Lowercase    ${TEXT}
        ${STATUS}=    Run Keyword And Return Status   Get Text    xpath=//div[@data-index="${I}"]//span[@class="a-price-whole"]
        Continue For Loop If    ${STATUS} == ${FALSE}
        ${WHOLE}=       Get Text    xpath=//div[@data-index="${I}"]//span[@class="a-price-whole"]
        ${WHOLE_FORMATTED}=     Replace String  ${WHOLE}  .   ${EMPTY}
        ${FRACTION}=    Get Text    xpath=//div[@data-index="${I}"]//span[@class="a-price-fraction"]
        ${VALUE_}=   Catenate    SEPARATOR=.    ${WHOLE_FORMATTED}    ${FRACTION}
        ${VALUE}=   Convert to Number   ${VALUE_}

        ${START_WITH}=  Run Keyword And Return Status    Should Start With   ${TEXT_FORMATTED}    iphone
        # If Iphone -> should start with = TRUE
        # If not Iphone -> should start with = FALSE
        Run Keyword If  ${IPHONE} == ${TRUE} and ${START_WITH} == ${TRUE}   Append to List  ${LIST}    ${VALUE}
        ...     ELSE IF     ${IPHONE} == ${FALSE} and ${START_WITH} == ${FALSE}       Append to List  ${LIST}    ${VALUE}
    END
    [Return]    ${LIST}
