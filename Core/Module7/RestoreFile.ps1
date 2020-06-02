Set-Location C:\Scripts\Module7
git init RestoreFile
cd .\RestoreFile
"Start of File" | Out-File -Encoding Ascii file1.txt
for ($i = 1; $i -lt 10; $i++) {

    "Writing out line $i" | Out-File -Encoding Ascii file1.txt -Append
    git add . ; git commit -m "Commit $i"
}