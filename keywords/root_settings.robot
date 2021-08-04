*** Settings ***
Library     Selenium2Library    run_on_failure=Capture Page Screenshot      screenshot_root_directory=${SCREENSHOTDIR}
Library     String
Library     Collections
Library     RequestsLibrary

*** Variables ***
${SCREENSHOTDIR}    ./Screenshots/
