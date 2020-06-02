Set-Location C:\Scripts\Module7
git init MergeConflict
cd .\MergeConflict
"adding some text to the file" | Out-File -Encoding Ascii file1.txt
git add . ; git commit -m 'First commit in master' ; git checkout -b conflictbranch
"changing the text in the file in the conflict branch" | Out-File -Encoding Ascii -Append "file1.txt"
git add . ; git commit -m 'Modified file' ; git checkout master
"changing the text in the file in the master branch" | Out-File -Encoding Ascii "file1.txt"
git add . ; git commit -m 'Modified file in master' ; git merge conflictbranch