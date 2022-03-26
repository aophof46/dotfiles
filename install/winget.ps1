$apps = @(
"7zip.7zip",
"balena.etcher",
"microsoft.windowsterminal",
"Microsoft.VisualStudioCode",
"valve.steam",
#"Spotify.Spotify",
"notepad++.notepad++",
"Git.Git",
"Github.Desktop",
"Logitech.UnifyingSoftware"
)

foreach($app in $apps) {

write-host "Installing: $app"
& winget install $app

}
