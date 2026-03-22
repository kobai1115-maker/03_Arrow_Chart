Write-Host "Downloading sqlite3.wasm..."
Invoke-WebRequest -Uri "https://github.com/simolus3/sqlite3.dart/releases/latest/download/sqlite3.wasm" -OutFile "web/sqlite3.wasm"

Write-Host "Downloading drift_worker.js..."
Invoke-WebRequest -Uri "https://github.com/simolus3/drift/releases/latest/download/drift_worker.js" -OutFile "web/drift_worker.js"

Write-Host "Setup complete."
