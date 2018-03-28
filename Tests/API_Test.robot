*** Settings ***
Documentation  Basic API test on Google Map
Resource  ../Resources/GoogleMap.robot


*** Variables ***


*** Test Cases ***
Postcode repose with its city
    [Tags]  API
   Postcode should match city in JSON response  20250  Turku
   Postcode should match city in JSON response  02200  Espoo
#    Postcode should match city in XML response    00500    Helsinki
#    Postcode should match city in XML response    33100    Tampere
