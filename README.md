# Table of contents
General info, objectives <br>
Requirements, limitations <br>
Configuration, usage <br>
• optional configurations, debugging, notes <br>
Sample output <br>
Tested environments <br>
Project structure, file index <br>
Source Code <br>
References

# ======== General info, objectives ====

* See this video demonstration: <video src='https://github.com/user-attachments/assets/e18cf4d8-a7cd-4806-9045-0e6ba24546f1' width=180/>
* If the video does not load, check this instead: https://www.youtube.com/watch?v=PP7IXztZy7I
* The "Calendar Memo" term has been borrowed from the Onyx Boox eink devices, since they have the similar kind of separate Android application, <br>
which allows to write useful notes for the specific date within the app, and then display the notes relevant to the current date of looking.

* The similar concept has been taken when designing the functionality of this implementation on the RMPP.
* In my example, there has been opened the notepad, labeled as "Todo", containing 30 total pages (kinda days of month).
* I have written the line into that document on the particular page (19), closed that document and opened different document.
* Once I have put the device into "sleep" mode, the screen has automagically displayed the respected page of the "Todo" document, <br>
corresponding to the current day of the month (19 October). <br> <br>

# ======== Requirements, limitations, features ====
**(FEATURE/LIMITATION)** The current implementation (scripts) is essentilly modifying the "suspended.png", by dynamically replacing it. <br>
In the script "periodically_update_suspended_png.sh" there is a line "sleep 5". It means that the frequency of those changes is 5 seconds. <br>
What's most important that there is a loop, that runs indefinitely. This is overall "good" and "bad". "Good" because it's performant, fast updates. <br>
"Bad" because it is not very efficient to keep on replacing the file all the time, even when we don't actually adding some notes to respected PNG. <br>
**(FEATURE)** I have been reviewing the CPU and RAM consumption of the implementation-specific files, during the execution, using "top" tool, on RMPP. <br>
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
**(REQUIRED/LIMITATION)** This implementation works only in "Dev mode" Make sure the "Developer mode" is enabled. Consult the **Reference 1** about it <br>
**(REQUIRED)** Know your "<RMPP_SSH_ROOT_PASSWORD>" password for SSH. Consult the **Reference 1**, section "Accessing your reMarkable Paper Pro via SSH" <br>
**(REQUIRED)** "ssh" command available from the terminal. On MacOS it is available by default. For Windows consult **Reference 2** <br>
**(REQUIRED)** Make sure you are aware how to enable the "USB Web interface" on RMPP. Consult **Reference 3**, section "How to enable USB transfer on your reMarkable" to get to know more about it <br>

# ======== Configuration, usage ====
**On your Mac or Windows, unpack/extract/move the current project files and move them into the folder with the name "rm_calendar_memo". This folder name will be needed further.** <br>
* <a name="step_a"></a> **[Step A](#step_a)** Download the prebuild Node.js binaries from here https://nodejs.org/en/download/prebuilt-binaries <br>
**Make sure** to specify the **22.X** (at the time of writing, 22.10), **"Linux"** as platform, **"ARM64"** as CPU architecture. <br>
**NOTE**: It's crucial to use the version of Node.js itself (**22.X**) that I've mentioend here, because there would be dependencies on it in my scripts <br>
Hit on "Download <YOUR_CHOSEN_VERSION>" button. <br>
Unpack that archive into the separate folder, different from the current project. For example "<PATH_TO>/node-v22.10.0-linux-arm64" folder <br>

* <a name="step_b"></a> **[Step B](#step_b)** Connect your RMPP device to your Mac/Windows via the USB C cable. After that you need to make sure the "USB web interface" is enabled. <br>
After that, navigate to the "Settings" - "Storage" , and there would be section "USB web interface". <br>
Locate the IP address of your RMPP, written after the "http://". Note it down somewhere in your notepad as "<RMPP_IP_ADDRESS>" <br>
About "USB web interface" consult **Reference 3**. Open the terminal (let's label it "Terminal 1") on your Mac or Windows and execute these commands:
```
ssh root@<RMPP_IP_ADDRESS>
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
```
**NOTE**: For the **"ssh"** command itself make sure the "Requirements" have section have been reviewed, where it was mentioned about it. <br>
**NOTE**: The value of <RMPP_SSH_ROOT_PASSWORD> is visible from the "General > About" page of the RMPP itself. <br>
Once we have accessed the RMPP, let's also now execute this command to being able to write files into the system folders, as we would needed this later on:
```
umount -l /etc
mount -o remount,rw /
```

* <a name="step_c"></a> **[Step C](#step_c)** At this point, it is needed to determine the so-called "ORIGINAL_DOC_HASH_ID" of the document that you want to use as "Calendar Memo" document. <br>
This particular value is actually visible from the names of the folders and files within the **"/home/root/.local/share/remarkable/xochitl/"** on RMPP. <br>
This my custom named value is actually the randomly generated UUID, consult **Reference 5**, and assigned by the RMPP to the files and folders of the same document <br>
So, for example, on my RMPP , under that mentioned path, I have these files, which are related to the UUID "131b75e8-6649-4f70-b289-63887090559e": <br>
```
root@<MY_RMPP_HOSTNAME>:~# ls -ltra /home/root/.local/share/remarkable/xochitl/
...
drwxr-xr-x    2 root     root          4096 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.thumbnails
-rw-r--r--    1 root     root           230 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.metadata
-rw-r--r--    1 root     root         13691 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.content
```
So, at this point, it's needed to locate the particular document, that you want to use as you calendar document, which would be used for this purpose <br>
For that, I would recommend to create some document on RMPP , could be PDF or Notebook, and have at least 30 pages there. <br>
Once determined, just open that document, press on the little "notebook" menu at the bottom of the screen, then press "Notebook settings". <br>
There you'd see "ID: <SOME_VALUE>". For example, in my document use case, those value equals to **"131b75e8"**
Those "<SOME_VALUE>". Use the "Terminal 1", connected to the RMPP, and execute these commands:
```
root@<MY_RMPP_HOSTNAME>: cd /home/root/.local/share/remarkable/xochitl/
# Now, you have to locate your specific chosen document from all the other. To do that, just grep for that value <SOME_VALUE> (in my case "131b75e8"):
root@<MY_RMPP_HOSTNAME>:~/.local/share/remarkable/xochitl# ls -ltra | grep 131b75e8
-rw-r--r--    1 root     root            34 Oct 19 16:26 131b75e8-6649-4f70-b289-63887090559e.local
drwxr-xr-x    2 root     root          4096 Oct 20 19:27 131b75e8-6649-4f70-b289-63887090559e.thumbnails
-rw-r--r--    1 root     root           230 Oct 20 19:27 131b75e8-6649-4f70-b289-63887090559e.metadata
-rw-r--r--    1 root     root         13691 Oct 20 19:27 131b75e8-6649-4f70-b289-63887090559e.content
drwxr-xr-x    2 root     root          4096 Oct 20 19:27 131b75e8-6649-4f70-b289-63887090559e
# Now, you can verify that this is your needed document, like so:
cat 131b75e8-6649-4f70-b289-63887090559e.metadata
{
    "createdTime": "1729355185834",
    "lastModified": "1729356930209",
    "lastOpened": "1729356803558",
    "lastOpenedPage": 29,
    "parent": "",
    "pinned": false,
    "type": "DocumentType",
    "visibleName": "Todo"
}
# From that file we only need to look into one variable's value, "visibleName". Using that variable value we can quickly locate our chosen document.
# For example, above you can see it says "Todo". That's exactly the name of my document, that I have chosen for this task "Calendar Memo"
# Once we have found the "*.metadata" file that is corresponding to our chosen document, we need to note down the hash name of that file
# In my case above the hash name was the full value "131b75e8-6649-4f70-b289-63887090559e" Let's refer to it as "ORIGINAL_DOC_HASH_ID"
```

* <a name="step_d"></a> **[Step D](#step_d)** Once we know our **"ORIGINAL_DOC_HASH_ID"** value, identified in the previous step, we can now backup those all files, just in case:
```
cd /home/root/
mkdir document_files_backup
cp -R /home/root/.local/share/remarkable/xochitl/131b75e8-6649-4f70-b289-63887090559e.* /home/root/document_files_backup/
```

* <a name="step_e"></a> **[Step E](#step_e)** Once we know our **"ORIGINAL_DOC_HASH_ID"** value, identified in the previous step, we can now modify our respected ".png" files of our document. <br>
Before that, let's make sure that documents are closed on the RMPP itself, meaning, we are not doing anything on the device itself, like writing, etc. <br>
From the already opened "Terminal 1" , please copy the entire content of the "<ORIGINAL_DOC_HASH_ID>.content" file:
```
cd /home/root/.local/share/remarkable/xochitl/; cat 131b75e8-6649-4f70-b289-63887090559e.content
# For example, here is how it looks like on my RMPP:
{
    "cPages": {
        "lastOpened": {
            "timestamp": "1:30",
            "value": "43e45af8-e85d-4c83-9e34-0fc619e12201"
        },
        "original": {
            "timestamp": "0:0",
            "value": -1
        },
        "pages": [
            {
                "id": "68bc7cd1-5362-4550-893a-8deb9f877a8a",
                "idx": {
                    "timestamp": "1:2",
                    "value": "ba"
                },
                "template": {
                    "timestamp": "1:1",
                    "value": "Blank"
                }
            },
            {
                "id": "2c02dd9d-28c0-4c58-8a93-3272f3967be5",
                "idx": {
                    "timestamp": "1:2",
                    "value": "bb"
                },
                "template": {
                    "timestamp": "1:2",
                    "value": "Blank"
                }
            },
...
# I have intentionally did not paste the entire file because it large. 
# However, from that file we only need to look into the variables "id" and to do it in the order from top to the bottom.
```
Save the entire output somewhere into your notepad on your MacOS or Windows.  <br>
Now, open another "Terminal 2", SSH to the RMPP, we can, again, filter out all the files and folders related to our doc, via this command:
```
cd /home/root/.local/share/remarkable/xochitl/; ls -ltra |grep <ORIGINAL_DOC_HASH_ID>
# In my use case <ORIGINAL_DOC_HASH_ID>=131b75e8-6649-4f70-b289-63887090559e
drwxr-xr-x    2 root     root          4096 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.thumbnails
-rw-r--r--    1 root     root           230 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.metadata
-rw-r--r--    1 root     root         13691 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.content
# Navigate to the directory, that says "<ORIGINAL_DOC_HASH_ID>.thumbnails" (in my use case 131b75e8-6649-4f70-b289-63887090559e.thumbnails).
cd 131b75e8-6649-4f70-b289-63887090559e.thumbnails; ls -ltra
-rw-r--r--    1 root     root          1138 Oct 19 16:53 68bc7cd1-5362-4550-893a-8deb9f877a8a.png
-rw-r--r--    1 root     root          1138 Oct 19 16:53 2c02dd9d-28c0-4c58-8a93-3272f3967be5.png
-rw-r--r--    1 root     root          1138 Oct 19 16:53 56b5d515-3965-4591-b245-ea4d8031b6a6.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 e353b2b5-3643-4182-a4b2-78918e7ac616.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 83e35a15-b4d5-4df0-b89b-bb919d619ed7.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 65e9e5b2-fccc-4e99-b08e-0fe0ff2a4794.png
...
# I have omitted the full output due to it being long (30 entries)
```
It is needed to look into the notepad with the content of the "<ORIGINAL_DOC_HASH_ID>.content", and go "one-by-one" from the top to bottom <br>
At the same time, it's needed to rename the corresponding "<PATH_TO><ORIGINAL_DOC_HASH_ID>.thumbnails/*.png" files, <br>
one-by-one in the order specified in the "<ORIGINAL_DOC_HASH_ID>.content" file. <br>
For example, see above output, there is this line:
```
"id": "68bc7cd1-5362-4550-893a-8deb9f877a8a",
```
This line is part of the first block within the "pages" block. So, it has the value **"68bc7cd1-5362-4550-893a-8deb9f877a8a"**. <br>
It's needed to simply change this value to "1" in the **"<ORIGINAL_DOC_HASH_ID>.content"** file.
It's also needed to change the name of the file **"<PATH_TO><ORIGINAL_DOC_HASH_ID>.thumbnails/68bc7cd1-5362-4550-893a-8deb9f877a8a.png"** <br>
to the **"<PATH_TO><ORIGINAL_DOC_HASH_ID>.thumbnails/1.png**. <br>
Then, for example, the next item in the "pages" block was having the value of "id" as **"2c02dd9d-28c0-4c58-8a93-3272f3967be5"** <br>
Hence, it's needed to change this value to "2" in the **"<ORIGINAL_DOC_HASH_ID>.content"** file. <br>
It's also needed to change the name of the file **"<PATH_TO><ORIGINAL_DOC_HASH_ID>.thumbnails/2c02dd9d-28c0-4c58-8a93-3272f3967be5.png"** <br>
to the **"<PATH_TO><ORIGINAL_DOC_HASH_ID>.thumbnails/2.png**. <br>
The same thing has to be performed for all the pages mentioned under the "pages" block of the **"<ORIGINAL_DOC_HASH_ID>.content"** file. <br>

* <a name="step_f"></a> **[Step F](#step_f)** Once the previous step has been completed, you should have the structure of the files and folders similar to this , <br>
for your particular chosen <ORIGINAL_DOC_HASH_ID> (in this my example, <ORIGINAL_DOC_HASH_ID>=131b75e8-6649-4f70-b289-63887090559e):
```
root@<MY_RMPP_HOSTNAME>:~/.local/share/remarkable/xochitl# ls -ltra |grep 131b75e8-6649-4f70-b289-63887090559e
-rw-r--r--    1 root     root            34 Oct 19 16:26 131b75e8-6649-4f70-b289-63887090559e.local
drwxr-xr-x    2 root     root          4096 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.thumbnails
-rw-r--r--    1 root     root           230 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.metadata
-rw-r--r--    1 root     root         13691 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e.content
drwxr-xr-x    2 root     root          4096 Oct 20 16:26 131b75e8-6649-4f70-b289-63887090559e
root@<MY_RMPP_HOSTNAME>:~/.local/share/remarkable/xochitl# ls -ltra 131b75e8-6649-4f70-b289-63887090559e.thumbnails/
-rw-r--r--    1 root     root          1138 Oct 19 16:53 3.png
-rw-r--r--    1 root     root          1138 Oct 19 16:53 4.png
-rw-r--r--    1 root     root          1138 Oct 19 16:53 5.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 6.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 8.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 7.png
-rw-r--r--    1 root     root          1171 Oct 19 16:55 9.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 11.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 10.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 12.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 14.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 13.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 15.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 17.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 16.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 22.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 23.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 25.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 24.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 26.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 28.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 27.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 29.png
-rw-r--r--    1 root     root          1138 Oct 19 16:55 30.png
-rw-r--r--    1 root     root         17259 Oct 19 17:14 1.png
-rw-r--r--    1 root     root          2852 Oct 19 17:15 2.png
-rw-r--r--    1 root     root          3162 Oct 19 21:44 18.png
-rw-r--r--    1 root     root         14561 Oct 19 22:48 19.png
-rw-r--r--    1 root     root          5552 Oct 20 12:50 21.png
-rw-r--r--    1 root     root         39060 Oct 20 18:00 20.png
drwxr-xr-x   12 root     root          4096 Oct 20 18:00 ..
drwxr-xr-x    2 root     root          4096 Oct 20 18:00 .
root@<MY_RMPP_HOSTNAME>:~/.local/share/remarkable/xochitl# cat 131b75e8-6649-4f70-b289-63887090559e.content
root@<MY_RMPP_HOSTNAME>:~/.local/share/remarkable/xochitl# cat 131b75e8-6649-4f70-b289-63887090559e.content
{
    "cPages": {
        "lastOpened": {
            "timestamp": "1:40",
            "value": "20"
        },
        "original": {
            "timestamp": "0:0",
            "value": -1
        },
        "pages": [
            {
                "id": "1",
                "idx": {
                    "timestamp": "1:2",
                    "value": "ba"
                },
                "template": {
                    "timestamp": "1:1",
                    "value": "Blank"
                }
            },
            {
                "id": "2",
                "idx": {
                    "timestamp": "1:2",
                    "value": "bb"
                },
                "template": {
                    "timestamp": "1:2",
                    "value": "Blank"
                }
            },
            {
                "id": "3",
                "idx": {
                    "timestamp": "1:2",
                    "value": "bc"
                },
                "template": {
                    "timestamp": "1:2",
                    "value": "Blank"
                }
            },
# I have intentionally did not paste the entire file because it large. 
# However, from that file we only need to look into the variables "id" under the "pages" block, and to do it in the order from top to the bottom.
```

* <a name="step_g"></a> **[Step G](#step_g)** Previous steps have confirmed that you have the SSH connection from your MacOS or Windows to your RMPP device. <br>
The next step would be to transfer the files using the SCP rather than Web UI, because we need to transfer them into the specific location. <br>
At this point, depending on the OS type, there can be used many tools to transfer the files using SFTP, consult **Reference 4**. <br>
In this manual I would be using tool called "scp" , and would be using MacOS platform. Open another "Terminal 2", and navigate to folder with Node.js. <br>
From inside that folder let's execute this command:
```
[bash Downloads]$ pwd
/Users/<my_user_id>/Downloads
[bash Downloads]$ ls -ltra node-v22.10.0-linux-arm64
total 1064
drwxr-xr-x@  4 staff   128B Oct 16 16:36 share
drwxr-xr-x@  3 staff    96B Oct 16 16:36 lib
drwxr-xr-x@  3 staff    96B Oct 16 16:37 include
drwxr-xr-x@  6 staff   192B Oct 16 16:37 bin
-rw-r--r--@  1 staff    39K Oct 16 16:38 README.md
-rw-r--r--@  1 staff   136K Oct 16 16:38 LICENSE
-rw-r--r--@  1 staff   353K Oct 16 16:38 CHANGELOG.md
drwxr-xr-x@  9 staff   288B Oct 16 16:38 .
drwx------@ 31 staff   992B Oct 20 18:07 ..
scp -r ./node-v22.10.0-linux-arm64 root@<RMPP_IP_ADDRESS>:/home/root/
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
# After that, it would upload the entire folder (in my case "node-v22.10.0-linux-arm64") into RMPP under "/home/root"
```
**NOTE**: The value of <RMPP_SSH_ROOT_PASSWORD> is visible from the "General > About" page of the RMPP itself. <br>

* <a name="step_h"></a> **[Step H](#step_h)** Once we have completed uploading the "Node.js" into the RMPP, we can verify whether it has been uploaded correctly, from the "Terminal 1" <br>
```
root@<MY_RMPP_HOSTNAME>:~# cd ~
root@<MY_RMPP_HOSTNAME>:~# ls -ltra | grep node
drwxr-xr-x    6 root     root          4096 Oct 20 16:42 node-v22.10.0-linux-arm64
root@<MY_RMPP_HOSTNAME>:~# ls -ltra node-v22.10.0-linux-arm64/
-rw-r--r--    1 root     root        139053 Oct 20 16:41 LICENSE
drwx------   12 root     root          4096 Oct 20 16:41 ..
drwxr-xr-x    3 root     root          4096 Oct 20 16:41 include
drwxr-xr-x    2 root     root          4096 Oct 20 16:41 bin
-rw-r--r--    1 root     root        361239 Oct 20 16:41 CHANGELOG.md
drwxr-xr-x    3 root     root          4096 Oct 20 16:42 lib
-rw-r--r--    1 root     root         40117 Oct 20 16:42 README.md
drwxr-xr-x    4 root     root          4096 Oct 20 16:42 share
drwxr-xr-x    6 root     root          4096 Oct 20 16:42 .
```
Also we need to give the executable bits to the "node" binary. Execute this command:
```
root@<MY_RMPP_HOSTNAME>:~# chmod +x node node-v22.10.0-linux-arm64/bin/*
```
Next, on your MacOS or Windows, open the file ".env" inside the folder with the unpacked project files. <br>
Provide the appropriate values to the following parameters, after the "=" sign, accordingly :
```
RM_CALENDAR_APP_DEBUG=true
CALENDAR_MEMO_ROOT=/home/root/rm_calendar_memo
TODAYS_TODO_NEW_ABSOLUTE_FILENAME=/usr/share/remarkable/suspended.png
NODE_ROOT=
ORIGINAL_DOC_HASH_ID=
```
**NOTE:** The **NODE_ROOT** value must be path to the "root" of the Node.js install dir on RMPP. <br>
**NOTE**: For example, in my use case: **NODE_ROOT=/home/root/node-v22.10.0-linux-arm64**, **ORIGINAL_DOC_HASH_ID=131b75e8-6649-4f70-b289-63887090559e** <br>
Verify the project files, they should look like below:
```
[bash Downloads]$ ls -ltra |grep rm_calendar
drwxr-xr-x@  9 staff   288B Oct 20 20:19 rm_calendar_memo
[bash Downloads]$ lt rm_calendar_memo/
total 136
-rw-r--r--@  1 staff     0B Oct 20 13:23 rm_calendar_memo.log
-rw-r--r--@  1 staff   430B Oct 20 16:17 rm_calendar_memo.service
-rw-r--r--@  1 staff    21K Oct 20 20:15 rm_calendar_memo.md
-rw-r--r--@  1 staff   2.3K Oct 20 20:16 periodically_update_suspended_png.sh
-rw-r--r--@  1 staff   277B Oct 20 20:16 open_resize_png.js
-rw-r--r--@  1 staff   267B Oct 20 20:16 get_metadata.js
-rw-r--r--@  1 staff   248B Oct 20 20:16 .env
drwx------@ 10 staff   320B Oct 20 20:19 ..
-rw-r--r--   1 staff    51B Oct 20 20:30 package.json
-rw-r--r--   1 staff    17K Oct 20 20:30 package-lock.json
drwxr-xr-x  15 staff   480B Oct 20 20:31 node_modules
drwxr-xr-x@ 12 staff   384B Oct 20 20:31 .
```
FROM MAC/WIN | It's now needed to transfer the project folder **"rm_calendar_memo"** into the rm, under the **"/home/root"**. In my use case I use "scp" :
```
[bash Downloads]$ scp -r ./rm_calendar_memo root@<RMPP_IP_ADDRESS>:/home/root/
root@<RMPP_IP_ADDRESS>'s password:
# It would prompt you for the password, so, enter it and then hit "enter":
<RMPP_SSH_ROOT_PASSWORD>
```

* <a name="step_i"></a> **[Step I](#step_i)** FROM RMPP Terminal | Once the previous step has been executed, verify that the files have been copied correctly into the RMPP:
```
root@<MY_RMPP_HOSTNAME>:~# ls -ltra
drwxr-xr-x    4 root     root          4096 Oct 19 13:52 ..
drwxr-xr-x    3 root     root          4096 Oct 19 13:52 .local
drwxr-xr-x    3 root     root          4096 Oct 19 13:52 .journal
drwxr-xr-x    3 root     root          4096 Oct 19 13:52 .cache
drwxr-xr-x    2 root     root          4096 Oct 19 13:56 .dropbear
drwx------    2 root     root          4096 Oct 19 14:25 .ssh
drwxr-xr-x    4 root     root          4096 Oct 19 18:49 .config
-rw-------    1 root     root         14419 Oct 20 15:48 .bash_history
drwxr-xr-x    3 root     root          4096 Oct 20 15:48 .memfault
-rw-------    1 root     root         21217 Oct 20 16:07 .viminfo
drwxr-xr-x    6 root     root          4096 Oct 20 16:42 node-v22.10.0-linux-arm64
drwx------   11 root     root          4096 Oct 20 18:33 .
drwxr-xr-x    3 root     root          4096 Oct 20 18:33 rm_calendar_memo
root@<MY_RMPP_HOSTNAME>:~# ls -ltra rm_calendar_memo/
-rw-r--r--    1 root     root             0 Oct 20 18:33 rm_calendar_memo.log
-rw-r--r--    1 root     root           277 Oct 20 18:33 open_resize_png.js
drwx------   11 root     root          4096 Oct 20 18:33 ..
-rw-r--r--    1 root     root           430 Oct 20 18:33 rm_calendar_memo.service
-rw-r--r--    1 root     root         21693 Oct 20 18:33 rm_calendar_memo.md
-rw-r--r--    1 root     root          2401 Oct 20 18:33 periodically_update_suspended_png.sh
-rw-r--r--    1 root     root            51 Oct 20 18:33 package.json
-rw-r--r--    1 root     root         16909 Oct 20 18:33 package-lock.json
drwxr-xr-x   14 root     root          4096 Oct 20 18:33 node_modules
-rw-r--r--    1 root     root           267 Oct 20 18:33 get_metadata.js
-rw-r--r--    1 root     root           248 Oct 20 18:33 .env
drwxr-xr-x    3 root     root          4096 Oct 20 18:33 .
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

Oct 20 18:45:09 <MY_RMPP_HOSTNAME> systemd[1]: Started periodically update the remarkable paper pro suspended picture.
```
To make sure the scripts would run after the reboot, execute this command:
```
systemctl enable rm_calendar_memo.service
```

## ======== Optional, Debugging, Extras ====
**(OPTIONAL/DEBUGGING)** The frequency of the dynamic changes of the file "suspended.png" is set to "5 seconds", by default, but can be modified. <br>
To modify it open the file "periodically_update_suspended_png.sh" and change the value of the "sleep 5" command to your value of choice. <br>
**(OPTIONAL/DEBUGGING)** If you look into the ".env" file it has variable "RM_CALENDAR_APP_DEBUG". This variable used for troubleshooting purposes <br>
If set to the "true", the "periodically_update_suspended_png.sh" would be writing logs into the "/home/root/rm_calendar_memo/rm_calendar_memo.log" file <br>
Now, because the default frequency of the updates is "5 seconds", you can imagine, if leaving the device for 1-3 days, the log file can raise in size. <br>
So, it's useful for debugging purposes, but not for the "PROD" kinda...Here is the same output:
```
========
Right now is Sun Oct 20 19:14:09 UTC 2024. Searching for the 20.png file
* The file /home/root/.local/share/remarkable/xochitl/131b75e8-6649-4f70-b289-63887090559e.thumbnails/20.png exist.
* Creating the temporary copy of this file in the /home/root/rm_calendar_memo/ location:
cp /home/root/.local/share/remarkable/xochitl/131b75e8-6649-4f70-b289-63887090559e.thumbnails/20.png /home/root/rm_calendar_memo/;
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
node png_open_resize.js 20.png
* As the result the new resized file created. The new resized absolute filename: /home/root/rm_calendar_memo/20.png.new, and it's metadata:
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
* Copying the new resized file into the target location, while replacing the current 'suspended.png' file:
cp /home/root/rm_calendar_memo/20.png.new /usr/share/remarkable/suspended.png
* Deleting the temporary copy of the original file, as well as resized file
rm -f /home/root/rm_calendar_memo/20.png.new /home/root/rm_calendar_memo/20.png
========
```

# ======== Tested environments ====
```
* Tested combination 1 | Device: Remarkable Paper Pro, firmware: 3.15.2.1 | node22.10.0_lin_arm64, sharp0.33.5
* Tested combination 2 | Device: Remarkable Paper Pro, firmware: 3.15.3.0 | node22.10.0_lin_arm64, sharp0.33.5
```

# ======== Project structure, file index ====
```
[bash Downloads]$ tree -L 1 -h rm_calendar_memo/
[ 384]  rm_calendar_memo/
├── [ 33K]  README.md
├── [ 267]  get_metadata.js
├── [ 480]  node_modules
├── [ 277]  open_resize_png.js
├── [ 17K]  package-lock.json
├── [  51]  package.json
├── [2.4K]  periodically_update_suspended_png.sh
├── [   0]  rm_calendar_memo.log
└── [ 407]  rm_calendar_memo.service
```

# ======== Source Code | periodically_update_suspended_png.sh ====
<div style=background:#f2edd7;color:#755139>

```
#!/bin/bash
export PATH=$PATH:${NODE_ROOT}/bin
# Utility | Write the passed string into the log file
logline () {
 [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || echo "$1" &>> /home/root/rm_calendar_memo/rm_calendar_memo.log
}

while true; do

  # Day of the month
  DOM=$(date +%d)
  TODAYS_TODO_OLD_ABSOLUTE_FILENAME=/home/root/.local/share/remarkable/xochitl/${ORIGINAL_DOC_HASH_ID}.thumbnails/${DOM}.png
  TODAYS_TODO_TMP_ABSOLUTE_FILENAME=${CALENDAR_MEMO_ROOT}/${DOM}.png.new
  sleep 0.5
  logline ""; logline "========";
  logline "Right now is $(date). Searching for the ${DOM}.png file"
  if [ -f ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} ] ; then
    cd ${CALENDAR_MEMO_ROOT};
    logline "* The file ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} exist."
    logline "* Creating the temporary copy of this file in the /home/root/rm_calendar_memo/ location: "
    logline "cp ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/;"
    cp ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/;
    logline "* Here is the metadata of that newly copied file: "
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${DOM}.png &>> /dev/null || node get_metadata.js ${DOM}.png
    logline "* Resizing this temporary copy: "
    logline "node png_open_resize.js ${DOM}.png"
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node open_resize_png.js ${DOM}.png &>> /dev/null || node open_resize_png.js ${DOM}.png
    logline "* As the result the new resized file created. The new resized absolute filename: ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME}, and it's metadata: "
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${DOM}.png.new &>> /dev/null || node get_metadata.js ${DOM}.png.new
    logline "* Copying the new resized file into the target location, while replacing the current 'suspended.png' file: "
    logline "cp ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${TODAYS_TODO_NEW_ABSOLUTE_FILENAME}"
    cp ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${TODAYS_TODO_NEW_ABSOLUTE_FILENAME}
    logline "* Deleting the temporary copy of the original file, as well as resized file"
    logline "rm -f ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/${DOM}.png"
    rm -f ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/${DOM}.png
    logline "========"

  else logline "* The file ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} does NOT exist."
  fi
done
```
</div>

# ======== References ========
• [Reference 1](https://support.remarkable.com/s/article/Developer-mode) <br>
• [Reference 2](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse) <br>
• [Reference 3](https://support.remarkable.com/s/article/importing-and-exporting-files) <br>
• [Reference 4](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol) <br>
• [Reference 5](https://en.wikipedia.org/wiki/Universally_unique_identifier) <br>
