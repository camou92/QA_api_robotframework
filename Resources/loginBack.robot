*** Settings ***
Library  SeleniumLibrary
Library  RequestsLibrary
Library  DatabaseLibrary
Resource  variables.robot

*** Keywords ***
Verifier que l'utilisateur existe dans la BD
    Connect To Database Using Custom params    pymysql    database='demo', user='root', password='', host='localhost'
    row count is equal to x    select id from users where username = '${USERNAME}' and password = md5('${PASSWORD}')     1

Authentifier utilisateur dans l'application
    Create Session    session3    ${WEBSITE_LINK}
    ${response} =    Get Request    session3    login.php?username=${USERNAME}&password=${PASSWORD}
    ${json} =    Set Variable    ${response.json()}
    log    ${json}
    should be equal as strings    ${response.status_code}    200
    should be equal as strings    ${json['message']}    Successfully Login!

Supprimer Utilisateur de la BD
    connect to database using custom params    pymysql    database='demo', user='root', password='', host='localhost'
    execute sql string    DELETE FROM users WHERE username = '${USERNAME}' and password = md5('${PASSWORD}')
    disconnect from database

Authentifier utilisateur inexistant dans l'application
    Create Session    session4    ${WEBSITE_LINK}
    ${response} =    Get Request    session4    login.php?username=${USERNAME}&password=${PASSWORD}
    ${json} =    Set Variable    ${response.json()}
    should be equal as strings    ${response.status_code}    200
    should be equal as strings    ${json['message']}    Invalid Username or Password!

