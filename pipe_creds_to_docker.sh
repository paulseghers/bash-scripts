# FOR SAVING TIME IN LOCAL DEVELOPMENT ONLY
# PLEASE DON'T DO THIS IN PRODUCTION CODE,
# THAT WOULD BE VERY STUPID

#assumes things. if yo uknow, you know

raw_creds=~/.aws/credentials
#!/bin/sh
awk 'NR==2, NR==5 {printf "-e %s=\x27%s\x27\n",  toupper($1), $NF}' $raw_creds
