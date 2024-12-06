# Table of contents
General info, objectives <br>
Requirements, limitations <br>
Configuration, usage | Use case 1 | Integrate the rm_calendar with the rm_calendar_memo <br>
Configuration, usage | Use case 2 | Use any kind of document <br>
• optional configurations, debugging, notes <br>
Tested environments <br>
Project structure, file index <br>
References <br>

# ======== General info, objectives ====

* See this video demonstration: https://www.youtube.com/watch?v=YAz8Y30VeO0
* The "Calendar Memo" term has been borrowed from the Onyx Boox eink devices, since they have the similar kind of separate Android application, <br>
which allows to write useful notes for the specific date within the app, and then display the notes relevant to the current date of looking.
* The similar concept has been taken when designing the functionality of this implementation on the RMPP.

# ======== Requirements, limitations, features ====
**(LIMITATION)** The file `rm_calendar/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf` contains the PDF calendar, currently, until 28 February 2025. <br>
**(LIMITATION)** Once you update the file `rm_calendar/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf` , it's needed to reupload only that file to RMPP. <br>
**(FEATURE/LIMITATION)** The current implementation (scripts) is modifying the "suspended.png", by dynamically replacing it. <br>
In the script "periodically_update_suspended_png.sh" there is a line "sleep 5". It means that the frequency of those changes is 0.5 seconds. <br>
What's most important that there is a loop, that runs indefinitely. This is overall "good" and "bad". "Good" because it's performant, fast updates. <br>
"Bad" because it is not very efficient to keep on replacing the file all the time, even when we don't actually adding some notes to respected PNG. <br>
**(FEATURE/LIMITATIONS)** I have been reviewing the CPU and RAM consumption of the implementation-specific files, during the execution, using "top" tool, on RMPP. <br>
The CPU and RAM (%VSZ) consumptions were showing "0%"/"0%" almost all the time, for the respected scripts used, like so:
```
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
64838   849 root     R     3492   0%   0% top
59975     1 root     S     3720   0%   0% {periodically_up} /bin/bash /home/root/rm_calendar_memo/periodically_update_suspended_png.sh
```
Therefore, I did not notice any performance degradation when using RMPP, and/or in particularly writing on that particular document "Todo". <br>
**(FEATURE)** This implementation (scripts) does not require Internet or any kind of net to work, it works locally, on RMPP. <br>
The implementation does not send any data outside the RMPP. All the scripts files can be examined, they are created based on the official manuals. <br>
**(LIMITATIONS)** For the **"supported RM+versions"** refer to the "Tested environments" section of the current memo. <br>
**(REQUIRED/LIMITATION)** This implementation works only in "Dev mode" Make sure the "Developer mode" is enabled. Consult the **Reference 1** about it. <br>
**(REQUIRED)** Know your "<RMPP_SSH_ROOT_PASSWORD>" password for SSH. Consult the **Reference 1**, section "Accessing your reMarkable Paper Pro via SSH". <br>
**(REQUIRED)** "ssh" command available from the terminal. On MacOS it is available by default. For Windows consult **Reference 2**. <br>
**(REQUIRED)** Make sure you are aware how to enable the "USB Web interface" on RMPP. Consult **Reference 3**, section "How to enable USB transfer on your reMarkable" to get to know more about it. <br>

# ======== Configuration, usage | Use case 1 | Integrate the **rm_calendar** with the rm_calendar_memo ====
**On your Mac or Windows, unpack/extract/move the current project files and move them into the folder with the name "rm_calendar_memo". This folder name will be needed further.** <br>
See file of systemd service, where the path matters: https://github.com/anti22dot/rm_calendar_memo/blob/99898eec5ba9e86e26b640dcbc294bc0b8d367bf/rm_calendar_memo.service#L8
* <a name="use_case1_step_a"></a> **[Use case 1 | Step A](#use_case1_step_a)** Download the prebuild Node.js binaries from here https://nodejs.org/en/download/prebuilt-binaries <br>
**Make sure** to specify the **22.X** (at the time of this memo, 22.10), **"Linux"** as platform, **"ARM64"** as CPU architecture. <br>
**NOTE**: It's crucial to use the version of Node.js itself (**22.X**) that I've mentioend here, because there would be dependencies on it in my scripts. <br>
Hit on "Download `<YOUR_CHOSEN_VERSION>` button. Unpack that archive into the separate folder, **different from the current project**. <br>
For example, `<PATH_TO>/node-v22.11.0-linux-arm64` folder:
```
[bash Downloads]$ ls -ltra |grep node
drwxr-xr-x@  9 staff   288B Oct 29 02:33 node-v22.11.0-linux-arm64
-rw-r--r--@  1 staff    27M Nov 23 16:28 node-v22.11.0-linux-arm64.tar.xz
[bash Downloads]$ ls -ltra node-v22.11.0-linux-arm64
total 1064
drwxr-xr-x@ 4 staff   128B Oct 29 02:28 share
drwxr-xr-x@ 3 staff    96B Oct 29 02:28 lib
drwxr-xr-x@ 3 staff    96B Oct 29 02:31 include
drwxr-xr-x@ 6 staff   192B Oct 29 02:31 bin
-rw-r--r--@ 1 staff    39K Oct 29 02:33 README.md
-rw-r--r--@ 1 staff   136K Oct 29 02:33 LICENSE
-rw-r--r--@ 1 staff   354K Oct 29 02:33 CHANGELOG.md
drwxr-xr-x@ 9 staff   288B Oct 29 02:33 .
drwx------@ 9 staff   288B Nov 23 16:28 ..
```
* <a name="use_case1_step_b"></a> **[Use case 1 | Step B](#use_case1_step_b)** Connect your RMPP device to your Mac/Windows via the USB C cable. After that you need to make sure the "USB web interface" is enabled. Open "Terminal 1". 
After that, navigate to the "Settings" - "Storage" , and there would be section "USB web interface". <br>
Locate the IP address of your RMPP, written after the "http://". Note it down somewhere in your notepad as "<RMPP_IP_ADDRESS>". <br>
About "USB web interface" consult **Reference 3**. Open the terminal (let's label it "Terminal 1") on your Mac or Windows and execute these commands:
```
ssh root@<RMPP_IP_ADDRESS>
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
# If the password is correct, it would show to you the prompt of the RMPP:
root@<MY_RMPP_HOSTNAME>:~#
```
**NOTE**: For the **"ssh"** command itself make sure the "Requirements" have section have been reviewed, where it was mentioned about it. <br>
**NOTE**: The value of `<RMPP_SSH_ROOT_PASSWORD>` is visible from the "General > About > Copyrights and licenses" page of the RMPP itself. <br>
Once we have accessed the RMPP, let's also now execute this command to being able to write files into the system folders, as we would needed this later on:
```
umount -l /etc
mount -o remount,rw /
```

* <a name="use_case1_step_c"></a> **[Use case 1 | Step C](#use_case1_step_c)** Open "Terminal 2". Upload the Node.js runtime to the RMPP.
Previous steps have confirmed that you have the SSH connection from your MacOS or Windows to your RMPP device. <br>
In the further steps we would transfer the files using the SCP rather than Web UI, because we need to transfer them into the specific location. <br>
At this point, depending on the OS type, there can be used many tools to transfer the files using SFTP, consult **Reference 4**. <br>
In this manual I would be using tool called "scp", and would be using MacOS platform. Open another **"Terminal 2"**, navigate to folder with Node.js. <br>
From inside that folder let's execute this command:
```
[bash Downloads]$ pwd
/Users/<my_user_id>/Downloads
[bash Downloads]$ ls -ltra node-v22.11.0-linux-arm64
total 1064
drwxr-xr-x@ 4 staff   128B Oct 29 02:28 share
drwxr-xr-x@ 3 staff    96B Oct 29 02:28 lib
drwxr-xr-x@ 3 staff    96B Oct 29 02:31 include
drwxr-xr-x@ 6 staff   192B Oct 29 02:31 bin
-rw-r--r--@ 1 staff    39K Oct 29 02:33 README.md
-rw-r--r--@ 1 staff   136K Oct 29 02:33 LICENSE
-rw-r--r--@ 1 staff   354K Oct 29 02:33 CHANGELOG.md
drwxr-xr-x@ 9 staff   288B Oct 29 02:33 .
drwx------@ 9 staff   288B Nov 23 16:28 ..
scp -r ./node-v22.11.0-linux-arm64 root@<RMPP_IP_ADDRESS>:/home/root/
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
# After that, the entire folder (in my case "node-v22.11.0-linux-arm64") would be uploaded into RMPP under "/home/root/".
# It would take some time to do that, and it would display many lines, similar to this output:
...
no-tty.js                                         100%   44    44.3KB/s   00:00
file-exists.js                                    100%  663   548.7KB/s   00:00
is-windows.js                                     100%   46    51.8KB/s   00:00
LICENSE                                           100%  791   789.8KB/s   00:00
...
```
**NOTE**: The value of `<RMPP_SSH_ROOT_PASSWORD>` is visible from the "General > About > Copyrights and licenses" page of the RMPP itself. <br>

* <a name="use_case1_step_d"></a> **[Use case 1 | Step D](#use_case1_step_d)** In the existing "Terminal 1", verify the uploaded files. Modify ".env". In the "Terminal 2", upload the "rm_calendar_memo" folder. <br>
```
root@<MY_RMPP_HOSTNAME>:~# pwd
/home/root
root@<MY_RMPP_HOSTNAME>:~# ls -ltra |grep node
drwxr-xr-x    6 root     root          4096 Nov 23 15:47 node-v22.11.0-linux-arm64
root@<MY_RMPP_HOSTNAME>:~# ls -ltra node-v22.11.0-linux-arm64/
-rw-r--r--    1 root     root        139053 Nov 23 15:46 LICENSE
drwxr-xr-x    3 root     root          4096 Nov 23 15:46 include
drwxr-xr-x    2 root     root          4096 Nov 23 15:46 bin
-rw-r--r--    1 root     root        362490 Nov 23 15:46 CHANGELOG.md
drwxr-xr-x    3 root     root          4096 Nov 23 15:47 lib
-rw-r--r--    1 root     root         40117 Nov 23 15:47 README.md
drwxr-xr-x    4 root     root          4096 Nov 23 15:47 share
drwxr-xr-x    6 root     root          4096 Nov 23 15:47 .
drwx------   11 root     root          4096 Nov 23 15:50 ..
```
Also we need to give the executable bits to the "node" binary. Execute this command:
```
root@<MY_RMPP_HOSTNAME>:~# chmod +x node node-v22.11.0-linux-arm64/bin/*
```
Next, on your MacOS or Windows, open file ".env" inside the folder with the unpacked project files.
Provide the appropriate values to the following parameters, after the "=" sign, accordingly:
```
RM_CALENDAR_APP_DEBUG=false
CALENDAR_MEMO_ROOT=/home/root/rm_calendar_memo
TODAYS_TODO_NEW_ABSOLUTE_FILENAME=/usr/share/remarkable/suspended.png
NODE_ROOT=
# For the "ORIGINAL_DOC_HASH_ID" after the "=" there should be valid rm directory-specific HASH ID
# see "README.md". EXAMPLE: 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff
ORIGINAL_DOC_HASH_ID=430f8cdf-e2e8-412c-b7e3-5ebf3b126bff
# After the "=" there should be valid rm page-specific HASH ID, see "README.md".
# see "README.md". EXAMPLE: FILE_21_11_24=0537ae0b-1eb3-407e-b285-c02bdbee8af3
...
# Omitted further lines here.
...
```
**NOTE**: Do not modify the other variables. You only need to modify one variable here, **NODE_ROOT=**, which is path to "root" of the Node.js dir on RMPP. <br>
**NOTE**: For example, in my use case: **NODE_ROOT=/home/root/node-v22.11.0-linux-arm64**. <br>
Verify the project files, they should look similar to below:
```
[bash Downloads]$ ls -ltra |grep rm_calendar
drwxr-xr-x@  9 staff   288B Nov 23 17:07 rm_calendar_memo
[bash Downloads]$ ls -ltra rm_calendar_memo/
total 200
drwxr-xr-x@  5 staff   160B Oct 21 22:11 ..
-rw-r--r--   1 staff   3.8K Nov 23 20:32 periodically_update_suspended_png.sh
-rw-r--r--@  1 staff   324B Nov 23 20:33 open_composite_png.js
-rw-r--r--@  1 staff   249B Nov 23 20:33 open_resize_png.js
-rw-r--r--   1 staff    11K Nov 23 14:34 LICENSE
-rw-r--r--   1 staff   267B Nov 23 14:34 get_metadata.js
drwxr-xr-x  14 staff   448B Nov 23 14:34 node_modules
-rw-r--r--   1 staff    17K Nov 23 14:34 package-lock.json
-rw-r--r--@  1 staff    51B Nov 23 14:34 package.json
-rw-r--r--   1 staff     0B Nov 23 14:34 rm_calendar_memo.log
-rw-r--r--   1 staff   472B Nov 23 14:34 rm_calendar_memo.service
drwxr-xr-x  11 staff   352B Nov 23 15:31 calendars
-rw-r--r--@  1 staff   5.7K Nov 23 15:33 .env
drwxr-xr-x  17 staff   544B Nov 23 15:34 .
drwxr-xr-x@  9 staff   288B Nov 23 15:40 rm_calendar
-rw-r--r--@  1 staff    33K Nov 23 17:07 README.md
```
From MAC/WIN | It's now needed to transfer the entire dir **"rm_calendar_memo"** into the RMPP, under the **"/home/root/"**. In my use case I used "scp":
```
[bash Downloads]$ scp -r ./rm_calendar_memo root@<RMPP_IP_ADDRESS>:/home/root/
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
# After that, the entire folder "rm_calendar_memo" would be uploaded into RMPP under "/home/root/".
# It would take some time to do that.
```

* <a name="use_case1_step_e"></a> **[Use case 1 | Step E](#use_case1_step_e)** In the existing "Terminal 1", verify the uploaded files. Update permissions. Move the "rm_calendar_memo/rm_calendar" directory to xochitl. Start the service and enable it to start on the reboot.
```
root@<MY_RMPP_HOSTNAME>:~# ls -ltra
drwxr-xr-x    4 root     root          4096 Nov 23 13:52 ..
drwxr-xr-x    3 root     root          4096 Nov 23 13:52 .local
drwxr-xr-x    3 root     root          4096 Nov 23 13:52 .journal
drwxr-xr-x    3 root     root          4096 Nov 23 13:52 .cache
drwxr-xr-x    2 root     root          4096 Nov 23 13:56 .dropbear
drwx------    2 root     root          4096 Nov 23 14:25 .ssh
drwxr-xr-x    4 root     root          4096 Nov 23 18:49 .config
-rw-------    1 root     root         14419 Nov 23 15:48 .bash_history
drwxr-xr-x    3 root     root          4096 Nov 23 15:48 .memfault
-rw-------    1 root     root         21217 Nov 23 16:07 .viminfo
drwxr-xr-x    6 root     root          4096 Nov 23 16:42 node-v22.11.0-linux-arm64
drwx------   11 root     root          4096 Nov 23 18:33 .
drwxr-xr-x    3 root     root          4096 Nov 23 18:33 rm_calendar_memo
root@<MY_RMPP_HOSTNAME>:~# ls -ltra rm_calendar_memo/
-rw-r--r--    1 root     root           472 Oct 22 06:21 rm_calendar_memo.service
-rwxr-xr-x    1 root     root            51 Oct 22 06:21 package.json
-rwxr-xr-x    1 root     root         16909 Oct 22 06:21 package-lock.json
-rwxr-xr-x    1 root     root           267 Oct 22 06:21 get_metadata.js
-rwxr-xr-x    1 root     root         11357 Oct 22 06:21 LICENSE
-rwxr-xr-x    1 root     root         33835 Oct 29 17:49 README.md
drwxr-xr-x   14 root     root          4096 Nov 17 16:42 node_modules
-rw-r--r--    1 root     root            54 Nov 17 18:17 .vimrc
-rw-r--r--    1 root     root           324 Nov 21 19:33 open_composite_png.js
-rwxr-xr-x    1 root     root           249 Nov 21 19:33 open_resize_png.js
drwxr-xr-x    2 root     root          4096 Nov 21 20:11 calendars
-rwxr-xr-x    1 root     root          3864 Nov 23 16:20 periodically_update_suspended_png.sh
-rwxrwxrwx    1 root     root          5829 Nov 23 16:29 .env
-rwxrwxrwx    1 root     root          288B Nov 23 16:29 rm_calendar
-rwxrwxrwx    1 root     root         39321 Nov 23 16:29 rm_calendar_memo.log
```
Move the directory `rm_calendar_memo/rm-calendar` to the `/home/root/.local/share/remarkable/xochitl/` :
```
root@<MY_RMPP_HOSTNAME>:~# cd /home/root/rm_calendar_memo/rm_calendar
root@<MY_RMPP_HOSTNAME>:~# cp -R * /home/root/.local/share/remarkable/xochitl/
```
Then verify the directory `/home/root/.local/share/remarkable/xochitl/`:
```
root@<MY_RMPP_HOSTNAME>:~/.local/share/remarkable/xochitl# pwd
/home/root/.local/share/remarkable/xochitl
root@<MY_RMPP_HOSTNAME>:~/.local/share/remarkable/xochitl# ls -ltra
drwxr-xr-x    8 root     root          4096 Nov 21 19:46 ..
-rw-r--r--    1 root     root       4239569 Nov 21 21:40 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf
-rw-r--r--    1 root     root            34 Nov 21 21:40 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.local
-rw-r--r--    1 root     root           636 Nov 22 11:59 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pagedata
drwxr-xr-x    2 root     root          4096 Nov 23 16:16 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.thumbnails
drwxr-xr-x    2 root     root          4096 Nov 23 16:16 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff
-rw-r--r--    1 root     root           243 Nov 23 16:44 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.metadata
-rw-r--r--    1 root     root         50580 Nov 23 16:44 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content
drwxr-xr-x    4 root     root         20480 Nov 23 16:44 .
```
It's needed to give the right permissions to the application files:
```
chmod 755 /home/root/rm_calendar_memo/*
chmod 644 /home/root/rm_calendar_memo/rm_calendar_memo.service
```
Now, it's needed to copy the "rm_calendar_memo.service" into the SystemD directory of the RMPP, like so:
```
cp /home/root/rm_calendar_memo/rm_calendar_memo.service /usr/lib/systemd/system/rm_calendar_memo.service
```
Then, run these commands to check whether the service has been "recognized" by the SystemD, first:
```
root@<MY_RMPP_HOSTNAME>:~# systemctl status rm_calendar_memo.service
○ rm_calendar_memo.service - periodically update the remarkable paper pro suspended picture
     Loaded: loaded (/usr/lib/systemd/system/rm_calendar_memo.service; disabled; vendor preset: disabled)
     Active: inactive (dead) since Sun 2024-10-20 18:15:42 UTC; 25min ago
Warning: The unit file, source configuration file or drop-ins of rm_calendar_memo.service changed on disk. Run 'systemctl daemon-reload' to reload units.
```
Then run this command to reload the SystemD daemon:
```
systemctl daemon-reload
```
Then start the service, and check the status of it:
```
root@<MY_RMPP_HOSTNAME>:~# systemctl start rm_calendar_memo.service
root@<MY_RMPP_HOSTNAME>:~# systemctl status -l rm_calendar_memo.service
● rm_calendar_memo.service - periodically update the remarkable paper pro suspended picture
     Loaded: loaded (/usr/lib/systemd/system/rm_calendar_memo.service; enabled; vendor preset: disabled)
     Active: active (running) since Sun 2024-10-20 18:45:09 UTC; 1s ago
   Main PID: 59034 (periodically_up)
      Tasks: 2 (limit: 1588)
     Memory: 516.0K
     CGroup: /system.slice/rm_calendar_memo.service
             ├─ 59034 /bin/bash /home/root/rm_calendar_memo/periodically_update_suspended_png.sh
             └─ 59038 sleep 5

Nov 23 18:45:09 <MY_RMPP_HOSTNAME> systemd[1]: Started periodically update the remarkable paper pro suspended picture.
```
To make sure the scripts would run after the reboot, execute this command:
```
systemctl enable rm_calendar_memo.service
```

# ======== Configuration, usage | Use case 2 | Use case 2 | Use any kind of document ====
* The documentation is removed for this use case, for now. But it's possible. See earlier version 1.0.0, where it was present.

## ======== Optional, Debugging, Extras ====
**(OPTIONAL/DEBUGGING)** The frequency of the dynamic changes of the file "suspended.png" is set to "0.5 seconds", by default, but can be modified. <br>
To modify it open the file "periodically_update_suspended_png.sh" and change the value of the "sleep 0.5" command to your value of choice. <br>
* <a name="optional1"></a> **[Optinal procedure 1 | Enable the DEBUG logging:](#optional1)**
If you look into the ".env" file it has variable `RM_CALENDAR_APP_DEBUG`. This variable used for troubleshooting purposes. <br>
If set to the `true`, the "periodically_update_suspended_png.sh" would be writing logs into the "/home/root/rm_calendar_memo/rm_calendar_memo.log" file. <br>
Now, because the default frequency of the updates is "5 seconds", you can imagine, if leaving the device for 1-3 days, the log file can raise in size. <br>
After changing that environment variable value, it's needed to restart the SystemD service via this command `systemctl restart rm_calendar_memo`. <br>
So, it's useful for debugging purposes. Here is the sample output of the `rm_calendar_memo.log` when debug is enabled:
```
========
Right now is Sat Nov 23 16:28:54 UTC 2024. Searching for the /home/root/.local/share/remarkable/xochitl/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.thumbnails/e4013870-9f47-4dd8-a4aa-b33b4e726108.png file.
* The file /home/root/.local/share/remarkable/xochitl/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.thumbnails/e4013870-9f47-4dd8-a4aa-b33b4e726108.png exist.
* Creating the temporary copy of this file in the /home/root/rm_calendar_memo/ location:
cp /home/root/.local/share/remarkable/xochitl/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.thumbnails/e4013870-9f47-4dd8-a4aa-b33b4e726108.png /home/root/rm_calendar_memo/23.11.24.png
* Here is the metadata of that newly copied file:
{
  format: 'png',
  width: 281,
  height: 374,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
* Resizing this temporary copy:
node open_resize_png.js 23.11.24.png.png
* As the result the new resized file created. The new resized absolute filename: 23.11.24.new.png, and it's metadata:
{
  format: 'png',
  width: 1620,
  height: 2156,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
* Create the composited image by adding calendar image on top of the resized file of our TODO page:
node open_composite_png.js 23.11.24.new 23.11.24_calendar.png
* As the result the new composited file created with the filename: 23.11.24.new.composited.png, and it's metadata:
{
  format: 'png',
  width: 1620,
  height: 2156,
  space: 'srgb',
  channels: 4,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: true
}
* Copying the new resized file into the target location, while replacing the current 'suspended.png' file:
cp 23.11.24.new.composited.png /usr/share/remarkable/suspended.png
* Deleting the temporary copy of the original file, resized file, and the composited file:
rm -f 23.11.24.png 23.11.24.new.composited.png 23.11.24.new.composited.png
========
```
* <a name="optional2"></a> **[Optinal procedure 2 | Expand the PDF file:](#optional2)** <br>
**First | Use this step only if you have updated your existing PDF file, on the Windows/Mac/Linux and would like to update it on your RMPP** <br>
**Second | Also, make sure to only Extend the original PDF, and Not "cut" it, like do not remove existing pages, only add pages, if you need.** <br>
Check the instructions from the **Use case 1 | Step D** , but in this case, only reupload the single file **430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf** <br>
(do not re-upload the other files or folders)
```
[bash Downloads]$ scp -r 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf root@<RMPP_IP_ADDRESS>:/home/root/.local/share/remarkable/xochitl/
```
**NOTE**: The point is that the RMPP would store all the "strokes/markings" within the "430f8cdf-e2e8-412c-b7e3-5ebf3b126bff/" **directory itself**, <br>
and we are not touching that files, but only replacing the original PDF file. <br>
**Third**: It's needed to also update the **".env"** file with the new <HASH_ID>. For that, first, download the **.content** file from the RMPP: <br>
```
[bash Downloads]$ scp -r root@10.11.99.1:/home/root/.local/share/remarkable/xochitl/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content .
root@10.11.99.1's password:
[bash Downloads]$ scp root@10.11.99.1:/home/root/.local/share/remarkable/xochitl/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content .
root@10.11.99.1's password:
430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content                                                       100%   49KB  11.8MB/s   00:00
[bash Downloads]$ ls -ltra |grep 430
-rw-r--r--   1 staff    49K Nov 23 17:44 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content
```
**Fourth**: Open that file, and locate the line, which contains this `<HASH_ID>`: **9004cc86-a0d0-4da6-b663-04e8987423a5**, it would look like so:
```
            },
            {
                "id": "9004cc86-a0d0-4da6-b663-04e8987423a5",
                "idx": {
                    "timestamp": "1:2",
                    "value": "fb"
                },
                "redir": {
                    "timestamp": "1:2",
                    "value": 105
                },
                "template": {
                    "timestamp": "1:2",
                    "value": "Blank"
                }
            },
```
**NOTE**: This id **"9004cc86-a0d0-4da6-b663-04e8987423a5"** is related to the page **106** - **28 February 2025**, as of today's writing (**22 Nov**). <br>
**NOTE**: If that page, corresponding to that `<HASH_ID>`, was not modified, meaning, the strokes were not added, it would show value "Blank", as above. <br>
Now, IF you have added the pages to the original **430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf**, then the next page would go after that above page. <br>
In other words, in this particular use case, I have added one page, right after the above. And here an example of what I was seeing after that above `<HASH_ID>`:
```
            {
                "id": "9004cc86-a0d0-4da6-b663-04e8987423a5",
                "idx": {
                    "timestamp": "1:2",
                    "value": "fb"
                },
                "redir": {
                    "timestamp": "1:2",
                    "value": 105
                },
                "template": {
                    "timestamp": "1:2",
                    "value": "Blank"
                }
            },
            {
                "id": "9343c2d0-893c-4263-aee9-61296b9b0715",
                "idx": {
                    "timestamp": "1:2",
                    "value": "fc"
                },
                "redir": {
                    "timestamp": "1:2",
                    "value": 106
                }
            },
```
**NOTE**: You might be seeing some other IDs, which has the tag `"deleted"`. Please ignore them. Because those are the pages, that were deleted, <br>
while working on that PDF document. So, do not pay attention to them. 
```
{
                "deleted": {
                    "timestamp": "1:1",
                    "value": 1
                },
                "id": "615693f0-7b40-4547-984b-d9808fea9e8e",
                "idx": {
                    "timestamp": "1:2",
                    "value": "bhb"
                },
                "template": {
                    "timestamp": "1:2",
                    "value": "Blank"
                }
            }
```
**Fifth**: Now, once the previous step is done, you have determined, where exactly the `9004cc86-a0d0-4da6-b663-04e8987423a5` is and which are going after that: <br>
After that copy all the `<HASH_ID>`s, which are right after this above, but not deleted, into the notepad, like so (in my case only one page):
```
9343c2d0-893c-4263-aee9-61296b9b0715
```
**Six**: Then, it's needed to prepend those values with the particular syntax, visible in the `.env` file:
```
# After the "=" there should be valid rm page-specific HASH ID, see "README.md".
# see "README.md". EXAMPLE: FILE_21_11_24=0537ae0b-1eb3-407e-b285-c02bdbee8af3
```
So, because we have modified the original PDF file to add the new page, we have to label it as the respected month and date. In my case: <br>
```
FILE_01_03_25=9343c2d0-893c-4263-aee9-61296b9b0715
```
**Seventh**: After that, copy that above entire string(s) into the end of `.env` file:
```
FILE_27_02_25=54700140-af35-450a-8f6e-1291ade72e41
FILE_28_02_25=9004cc86-a0d0-4da6-b663-04e8987423a5
# Above is the last line in the Original ".env" file.
# Here is modified new line:
FILE_01_03_25=9343c2d0-893c-4263-aee9-61296b9b0715
```
**Eighth**: Now, copy the file `.env` into the RMPP, like so:
```
scp .env root@10.11.99.1:/home/root/rm_calendar_memo/
```
**Ninth**: Post that connect to the RMPP and execute this command to restart the `rm_calendar_memo` service:
```
root@<MY_RMPP_HOSTNAME>:~# systemctl restart rm_calendar_memo.service
```

# ======== Tested environments ====
```
* Tested combination 1 | Device: Remarkable Paper Pro, firmware: 3.15.2.1 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 2 | Device: Remarkable Paper Pro, firmware: 3.15.3.0 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 3 | Device: Remarkable Paper Pro, firmware: 3.16.0.60 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 4 | Device: Remarkable Paper Pro, firmware: 3.16.1.0 | node22.10.0_lin_arm64, sharp0.33.5
```

# ======== References ========
• [Reference 1 | Remarkable. Enable Developer Mode.](https://support.remarkable.com/s/article/Developer-mode) <br>
• [Reference 2 | Microsoft. OpenSSH installation, first use.](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse) <br>
• [Reference 3 | Remarkable. Importing and exporting files.](https://support.remarkable.com/s/article/importing-and-exporting-files) <br>
• [Reference 4 | Wikipedia. SSH File Transfer Protocol.](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol) <br>
• [Reference 5 | Wikipedia. Universally Unique Identifier.](https://en.wikipedia.org/wiki/Universally_unique_identifier) <br>
• [Reference 6 | Remarkable. Documentation. Developer Mode. Commands "mount -o remount,rw /" and "umount -R /etc".](https://developer.remarkable.com/documentation/developer-mode) <br>
