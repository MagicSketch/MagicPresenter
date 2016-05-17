mkdir -p Logs

echo "Building Release Version of MagicPresenter"

xctool -scheme MagicPresenter -configuration Release > Logs/1-xcode.log

echo "Creating MagicPresenter.dmg"

rm MagicPresenter.dmg
appdmg release.json MagicPresenter.dmg > Logs/2-dmg.log

# echo "Creating MagicPresenter.zip"
# zip -r MagicPresenter.zip MagicPresenter.dmg > Logs/3-zip.log
# zip -r MagicPresenter.zip *.sketchplugin coscript test.sh RunTests.js README.md MagicPresenter.sketch install.sh > Logs/2-zip.log


# git tag -a "v1.0" -m "Initial Public Release"

# git push --tags

