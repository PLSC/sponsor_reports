### Setup
This code needs an `.Renviron` to run, should look like this:

```
# redshift + postgres credentials
DBNAME=prod
HOST=medqip-workgroup.xxxxxxxxxx.us-east-1.redshift-serverless.amazonaws.com
PORT=xxxx
USER=xxxxxxxxxx
PASSWORD=xxxxxxxxxx

# s3 credentials
AWS_ACCESS_KEY_ID=xxxxxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxxxxx
AWS_DEFAULT_REGION=xxxxxxxxxx
```

You can get one like it from `medqip.connect`.

### Running the code
The calling the Python function will trigger the R script, and return the result to python for printing. Relative paths should be used to call up from your current directory. Just a proof of concept.

```
python trigger_r_script.py
```

### Purpose
We'll use this code as a sketch for integrating Andy's Simpl 2 modeling work into the `medqip-etl` process. This is a toy, but conceptually what we need to do is trigger an R job and wait for a response code in return. Anticipated complications:
* Async and total wait time
* Placing a call to another machine (Lambda? Ssh? Referring to a shared resource in a db for a status code?)
* Handling failure in the R application
* Definiting arguments to pass in and return