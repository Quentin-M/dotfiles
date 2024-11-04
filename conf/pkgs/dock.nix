{ isPro ? false }:

let
    home = [
        "/Applications/Brave Browser.app"
        "/System/Applications/Mail.app"
        "/Applications/ChatGPT.app"
        "/Applications/Microsoft OneNote.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/iTerm.app"
        "/Applications/Monodraw.app"
        "/Applications/Raycast.app"
        "/Applications/Bruno.app"
    ];

    pro = [
        "/Applications/Brave Browser.app"
        "/Applications/Google Chrome.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Mail.app"
        "/Applications/Slack.app"
        "/Applications/ChatGPT.app"
        "/Applications/Microsoft OneNote.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/iTerm.app"
        "/Applications/Postico 2.app"
        "/Applications/TablePlus.app"
        "/Applications/Monodraw.app"
        "/Applications/Raycast.app"
        "/Applications/Bruno.app"
    ];

in (if isPro then pro else home)