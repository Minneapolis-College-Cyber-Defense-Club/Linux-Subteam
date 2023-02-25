# Linux Sub-Team Repsoitory
Tools, scripts and files for Linux.  

Some notes:  
> how to make passwords:  
`python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(),crypt.mksalt(METHOD_SHA512)))'`

OR another method

`python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(), crypt.METHOD_SHA512))'`

https://stackoverflow.com/questions/41887491/python-usage-of-crypt-function  
