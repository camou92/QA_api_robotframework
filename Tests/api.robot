*** Settings ***
Resource  ../Resources/signupBack.robot
Resource  ../Resources/loginBack.robot
Resource  ../Resources/variables.robot

*** Test Cases ***
Inscrire un utilisateur dans la BD
    [Tags]  First
    signupBack.Verifier si l'utilisateur n'existe pas dans la BD
    signupback.Inscription utilisateur par une requete Http POST
    signupBack.Verifier que l'utilisateur est ajouté dans la BD
    #signupBack.Inscription meme utilisateur par une requete Http POST
    #signupBack.Verifier que l'utilisateur n'est pas dupliqué dans la BD

Authentifier utilisateur
    [Tags]  Second
    loginBack.Verifier que l'utilisateur existe dans la BD
    loginBack.Authentifier utilisateur dans l'application

Supprimer Utilisateur
    [Tags]    Third
    loginBack.Supprimer Utilisateur de la BD
    loginBack.Authentifier utilisateur inexistant dans l'application