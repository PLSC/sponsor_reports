import os
import subprocess

if __name__=="__main__":
    # build filepath
    r_script = os.getcwd() + '/fetch_from_redshift.R'
    print('calling script from:', r_script)

    # run query via R
    script_cmd = 'Rscript ' + r_script
    resp = subprocess.check_output(script_cmd, shell=True)

    # print(response_df)
    print(resp.decode('utf-8'))
