function Say-Hello {
    "Hello"
}

for ($i = 10; $i -gt 0; $i--) {
    1/$i
    if ($i -eq 1) {Say-Hello}
}
