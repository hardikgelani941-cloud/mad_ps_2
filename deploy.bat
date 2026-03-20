@echo off
echo 🚀 Starting High-Speed Web Build...
call flutter build web --release

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed! Please check for code errors.
    pause
    exit /b %ERRORLEVEL%
)

echo ✅ Build Complete! Moving to web folder...
cd build\web

echo ☁️ Uploading to Vercel...
call vercel --prod --yes

echo 🎉 Project is LIVE! 
echo 🔗 Copy the URL above and add it to Firebase Authorized Domains.
pause
