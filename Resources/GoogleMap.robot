*** Settings ***
Library    RequestsLibrary
Library    XML
Library    String
Library    Collections


*** Keywords ***
Postcode should match city in XML response
    [Arguments]    ${postal_code}    ${expected_city}
    Create Session    googleapi    http://maps.googleapis.com/

    # Make the request and verify return code
    ${response}=    Get Request     googleapi    maps/api/geocode/xml?address=${postal_code},Finland
    Should Be Equal    ${response.status_code}     ${200}
    # Parse response to XML element structure
    Log  ${response}
    ${xml_response}=    Parse XML    ${response.text}

    # Get and assert element 'status' from the XML structure
    ${status_element}=    Get Element Text    ${xml_response}    status
    Should Be Equal As Strings    ${status_element}    OK

    # Verify that the expected city name can be found from the 'formatted_address' element
    ${returned_address}=     Get Element Text    ${xml_response}     result/formatted_address
    ${returned_city}=    Fetch City From Formatted Address    ${returned_address}

    Should Be Equal As Strings    ${returned_city}    ${expected_city}
    Delete All Sessions


Postcode should match city in JSON response
    [Arguments]    ${postal_code}    ${expected_city}
    Create Session    googleapi    http://maps.googleapis.com/
    # Make the request and verify return code
    ${response}=    Get Request     googleapi    maps/api/geocode/json?address=${postal_code},Finland
    Should Be Equal    ${response.status_code}    ${200}
#    Log  ${response.json}

    # Get and assert element 'status' from the JSON dictionary
    ${status_element}=    Get From Dictionary       ${response.json()}    status
    Should Be Equal As Strings    ${status_element}    OK

    # Verify that the expected city name can be found from the 'formatted_address' element
    ${returned_address}=    Set Variable    ${response.json()['results'][0]['formatted_address']}
    ${returned_city}=    Fetch City From Formatted Address    ${returned_address}

    Should Be Equal As Strings    ${returned_city}    ${expected_city}
    Delete All Sessions

Fetch City From Formatted Address
    [Arguments]    ${raw_address}
    ${addr}=    Fetch From Left    ${raw_address}    ,
    ${addr}=    Fetch From Right    ${addr}    ${SPACE}
    [Return]    ${addr}
