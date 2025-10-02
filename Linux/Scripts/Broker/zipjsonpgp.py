import datetime
import os
import subprocess
import smtplib
from email.mime.text import MIMEText

def zip_json_and_pgp_files():
    now = datetime.datetime.now().strftime("%m%d%Y-%H%M")
    log_file_path = "/tmp/log.log"

    # Clear the log file
    with open(log_file_path, 'w') as f:
        f.write("")

    folder_paths = [
        "/WebSphere/s21iblocal/dev/canonID/output/json/mqsiarchive",
        "/WebSphere/s21iblocal/dev/canonID/input/gpg/mqsiarchive",
        "/WebSphere/s21iblocal/dev/canonID/input/json/mqsiarchive"
    ]

    for path in folder_paths:
        try:
            os.chdir(path)
            with open(log_file_path, 'a') as log_f:
                log_f.write(f"\nExecuting at Date : {now} ------------------------------ Folder : {path}\n")

                # Number of json files before Zip
                log_f.write("\nNumber of json files before Zip\n")
                result_before = subprocess.run(f"ls -lrt {path}/*json* | wc -l", shell=True, capture_output=True, text=True)
                log_f.write(result_before.stdout)

                # Zip json files
                zip_command = f"zip -m {now}.zip *json*"
                subprocess.run(zip_command, shell=True, stdout=log_f, stderr=log_f)

                # Number of json files after Zip
                log_f.write("\nNumber of json files after Zip\n")
                result_after = subprocess.run(f"ls -lrt {path}/*json* | wc -l", shell=True, capture_output=True, text=True)
                log_f.write(result_after.stdout)

                # List of zip files
                log_f.write("\nList of zip files\n")
                result_zip_list = subprocess.run(f"ls -lrt {path}/*.zip", shell=True, capture_output=True, text=True)
                log_f.write(result_zip_list.stdout)

        except Exception as e:
            with open(log_file_path, 'a') as log_f:
                log_f.write(f"\nError processing {path}: {e}\n")

    # DSpace of WebSphere
    with open(log_file_path, 'a') as log_f:
        log_f.write("\n DSpace of WebSphere-----------------------------------\n")
        df_result = subprocess.run("df -h | grep -i websphere", shell=True, capture_output=True, text=True)
        log_f.write(df_result.stdout)

    # Email the log file
    with open(log_file_path, 'r') as f:
        log_content = f.read()

    sender_email = "zipjsonpgp_noreply@cusa.canon.com"
    receiver_email = "q17020@cusa.canon.com"
    hostname = subprocess.run("hostname -a", shell=True, capture_output=True, text=True).stdout.strip()
    subject = f"{hostname} :zipjsonpgpFiles"

    msg = MIMEText(log_content)
    msg["Subject"] = subject
    msg["From"] = sender_email
    msg["To"] = receiver_email

    try:
        # Assuming a local SMTP server or configured mail client.
        # For external SMTP servers, you'd need to configure host, port, credentials.
        with smtplib.SMTP("localhost") as server:
            server.send_message(msg)
        print(f"Email sent successfully to {receiver_email}")
    except Exception as e:
        print(f"Failed to send email: {e}")

if __name__ == "__main__":
    zip_json_and_pgp_files()

# To schedule this script to run every hour, you would typically use cron on Linux/Unix systems.
# The cron entry would look similar to the original:
# 0 * * * * /usr/bin/python3 /path/to/your/script.py >/dev/null 2>&1
# Make sure to replace '/usr/bin/python3' with the actual path to your Python interpreter
# and '/path/to/your/script.py' with the actual path to this Python script.