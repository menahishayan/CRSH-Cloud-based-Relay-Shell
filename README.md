# CRSH - Cloud-based Relay Shell
Terminal Shell access via interaction relaying using a cloud service. Serves as a workaround for ISP port forward blocking.

Allows access to the bash terminal of a remote system (on a different network) without Port forwarding.

## Dependencies
[Dropbox Uploader](https://github.com/andreafabrizi/Dropbox-Uploader)

## Setup
 - Place `crsh_server.sh` anywhere on the server and `crsh.sh` in the client (preferrably at `/usr/local/bin`)
 - Make sure a copy of `dropbox_uploader.sh` is present in the same directory.
 - In `crsh_server.sh` change `DIR` to the path of your dropbox_uploader.
 - Setup dropbox_uploader: `dropbox_uploader.sh`
 - Create tmp directory if needed.
 - Ensure execute permissions on script: `chmod 777 /path/crsh*.sh`
 - Set up a cronjob on the server to run crsh_server.sh every few minutes:
    - `nano /etc/crontab`
    -  Eg (to run every 3 minutes, Monday to Friday, 8 AM to 6 PM) Write `*/3 8-18 * * 1-5 root /bin/bash /path/crsh_server.sh` to the end of the file
    - Save and exit `Ctrl+O` `Ctrl+X`

## Usage
 - Run `crsh.sh` on the client and at the prompt, enter the command.
 - If your server is currently listening (if you happen to catch it at the right minute), you should see your ouput in about a few seconds (depending on your network)
 - If your not sure if your server is listening or not, just enter your command and exit. Server will send the output whenever it listens next and the next time you run `crsh.sh` on your client, you should automatically see the output.
 - Always remember to exit the script using `exit` command. This cleans up the temporary files.

## v0.1 Release Notes
- Currently in beta and very loosely implemented
- Interaction is currently unidirectional (crsh.sh sends requests, crsh_server.sh responds). You can extend this functionality if you like.
- Not all commands are supported. Only commands that directly print to stdout are currently supported. Functionality for commands like vi and nano or ssh has not been tested.
- I've set my cronjob to every 3 minutes, the script listens on the network for about 1 minute straight. Increasing the listening frequency may create unnecessary load on the server. Reducing it will affect response time of crsh.

<hr/>

Feel free to fork it and improve on it. I'd be happy to collaborate!
