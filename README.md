# Mizaru

![Mizaru](img/mizaru.png)

This simple framework prevents your Munki-managed Macs from checking in unless they can access your Munki repo.

## Why would I need this?

If you run a Munki repo accessible only within your company's internal network, Mizaru allows you to make sure your Macs only check in when they're connected to that network.

This reduces unnecessary network traffic, ensures your Macs don't check into other organizations' Munki repositories, and helps prevent certain rare types of "man in the middle" attacks. (See page 52 of the "Introduction to Offensive Security" slides linked from [PSU MacAdmins resources page](http://macadmins.psu.edu/conference/resources/).)

The workflow was designed to be used by consultants who frequently visit multiple networks with a valid repository at http://munki/repo and a site_default manifest.

## Setup

1. In your Munki repo, create a text file called mizaru. Fill the file with whatever you like.
1. Get the hash of the verification URL by running this command (substituting your actual Munki repo URL for munki.example.com):

    ```
    curl -s "https://munki.example.com/repo/mizaru" | md5
    ```

1. Open the mizaru.sh script file with a text editor.
1. Change the `TEST_URL` value to the verification URL you used in the `curl` command above.
1. Change the `HASH` value to the result of the command above (it will be a series of numbers and letters).
1. Create the installer package using [munkipkg](https://github.com/munki/munki-pkg) and the files provided in this project. The package will be generated in the build folder.
1. Import the package to your Munki repo and add to the appropriate catalogs and manifests.
1. Enable "unattended install" in the pkginfo, and make it a "managed install" in the manifest.
1. On a test Mac, install Mizaru using Managed Software Center, then run the following to verify that the Munki daemons are loaded:

    ```
    sudo launchctl list | grep munki
    ```

1. Now turn off Wi-Fi and run the same command again, and verify that the Munki daemons are _not_ loaded.

## Removal

Here is an uninstall script that you can use to remove this tool, if you ever choose to.

```
sudo launchctl unload -w /Library/LaunchDaemons/com.elliotjordan.mizaru.plist
rm -f /Library/LaunchDaemons/com.elliotjordan.mizaru.plist
rm -f /Library/Scripts/mizaru.sh
```

## Credits

Emoji art supplied by [EmojiOne](http://emojione.com/).
