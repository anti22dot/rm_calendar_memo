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
* The similar concept has been taken when designing the functionality of this implementation on the RMPP. <br>
* The current repo had been broked down into 2 parts/folders, depending on the final sleep screen layout: **`layout1_singlepage_sleepscreen`** and **`layout2_fourpages_sleepscreen`**. <br>
* Those separate folders having the very similar files structure, but having some differences, some particular different scripts and implementations. <br>
* **Layout 2 | Sleep screen example**: ![28 12 24 final notes new composited](https://github.com/user-attachments/assets/1e830106-6595-4adb-a0ce-6e5cafb861a5)
# ======== Requirements, limitations, features ====
**(LIMITATION)** The file `rm_calendar_memo/layout1_singlepage_sleepscreen/rm_calendar/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf` contains the PDF calendar, currently, until `28 February 2025`. <br>
**(LIMITATION)** The file `rm_calendar_memo/layout2_fourpages_sleepscreen/rm_calendar/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.pdf` contains the PDF calendar, currently, until `30 March 2025`. <br>
**(LIMITATION)** If you decide to and update only the PDF files itself (like if you would like to change something in the PDF) , it's needed to reupload only that file to RMPP, but make sure to not change the order of the existing pages or remove the pages, and it's important for the existing scripts to work. <br>
**(FEATURE/LIMITATION)** The current implementation scripts are modifying the `suspended.png`, by dynamically replacing it. <br>
In the script `periodically_update_suspended_png.sh` there is a line `sleep 5`. It means that the frequency of those changes is 0.5 seconds. <br>
What's most important that there is a loop, that runs indefinitely. This is overall `good` and `bad`. `Good` because it's performant, fast updates. <br>
"Bad" because it is not very efficient to keep on replacing the file all the time, even when we don't actually adding some notes to respected PNG. <br>
**(FEATURE/LIMITATIONS)** I have been reviewing the CPU and RAM consumption of the implementation-specific files, during the execution, using "top" tool, on RMPP. <br>
The CPU and RAM (%VSZ) consumptions were showing `0%`/`0%` almost all the time, for the respected scripts used:
```
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
64838   849 root     R     3492   0%   0% top
59975     1 root     S     3720   0%   0% {periodically_up} /bin/bash /home/root/rm_calendar_memo/periodically_update_suspended_png.sh
```
Therefore, I did not notice any performance degradation when using RMPP and/or in particularly writing on that particular document `Todo`. <br>
**(FEATURE)** These implementation scripts do not require Internet or any kind of net to work, it works locally, on RMPP. The implementation scripts do not send any data outside the RMPP. <br>
**(LIMITATIONS)** For the **supported RM+versions** refer to the `Tested environments` section of the current memo. <br>
**(REQUIRED/LIMITATION)** This implementation works only in `Dev mode`. Make sure the `Developer mode` is enabled. Consult the **Reference 1** about it. <br>
**(REQUIRED)** Know your `"<RMPP_SSH_ROOT_PASSWORD>"` password for SSH. Consult the **Reference 1**, section `Accessing your reMarkable Paper Pro via SSH`. <br>
**(REQUIRED)** The "ssh" command available from the terminal. On MacOS it is available by default. For Windows consult **Reference 2**. <br>
**(REQUIRED)** Make sure you are aware how to enable the `USB Web interface` on RMPP. Consult **Reference 3** section **"`How to enable USB transfer on your reMarkable`"** to get to know more about it. <br>

# ======== Configuration, usage | Use case 1 | Integrate the **rm_calendar** with the rm_calendar_memo ====
**On your Mac or Windows, unpack/extract/move the current project files and move them into the folder with the name `rm_calendar_memo`. This folder name will be needed further**. <br>
**Choose which Layout of the final sleep screen do you prefer to use**. Currently 2 Layouts are available: **layout1_singlepage_sleepscreen** and **layout2_fourpages_sleepscreen**. <br>
Later on, when copying the files onto the rMPP, those layout would be important.
See file of the systemd service, where the path matters: https://github.com/anti22dot/rm_calendar_memo/blob/99898eec5ba9e86e26b640dcbc294bc0b8d367bf/rm_calendar_memo.service#L8
* <a name="use_case1_step_a"></a> **[Use case 1 | Step A](#use_case1_step_a)** Download the prebuild Node.js binaries from here https://nodejs.org/en/download/prebuilt-binaries <br>
**Make sure** to specify the **22.X** (at the time of this memo, 22.11), **`Linux`** as platform, **`ARM64`** as CPU architecture. <br>
**NOTE**: It's crucial to use the version of Node.js itself `**22.X**`, that I've mentioned here, because there would be dependencies on it in scripts. <br>
Hit on "Download `<YOUR_CHOSEN_VERSION>` button. Unpack that archive into the separate folder which is **different from the current project**. <br>
For example, `<PATH_TO>/node-v22.11.0-linux-arm64` folder:
```
[bash Downloads]$ ls -ltra |grep node
drwxr-xr-x@  9 staff   288B Jan  3 02:33 node-v22.11.0-linux-arm64
-rw-r--r--@  1 staff    27M Jan  3 16:28 node-v22.11.0-linux-arm64.tar.xz
[bash Downloads]$ ls -ltra node-v22.11.0-linux-arm64
total 1064
drwxr-xr-x@ 4 staff   128B Jan  3 02:28 share
drwxr-xr-x@ 3 staff    96B Jan  3 02:28 lib
drwxr-xr-x@ 3 staff    96B Jan  3 02:31 include
drwxr-xr-x@ 6 staff   192B Jan  3 02:31 bin
-rw-r--r--@ 1 staff    39K Jan  3 02:33 README.md
-rw-r--r--@ 1 staff   136K Jan  3 02:33 LICENSE
-rw-r--r--@ 1 staff   354K Jan  3 02:33 CHANGELOG.md
drwxr-xr-x@ 9 staff   288B Jan  3 02:33 .
drwx------@ 9 staff   288B Jan  3 16:28 ..
```
* <a name="use_case1_step_b"></a> **[Use case 1 | Step B](#use_case1_step_b)**: Connect your RMPP device to your Mac/Windows via the USB C cable. After that you need to make sure the `USB web interface` is enabled. Open `Terminal 1`. 
After that, navigate to the `Settings` - `Storage`, and there would be section `USB web interface`. <br>
Locate the IP address of your RMPP, written after the `http://`. Note it down somewhere in your notepad as `<RMPP_IP_ADDRESS>`. <br>
About "USB web interface" consult **Reference 3**. Open the terminal (let's label it `Terminal 1`) on your Mac or Windows and execute these commands:
```
ssh root@<RMPP_IP_ADDRESS>
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, provide it and hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
# If the password is correct, it would show to you the prompt of the RMPP, like this:
root@<MY_RMPP_HOSTNAME>:~#
```
**NOTE**: For the **"ssh"** command itself make sure the `Requirements` have section have been reviewed, where it was mentioned about it. <br>
**NOTE**: The value of `<RMPP_SSH_ROOT_PASSWORD>` is visible from the `General > About > Copyrights and licenses` page of the RMPP itself. <br>
Once we have accessed the RMPP, let's also now execute this command to being able to write files into the system folders, as we would needed this later on:
```
umount -l /etc
mount -o remount,rw /
```

* <a name="use_case1_step_c"></a> **[Use case 1 | Step C](#use_case1_step_c)** Open `Terminal 2`. Upload the Node.js runtime to the RMPP.
The previous steps have confirmed that you have the SSH connection from your MacOS or Windows to your RMPP device. <br>
In the further steps we would transfer the files using the SCP rather than Web UI because we need to transfer them into the specific location. <br>
At this point, depending on the OS type, there can be used many tools to transfer the files using SFTP, check **`Reference 4`**. <br>
In this manual I would be using tool called `scp`, and would be using MacOS platform. Open another **`Terminal 2`**, navigate to folder with Node.js. <br>
From inside that folder let's execute this command:
```
[bash Downloads]$ pwd
/Users/<MY_USER_ID>/Downloads
[bash Downloads]$ ls -ltra node-v22.11.0-linux-arm64
total 1064
drwxr-xr-x@ 4 staff   128B Jan  3 02:28 share
drwxr-xr-x@ 3 staff    96B Jan  3 02:28 lib
drwxr-xr-x@ 3 staff    96B Jan  3 02:31 include
drwxr-xr-x@ 6 staff   192B Jan  3 02:31 bin
-rw-r--r--@ 1 staff    39K Jan  3 02:33 README.md
-rw-r--r--@ 1 staff   136K Jan  3 02:33 LICENSE
-rw-r--r--@ 1 staff   354K Jan  3 02:33 CHANGELOG.md
drwxr-xr-x@ 9 staff   288B Jan  3 02:33 .
drwx------@ 9 staff   288B Jan  3 16:28 ..
scp -r ./node-v22.11.0-linux-arm64 root@<RMPP_IP_ADDRESS>:/home/root/
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
# After that, the entire folder (in my case "node-v22.11.0-linux-arm64") would be uploaded into RMPP under `/home/root/`.
# It would take some time to do that, and it would display many lines, similar to the below output:
...
no-tty.js                                         100%   44    44.3KB/s   00:00
file-exists.js                                    100%  663   548.7KB/s   00:00
is-windows.js                                     100%   46    51.8KB/s   00:00
...
```
**NOTE**: The value of `<RMPP_SSH_ROOT_PASSWORD>` is visible from the `General` > `About` > `Copyrights and licenses` page of the RMPP itself. <br>

* <a name="use_case1_step_d"></a> **[Use case 1 | Step D](#use_case1_step_d)** In the existing `Terminal 1`, verify the uploaded files. Modify `.env`. In the `Terminal 2`, upload the `rm_calendar_memo` folder. <br>
```
root@<MY_RMPP_HOSTNAME>:~# pwd
/home/root
root@<MY_RMPP_HOSTNAME>:~# ls -ltra |grep node
drwxr-xr-x    6 root     root          4096 Jan  3 15:47 node-v22.11.0-linux-arm64
root@<MY_RMPP_HOSTNAME>:~# ls -ltra node-v22.11.0-linux-arm64/
-rw-r--r--    1 root     root        139053 Jan  3 15:46 LICENSE
drwxr-xr-x    3 root     root          4096 Jan  3 15:46 include
drwxr-xr-x    2 root     root          4096 Jan  3 15:46 bin
-rw-r--r--    1 root     root        362490 Jan  3 15:46 CHANGELOG.md
drwxr-xr-x    3 root     root          4096 Jan  3 15:47 lib
-rw-r--r--    1 root     root         40117 Jan  3 15:47 README.md
drwxr-xr-x    4 root     root          4096 Jan  3 15:47 share
drwxr-xr-x    6 root     root          4096 Jan  3 15:47 .
drwx------   11 root     root          4096 Jan  3 15:50 ..
```
Also we need to give the executable bits to the `node` binary. Execute this command:
```
root@<MY_RMPP_HOSTNAME>:~# chmod +x node-v22.11.0-linux-arm64/bin/*
```
Let's also create the **`"/home/root/rm_calendar_memo"`** directory within the same **`Terminal 1`**:
```
root@<MY_RMPP_HOSTNAME>:~# pwd
/home/root
root@<MY_RMPP_HOSTNAME>:~# mkdir rm_calendar_memo
```
Next, on your MacOS or Windows, open file ".env" inside the folder with the unpacked project files.
Provide the appropriate values to the following parameters after the `=` sign, accordingly:
```
RM_CALENDAR_APP_DEBUG=false
CALENDAR_MEMO_ROOT=/home/root/rm_calendar_memo
TODAYS_TODO_NEW_ABSOLUTE_FILENAME=/usr/share/remarkable/suspended.png
NODE_ROOT=
# For the "ORIGINAL_DOC_HASH_ID" after the "=" equal sign there should be valid rm directory-specific HASH ID.
# see "README.md". EXAMPLE: 2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d
ORIGINAL_DOC_HASH_ID=2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d
...
# Omitted further lines here.
...
```
**NOTE**: Do not modify the other variables. You only need to modify one variable here, **`NODE_ROOT=`** which is path to `root` of the Node.js dir on RMPP. <br>
**NOTE**: For example, in my use case: **`NODE_ROOT=/home/root/node-v22.11.0-linux-arm64`**. <br>
In this demonstration, I have chosen the **`layout2_fourpages_sleepscreen`**. Verify the project files, they should look similar to below:
Change the directory to the chosen layout, in this case, **`layout2_fourpages_sleepscreen`**:
```
[bash Downloads]$ ls -ltra
total 72
drwx------@  5 staff   160B Oct 21 22:11 ..
-rw-r--r--   1 staff   1.0K Jan  3 22:08 LICENSE
drwxr-xr-x  14 staff   448B Jan  3 22:08 layout1_singlepage_sleepscreen
drwx------@  7 staff   224B Jan  3 22:08 .
drwxr-xr-x  16 staff   512B Jan  3 22:08 layout2_fourpages_sleepscreen
drwxr-xr-x  13 staff   416B Jan  3 22:14 .git
-rw-r--r--@  1 staff    30K Jan  3 22:18 README.md
[bash Downloads]$ cd layout2_fourpages_sleepscreen/
[bash layout2_fourpages_sleepscreen]$ ls -ltra
total 352
drwx------@  7 staff   224B Jan  3 22:08 ..
-rw-r--r--   1 staff    24K Jan  3 22:08 .env
-rw-r--r--   1 staff    92K Jan  3 22:08 blank.png
drwxr-xr-x  93 staff   2.9K Jan  3 22:08 calendars
-rwxr-xr-x   1 staff   267B Jan  3 22:08 get_metadata.js
drwxr-xr-x   6 staff   192B Jan  3 22:08 labels
drwxr-xr-x  14 staff   448B Jan  3 22:08 node_modules
-rwxr-xr-x   1 staff   827B Jan  3 22:08 open_composite_png.js
-rwxr-xr-x   1 staff   306B Jan  3 22:08 open_prepare_png.js
-rwxr-xr-x   1 staff   319B Jan  3 22:08 open_resize_png.js
-rwxr-xr-x   1 staff    17K Jan  3 22:08 package-lock.json
-rwxr-xr-x   1 staff    51B Jan  3 22:08 package.json
-rw-r--r--   1 staff   7.5K Jan  3 22:08 periodically_update_suspended_png.sh
drwxr-xr-x   8 staff   256B Jan  3 22:08 rm_calendar
drwxr-xr-x  16 staff   512B Jan  3 22:08 .
-rw-r--r--   1 staff   472B Jan  3 22:08 rm_calendar_memo.service
```
From MAC/WIN | It's now needed to transfer the entire content of the chosen layout, **`layout2_fourpages_sleepscreen`**, into the RMPP, under the **`/home/root/rm_calendar_memo/`**. In my use case I used "scp":
```
[bash layout2_fourpages_sleepscreen]$ pwd
/Users/<MY_USER_ID>/Downloads/layout2_fourpages_sleepscreen
[bash Downloads]$ scp -r * root@<RMPP_IP_ADDRESS>:/home/root/rm_calendar_memo/
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
# After that, the entire folder "rm_calendar_memo" would be uploaded into RMPP under "/home/root/".
# It would take some time to do that.
```
* <a name="use_case1_step_e"></a> **[Use case 1 | Step E](#use_case1_step_e)** In the existing `Terminal 1`, verify the uploaded files. Update permissions. Move the `rm_calendar_memo/rm_calendar` directory to **`xochitl`**. Start the service and enable it to start on the reboot.
```
root@<MY_RMPP_HOSTNAME>:~# ls -ltra
drwxr-xr-x    4 root     root          4096 Jan  3 13:52 ..
drwxr-xr-x    3 root     root          4096 Jan  3 13:52 .local
drwxr-xr-x    3 root     root          4096 Jan  3 13:52 .journal
drwxr-xr-x    3 root     root          4096 Jan  3 13:52 .cache
drwxr-xr-x    2 root     root          4096 Jan  3 13:56 .dropbear
drwx------    2 root     root          4096 Jan  3 14:25 .ssh
drwxr-xr-x    4 root     root          4096 Jan  3 18:49 .config
-rw-------    1 root     root         14419 Jan  3 15:48 .bash_history
drwxr-xr-x    3 root     root          4096 Jan  3 15:48 .memfault
-rw-------    1 root     root         21217 Jan  3 16:07 .viminfo
drwxr-xr-x    6 root     root          4096 Jan  3 16:42 node-v22.11.0-linux-arm64
drwx------   11 root     root          4096 Jan  3 18:33 .
drwxr-xr-x    3 root     root          4096 Jan  3 18:33 rm_calendar_memo
root@<MY_RMPP_HOSTNAME>:~# ls -ltra rm_calendar_memo/
-rwxr-xr-x    1 root     root           224 Jan  3 22:08 .env
-rwxr-xr-x    1 root     root         94643 Jan  3 22:08 blank.png
-rwxr-xr-x    1 root     root          2976 Jan  3 22:08 calendars
-rwxr-xr-x    1 root     root           267 Jan  3 22:08 get_metadata.js
-rwxr-xr-x    1 root     root           192 Jan  3 22:08 labels
drwxr-xr-x   14 root     root           448 Jan  3 22:08 node_modules
-rw-r--r--    1 root     root           827 Jan  3 22:08 open_composite_png.js
-rw-r--r--    1 root     root           306 Jan  3 22:08 open_prepare_png.js
-rwxr-xr-x    1 root     root           319 Jan  3 22:08 open_resize_png.js
drwxr-xr-x    2 root     root         16909 Jan  3 22:08 package-lock.json
-rwxr-xr-x    1 root     root            51 Jan  3 22:08 package.json
-rwxrwxrwx    1 root     root          7698 Jan  3 22:08 periodically_update_suspended_png.sh
-rwxrwxrwx    1 root     root           256 Jan  3 22:08 rm_calendar
-rwxrwxrwx    1 root     root           472 Jan  3 22:08 rm_calendar_memo.service
-rwxrwxrwx    1 root     root            0B Jan  3 23:15 rm_calendar_memo.log
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
drwxr-xr-x    8 root     root          4096 Jan  3 19:46 ..
-rw-r--r--    1 root     root      10230309 Jan  3 22:08 2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.pdf
-rw-r--r--    1 root     root            34 Jan  3 22:08 2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.local
-rw-r--r--    1 root     root           358 Jan  3 22:08 2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.pagedata
drwxr-xr-x    2 root     root          3520 Jan  3 22:08 2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails
-rw-r--r--    1 root     root           265 Jan  3 22:08 2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.metadata
-rw-r--r--    1 root     root         22562 Jan  3 22:08 2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.content
drwxr-xr-x    4 root     root         20480 Jan  3 16:44 .
```
It's needed to give the right permissions to the application files using the following commands:
```
chmod 755 /home/root/rm_calendar_memo/*
chmod 644 /home/root/rm_calendar_memo/rm_calendar_memo.service
```
Now, it's needed to copy the `rm_calendar_memo.service` into the SystemD directory of the RMPP, using the following command:
```
cp /home/root/rm_calendar_memo/rm_calendar_memo.service /usr/lib/systemd/system/rm_calendar_memo.service
```
Then, run the following commands to check whether the service has been "`recognized`" by the SystemD, first:
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
Then start the service, and check the status of it using the following commands:
```
root@<MY_RMPP_HOSTNAME>:~# systemctl start rm_calendar_memo.service
root@<MY_RMPP_HOSTNAME>:~# systemctl status -l rm_calendar_memo.service
● rm_calendar_memo.service - periodically update the remarkable paper pro suspended picture
     Loaded: loaded (/usr/lib/systemd/system/rm_calendar_memo.service; enabled; vendor preset: disabled)
     Active: active (running) since Sun 2025-01-03 18:45:09 UTC; 1s ago
   Main PID: 59034 (periodically_up)
      Tasks: 2 (limit: 1588)
     Memory: 516.0K
     CGroup: /system.slice/rm_calendar_memo.service
             ├─ 59034 /bin/bash /home/root/rm_calendar_memo/periodically_update_suspended_png.sh
             └─ 59038 sleep 5

Jan  3 18:45:09 <MY_RMPP_HOSTNAME> systemd[1]: Started periodically update the remarkable paper pro suspended picture.
```
To make sure the scripts would run after the reboot, execute the following command:
```
systemctl enable rm_calendar_memo.service
```

# ======== Configuration, usage | Use case 2 | Use case 2 | Use any kind of document ====
* The documentation is removed for this use case, for now. But it's possible. See earlier version `1.0.0`, where it was present.

## ======== Optional, Debugging, Extras ====

**(OPTIONAL/DEBUGGING)** The frequency of the dynamic changes of the file `suspended.png` is set to `0.5 seconds`, by default, but can be modified. <br>
To modify it open the file `periodically_update_suspended_png.sh` and change the value of the `sleep 0.5` command to your value of choice. <br>
* <a name="optional1"></a> **[Optinal procedure 1 | Enable the DEBUG logging:](#optional1)**
If you look into the `.env` file it has variable `RM_CALENDAR_APP_DEBUG`. This variable used for troubleshooting purposes. <br>
If set to the `true`, the `periodically_update_suspended_png.sh` would be writing logs into the `/home/root/rm_calendar_memo/rm_calendar_memo.log` file. <br>
Now, because the default frequency of the updates is `5 seconds`, you can imagine, if leaving the device for 1-3 days, the log file can raise in size. <br>
After changing that environment variable value, it's needed to restart the SystemD service via this command `systemctl restart rm_calendar_memo`. <br>
So, it's useful for debugging purposes. Here is the sample output of the `rm_calendar_memo.log` when debug is enabled:

```
========
Right now is Thu Dec 26 14:18:23 CET 2024. Searching for the files.
* The files exist. Creating the temporary copy of the following files in the /home/root/rm_calendar_memo/ location:
** /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/489ef128-4ee8-44be-894f-0ae2403c3acc.png, /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/6cb9b296-0e5d-403d-88a2-a6c8294fec0d.png, /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/1bc284ff-4408-4121-80cf-6947d006c01e.png, /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/d429d858-1085-4463-b01d-93a974f44213.png
cp /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/489ef128-4ee8-44be-894f-0ae2403c3acc.png /home/root/rm_calendar_memo/26.12.24.week.png
cp /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/6cb9b296-0e5d-403d-88a2-a6c8294fec0d.png /home/root/rm_calendar_memo/26.12.24.morning.png
cp /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/1bc284ff-4408-4121-80cf-6947d006c01e.png /home/root/rm_calendar_memo/26.12.24.afternoon.png
cp /home/root/.local/share/remarkable/xochitl/2234ce4e-ec56-41c2-8d61-cbfd97d3ae3d.thumbnails/d429d858-1085-4463-b01d-93a974f44213.png /home/root/rm_calendar_memo/26.12.24.evening.png
* Here is the metadata of that newly copied files:
** 26.12.24.week.png, and it's metadata:
{
  format: 'png',
  width: 384,
  height: 512,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
** 26.12.24.morning.png, and it's metadata:
{
  format: 'png',
  width: 384,
  height: 512,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
** 26.12.24.afternoon.png, and it's metadata:
{
  format: 'png',
  width: 384,
  height: 512,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
** 26.12.24.evening.png, and it's metadata:
{
  format: 'png',
  width: 384,
  height: 512,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
* Preparing the PNGs. Removing top calendar from the page, to have only notes area:
node open_prepare_png.js 26.12.24.week.png 1
node open_prepare_png.js 26.12.24.morning.png 2
node open_prepare_png.js 26.12.24.afternoon.png 3
node open_prepare_png.js 26.12.24.evening.png 4
* Resizing the newly modified PNGs:
node open_resize_png.js 26.12.24.week.notes.png.png 1
node open_resize_png.js 26.12.24.morning.notes.png.png 2
node open_resize_png.js 26.12.24.afternoon.notes.png.png 3
node open_resize_png.js 26.12.24.evening.notes.png.png 4
* As the result the new resized files created. The new resized absolute filenames and metadatas:
** 26.12.24.week.notes.new.png, and it's metadata:
{
  format: 'png',
  width: 767,
  height: 703,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
** 26.12.24.morning.notes.new.png, and it's metadata:
{
  format: 'png',
  width: 767,
  height: 703,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
** 26.12.24.afternoon.notes.new.png, and it's metadata:
{
  format: 'png',
  width: 767,
  height: 703,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
** 26.12.24.evening.notes.new.png, and it's metadata:
{
  format: 'png',
  width: 767,
  height: 703,
  space: 'srgb',
  channels: 3,
  depth: 'uchar',
  density: 96,
  isProgressive: false,
  hasProfile: false,
  hasAlpha: false
}
* Creating the composited image by adding calendar image on top of the resized file of our TODO page:
node open_composite_png.js 26.12.24_calendar.png 26.12.24.week.notes.new.png 26.12.24.morning.notes.new.png 26.12.24.afternoon.notes.new.png 26.12.24.evening.notes.new.png
* Copying the new resized file into the target location, while replacing the current 'suspended.png' file:
cp 26.12.24.final.notes.new.composited.png /usr/share/remarkable/suspended.png
* Deleting the temporary copy of the original file, resized file, and the composited file:
rm -f 26.12.24.week.png 26.12.24.morning.png 26.12.24.afternoon.png 26.12.24.evening.png
rm -f 26.12.24.week.notes.png 26.12.24.morning.notes.png 26.12.24.afternoon.notes.png 26.12.24.evening.notes.png
rm -f 26.12.24.week.notes.new.png 26.12.24.morning.notes.new.png 26.12.24.afternoon.notes.new.png 26.12.24.evening.notes.new.png 26.12.24.final.notes.new.composited.png
========
```

* <a name="optional2"></a> **[Optinal procedure 2 | Expand the PDF file:](#optional2)** <br>
**NOTE**: This procedure was documented for the **Layout1**. But the same absolutely procedure is applicable to the **Layout2**.
**First | Use this step only if you have updated your existing PDF file, on the `Windows`/`Mac`/`Linux` and would like to update it on your RMPP** <br>
**Second | Also, make sure to only Extend the original PDF, and Not cut it, like do not remove existing pages, only add pages if you need.** <br>
Check the instructions from the **Use case 1 | Step D** , but in this case, only reupload the single file **`430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf`** <br>
(**do not re-upload the other files or folders**)
```
[bash Downloads]$ scp -r 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf root@<RMPP_IP_ADDRESS>:/home/root/.local/share/remarkable/xochitl/
```
**NOTE**: The point is that the RMPP would store all the `strokes/markings` within the `430f8cdf-e2e8-412c-b7e3-5ebf3b126bff/` **`directory itself`**, <br>
and we are not touching that files, but only replacing the original PDF file. <br>
**Third**: It's needed to also update the `.env` file with the new `<HASH_ID>`. For that, first, download the **.content** file from the RMPP: <br>
```
[bash Downloads]$ scp -r root@10.11.99.1:/home/root/.local/share/remarkable/xochitl/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content .
root@10.11.99.1's password:
[bash Downloads]$ scp root@10.11.99.1:/home/root/.local/share/remarkable/xochitl/430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content .
root@10.11.99.1's password:
430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content                                                       100%   49KB  11.8MB/s   00:00
[bash Downloads]$ ls -ltra |grep 430
-rw-r--r--   1 staff    49K Jan  3 17:44 430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.content
```
**Fourth**: Open that file and locate the line, which contains this `<HASH_ID>`: **`9004cc86-a0d0-4da6-b663-04e8987423a5`**, it would look like so:
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
**NOTE**: This id `9004cc86-a0d0-4da6-b663-04e8987423a5` is related to the page `106` - `28 February 2025`, as of today's writing (`**22 Nov**`). <br>
**NOTE**: If the page, corresponding to that `<HASH_ID>`, was not modified, meaning, the strokes were not added, it would show value `"Blank"`, as above. <br>
Now, if you have added the pages to the original **`430f8cdf-e2e8-412c-b7e3-5ebf3b126bff.pdf`**, then the next page would go after that above page. <br>
In other words, in this particular use case, I have added one page right after the above. And below, an example of what I was seeing after that above `<HASH_ID>`:
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
**NOTE**: You might be seeing some other IDs, which has the tag `"deleted"`. Please do ignore them, because those are the pages that were deleted, <br>
while working on that PDF document: 
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
**Fifth**: Once the previous step is done, you have determined, where exactly the `9004cc86-a0d0-4da6-b663-04e8987423a5` is, and which are going after that. <br>
After that, copy all the `<HASH_ID>`s, which are right after this above, but not deleted, right into the notepad, like so (in my case only one page):
```
9343c2d0-893c-4263-aee9-61296b9b0715
```
**Six**: Then, it's needed to prepend the following values with the particular syntax, visible in the `.env` file:
```
# After the "=" there should be valid rm page-specific HASH ID, see "README.md".
# see "README.md". EXAMPLE: FILE_21_11_24=0537ae0b-1eb3-407e-b285-c02bdbee8af3
```
So, because we have modified the original PDF file to add the new page, we have to label it as the respected month and date. In my use case: <br>
```
FILE_01_03_25=9343c2d0-893c-4263-aee9-61296b9b0715
```
**Seventh**: After that, copy that above entire string(s) into the end of `.env` file, using the following command:
```
FILE_27_02_25=54700140-af35-450a-8f6e-1291ade72e41
FILE_28_02_25=9004cc86-a0d0-4da6-b663-04e8987423a5
# Above is the last line in the Original ".env" file.
# Here is modified new line:
FILE_01_03_25=9343c2d0-893c-4263-aee9-61296b9b0715
```
**Eighth**: Now copy the file `.env` into the RMPP, using the following command:
```
scp .env root@10.11.99.1:/home/root/rm_calendar_memo/
```
**Ninth**: After that connect to the RMPP and execute the following command to restart the `rm_calendar_memo` service:
```
root@<MY_RMPP_HOSTNAME>:~# systemctl restart rm_calendar_memo.service
```

# ======== Tested environments ====
```
* Tested combination 1 | Device: Remarkable Paper Pro, firmware: 3.15.2.1 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 2 | Device: Remarkable Paper Pro, firmware: 3.15.3.0 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 3 | Device: Remarkable Paper Pro, firmware: 3.16.0.60 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 4 | Device: Remarkable Paper Pro, firmware: 3.16.1.0 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 4 | Device: Remarkable Paper Pro, firmware: 3.17.0.62 | node22.10.0_lin_arm64, sharp0.33.5
```

# ======== References ========
• [Reference 1 | Remarkable. Enable Developer Mode.](https://support.remarkable.com/s/article/Developer-mode) <br>
• [Reference 2 | Microsoft. OpenSSH installation, first use.](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse) <br>
• [Reference 3 | Remarkable. Importing and exporting files.](https://support.remarkable.com/s/article/importing-and-exporting-files) <br>
• [Reference 4 | Wikipedia. SSH File Transfer Protocol.](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol) <br>
• [Reference 5 | Wikipedia. Universally Unique Identifier.](https://en.wikipedia.org/wiki/Universally_unique_identifier) <br>
• [Reference 6 | Remarkable. Documentation. Developer Mode. Commands "mount -o remount,rw /" and "umount -R /etc".](https://developer.remarkable.com/documentation/developer-mode) <br>
