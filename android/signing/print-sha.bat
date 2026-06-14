@echo off
REM Prints app debug/release SHA from Gradle signingReport
cd /d "%~dp0\.."
echo === Visai signingReport ===
call gradlew.bat :app:signingReport
echo.
echo === Play Store ===
echo Copy App signing key SHA-1/256: play.google.com/console/developers/app/keymanagement
echo   or Test and release - Setup - App signing
echo Update: android\signing\sha_fingerprints.json - playStoreAppSigning
echo Doc:   android\signing\SHA_FINGERPRINTS.md
