Set-Location C:\Scripts\Module7
git init WrongBranch
cd .\WrongBranch
"This is for the master branch" | Out-File -Encoding Ascii file1.txt
git add . ; git commit -m 'First commit in master' ; git checkout -b dev
"This is for the dev branch" | Out-File -Encoding Ascii "file1.txt"
git add . ; git commit -m 'First commit in dev' ; git checkout master
"This is meant to be for the dev branch" | Out-File -Encoding Ascii -Append "file1.txt"
git checkout dev