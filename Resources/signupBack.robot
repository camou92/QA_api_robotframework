*** Settings ***
Library  SeleniumLibrary
Library  RequestsLibrary
Library  DatabaseLibrary
Resource  variables.robot

*** Keywords ***
Verifier si l'utilisateur n'existe pas dans la BD
    Connect To Database Using Custom params    pymysql    database='demo', user='root', password='', host='localhost'
    Row Count Is 0    select id from users where username = '${USERNAME}' and password = md5('${PASSWORD}')

Inscription utilisateur par une requete Http POST
    Create Session    session1    ${WEBSITE_LINK}
    ${data} =  Create Dictionary    username=${USERNAME}  password=${PASSWORD}
    ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${response} =  Post Request  session1  signup.php  data=${data}  headers=${headers}
    ${json} =  Set Variable  ${response.json()}
    Log    ${json}
    Should Be Equal As Strings  ${response.status_code}  200

Verifier que l'utilisateur est ajouté dans la BD
    Connect To Database Using Custom params    pymysql    database='demo', user='root', password='', host='localhost'
    row count is equal to x    select id from users where username = '${USERNAME}' and password = md5('${PASSWORD}')     1

Inscription meme utilisateur par une requete Http POST
    Create Session    session2    ${WEBSITE_LINK}
    ${data} =  Create Dictionary    username=${USERNAME}  password=${PASSWORD}
    ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${response} =  Post Request  session2  signup.php  data=${data}  headers=${headers}
    ${json} =  Set Variable  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Be Equal As Strings  ${json['message']}  Username already exists!

Verifier que l'utilisateur n'est pas dupliqué dans la BD
    Connect To Database Using Custom params    pymysql    database='demo', user='root', password='', host='localhost'
    row count is equal to x    select id from users where username = '${USERNAME}' and password = md5('${PASSWORD}')     1