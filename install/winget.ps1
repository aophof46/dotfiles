$apps = @(
"7zip.7zip",
"balena.etcher",
"microsoft.windowsterminal",
"Microsoft.VisualStudioCode",
"Microsoft.BingWallpaper",
"valve.steam",
"Spotify.Spotify",
"notepad++.notepad++",
"Git.Git",
"Github.Desktop",
"Logitech.UnifyingSoftware",
"Ultimaker.Cura"
)

foreach($app in $apps) {

write-host "Installing: $app"
& winget install $app

}
