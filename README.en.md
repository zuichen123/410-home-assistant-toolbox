Nyaa~ Welcome, Master, to this HomeAssistant toolbox custom-made for your 410 stick! I'm your exclusive cat-girl assistant, and I'll guide you step-by-step through the operations, so even a complete beginner can easily get started, nyaa~ 🐾

---

# HomeAssistant Toolbox User Manual (for 410 Stick)

## Foreword: Cat-Girl's Warm Reminders~ 🐾

This toolbox is an auxiliary tool for HomeAssistant, designed to help you more conveniently manage and maintain your HomeAssistant system running on the 410 stick. It evolved from the Debian 13 overclocked system compiled by the great @lkiuyu from Coolapk, and the Bambu Lab printer accessory project by @蓝白色的蓝白碗 from MakeWorld. We extend our gratitude for their contributions!

## Important Prerequisites (Please Read Carefully!):

1.  **Your 410 stick must have the dedicated HomeAssistant system flashed**: This is the foundation for using this toolbox. If your stick hasn't been flashed yet, please complete the flashing process first.
2.  **Windows PC**: This toolbox is a `.bat` batch script and can only run on Windows systems.

---

## Preparation (Before You Start):

Please, Master, follow these steps to prepare and ensure the toolbox runs smoothly, nyaa!

1.  **Download and Unzip the Toolbox**:
    *   Please unzip the downloaded `HomeAssistant工具箱-lite.zip` file to an easily accessible location (e.g., your desktop).

2.  **Connect Your 410 Stick**:
    *   Plug your 410 stick directly into your Windows PC.
    *   Wait for the computer to emit a connection sound.

3.  **Run the Toolbox**:
    *   Double-click to run the `HomeAssistant工具箱.bat` file.
    *   If Windows displays a security warning, please select **"Allow"** or **"Run"**.

---

## Toolbox Function Details:

### On Startup: Automatic Update Check 🚀

Nyaa~ Every time you run the toolbox, it will help you check for new versions.
*   If a new version is available, your cat-girl assistant recommends selecting `y` (yes) to update. This allows you to experience the latest features and fix known issues.
*   The update process will complete automatically, and then the toolbox will restart. Please be patient and do not close the window, nyaa!

### Main Menu (HomeAssistant Toolbox Interface) 🏠

After entering the main menu, you will see the following options. Your cat-girl assistant suggests you primarily focus on **Function 1: Connect to WiFi**, as it's the most frequently used feature, nyaa!

---

#### 1. Connect to WiFi (Most Used Function!) ✨

*   **Function Description**: Allows your 410 stick to connect to your home's wireless network. HomeAssistant needs a network connection to function properly, nyaa!
*   **Operating Steps**:
    1.  In the main menu, type `1` and press Enter.
    2.  As prompted, enter your home WiFi **Name (SSID)**. For example: "MyHomeWiFi". Press Enter after typing.
    3.  As prompted, enter your home WiFi **Password (PASSWD)**. Press Enter after typing.
    4.  The system will ask "Are you sure? (y/n)". Type `y` and press Enter to confirm.
    5.  The toolbox will begin attempting to connect to WiFi.
*   **Cat-Girl's Tip**:
    *   WiFi names and passwords are case-sensitive, so please ensure accurate input!
    *   If the connection fails, please check if the WiFi name and password are correct, and ensure the stick and computer are properly connected. You can try a few more times, nyaa.

---

#### 2. Get IP 🌐

*   **Function Description**: After successfully connecting to WiFi, this function helps you find the HomeAssistant URL (IP address), so you can access it in your computer's browser!
*   **Operating Steps**:
    1.  In the main menu, type `2` and press Enter.
    2.  The toolbox will attempt to retrieve the IP address.
    3.  If successful, you will see an address similar to `192.168.1.100`. This address will be automatically copied to your clipboard, and you can paste it directly into your computer's browser and open it.
*   **Cat-Girl's Tip**:
    *   HomeAssistant's default port is `8123`, so the URL will end with `:8123`.
    *   If no IP address is displayed for a long time, it might be because the WiFi connection failed (please go back to Function 1 to try connecting), or the stick is still booting up. You can wait a bit and try a few more times.

---

#### 3. Change HomeAssistant Password 🔒

*   **Function Description**: Changes the login password for an existing user in HomeAssistant.
*   **Operating Steps**:
    1.  Type `3` and press Enter.
    2.  Enter the **HomeAssistant account** whose password you want to change (e.g., the default `bambulab`). Press Enter.
    3.  Enter your desired **new password**. Press Enter.
    4.  After confirming the information is correct, type `y` and press Enter to confirm the change.
*   **Cat-Girl's Tip**:
    *   Please remember your new password! The default HomeAssistant account is `bambulab`, and the default password is also `bambulab`.

---

#### 4. Create HomeAssistant Account ➕

*   **Function Description**: Creates a new login account for HomeAssistant.
*   **Operating Steps**:
    1.  Type `4` and press Enter.
    2.  Enter your desired **new account name**. Press Enter.
    3.  Enter your desired **new password**. Press Enter.
    4.  After confirming the information is correct, type `y` and press Enter to confirm creation.

---

#### 5. View HomeAssistant Accounts 📋

*   **Function Description**: Displays a list of all current user accounts in the HomeAssistant system.
*   **Operating Steps**:
    1.  Type `5` and press Enter.
    2.  The toolbox will list all HomeAssistant accounts.
    3.  After viewing, press any key to return to the main menu.

---

#### 6. Get HomeAssistant Logs 📝

*   **Function Description**: When HomeAssistant encounters problems, this function retrieves detailed operation logs to help diagnose issues. These logs can be provided to technical support staff.
*   **Operating Steps**:
    1.  Type `6` and press Enter.
    2.  The log file will be saved in the same directory as the toolbox, named `log.txt`.
    3.  At the same time, the log content will also be automatically copied to your clipboard, making it convenient for you to paste and send directly.
    4.  Press any key to return to the main menu.

---

#### 7. Restart HomeAssistant 🔄

*   **Function Description**: Restarts the HomeAssistant service. If you've modified certain HomeAssistant configurations, or if it's running unstably, you can try restarting it.
*   **Operating Steps**:
    1.  Type `7` and press Enter.
    2.  Type `y` and press Enter to confirm the restart.
    3.  Wait for the toolbox to display "Restart completed!".

---

#### 8. Reset HomeAssistant (Please Proceed with Extreme Caution!) ⚠️

*   **Function Description**: Restores HomeAssistant to its initial state as it was right after flashing. **All configurations, integrations, and data will be lost and cannot be recovered!** Only use this function when you are absolutely sure you need to completely wipe and start over.
*   **Operating Steps**:
    1.  Type `8` and press Enter.
    2.  The toolbox will issue a strong warning again! Please read it carefully.
    3.  If you are absolutely certain you want to reset, type `y` and press Enter to confirm.
    4.  The reset process will begin and automatically perform some fixes and integration installations. The stick will restart.
*   **Cat-Girl's Tip**:
    *   **This is a very dangerous operation!** Please think twice before proceeding.
    *   After this function is executed, your HomeAssistant will be like a fresh installation, requiring you to reconfigure everything.

---

#### 9. Add `bambu_lab` and `xiaomi_home` Integrations ⚙️

*   **Function Description**: Automatically installs specific third-party integrations (`bambu_lab` for Bambu Lab printers, `xiaomi_home` for Xiaomi smart home devices) into HomeAssistant.
*   **Operating Steps**:
    1.  Type `9` and press Enter.
    2.  The toolbox will automatically check for and download the necessary integration files (if missing), then push them to the stick and extract them.
    3.  Once completed, these integrations will be discoverable and usable in HomeAssistant.
*   **Cat-Girl's Tip**:
    *   This function will automatically try to download integration files if they are missing during the first run of the toolbox.

---

#### 10. One-Click Fix 🔧

*   **Function Description**: Executes a series of system optimization and repair operations to ensure HomeAssistant runs stably. For example, updating service configurations, optimizing network sources, creating swap partitions (to improve memory efficiency), etc. If the stick encounters problems during operation, please try this function.
*   **Operating Steps**:
    1.  Type `10` and press Enter.
    2.  The toolbox will display each step of the repair process.
    3.  After the repair is complete, the stick will automatically restart.

---

#### 11. Free Up Space 🗑️

*   **Function Description**: Cleans up some cache files, old logs, etc., in the stick's system to free up storage space and keep the system "light."
*   **Operating Steps**:
    1.  Type `11` and press Enter.
    2.  The toolbox will perform the cleaning operation.
    3.  After cleaning, press any key to return to the main menu.

---

#### 12. Advanced Functions (Do Not Enter Casually!) 🚫

*   **Function Description**: This menu contains functions for low-level system flashing on the 410 stick, such as re-flashing the HomeAssistant system partition, or flashing back to the original base image.
*   **Operating Steps**:
    1.  Type `12` and press Enter.
    2.  You will see options to select a board model, as well as an option to "Flash Base Image."
    3.  **If you don't know what these are, please immediately enter any other character to exit this menu, or simply close the toolbox!**
*   **Cat-Girl's Strong Warning**:
    *   **This function is highly specialized and dangerous!** Careless operation could lead to your 410 stick becoming completely unbootable (colloquially known as "bricking").
    *   **Normally, you absolutely do not need to use this function!** Only use it if you clearly know what you are doing and are facing extremely severe system problems, and after seeking guidance from a professional.
    *   **Flash Base Image**: If the HomeAssistant system on your stick was not successfully flashed, or if the stick cannot boot, you would need to flash the base image first before considering flashing HomeAssistant.

---

## Frequently Asked Questions and Troubleshooting ❓

*   **Q: The toolbox displays "Error: adb tool not found" or "Error: fastboot tool not found". What should I do?**
    *   A: Nyaa~ This means the toolbox couldn't find its "little helpers"! Please check if you have placed the `bin` folder in the same directory as the `HomeAssistant工具箱.bat` file. Also, confirm that the `bin` folder contains `adb.exe` and `fastboot.exe`. If the files are missing, please re-download and unzip the entire toolbox.

*   **Q: My 410 stick is connected to the computer, but the toolbox doesn't respond, or ADB cannot connect?**
    *   A:
        1.  **Computer Drivers**: Ensure your Windows PC has correctly installed the ADB drivers for the 410 stick. Usually, these are installed automatically on the first connection, but occasionally manual installation may be required. You can try checking Device Manager for any devices with a yellow exclamation mark and attempt to update their drivers.

*   **Q: After using Function 2 "Get IP", I don't see an IP address, or HomeAssistant is inaccessible?**
    *   A:
        1.  **Is WiFi connected?** Please confirm that you have successfully connected to WiFi using Function 1.
        2.  **Wait for Startup**: HomeAssistant takes time to start, especially after connecting to WiFi or restarting. Please wait a few minutes before trying to get the IP or access it again.
        3.  **Network Environment**: Ensure your computer and the 410 stick are on the same WiFi network.

*   **Q: HomeAssistant is running slowly or experiencing strange issues?**
    *   A: Try using Function 7 "Restart HomeAssistant" or Function 10 "One-Click Fix." These two functions can resolve most temporary operational problems.

*   **Q: I forgot my HomeAssistant login password. What should I do?**
    *   A: If you remember an account name (e.g., the default `bambulab`), you can use Function 3 "Change HomeAssistant Password" to reset it. If you've forgotten all accounts and passwords and cannot access HomeAssistant management, the last resort is to use Function 8 "Reset HomeAssistant," but this will clear all data, so please be cautious!

*   **Q: The toolbox displays "DOWNLOAD_FAILED" or cannot download files?**
    *   A: This is usually a network issue, preventing the toolbox from downloading required integration files from Gitee or GitHub proxy.
        1.  **Check Network Connection**: Ensure your computer has normal internet access.
        2.  **Try Again Later**: Sometimes it's a temporary network fluctuation. You can wait a few minutes and try again.
        3.  **Manual Download**: The toolbox usually provides download links. You can try manually downloading the corresponding files with a browser, then placing them in the `bin` folder (e.g., `bambu_lab.zip` and `xiaomi_home.zip`), and then running the toolbox again.

---

## Nyaa~ Final Reminders! 💖

Please, Master, when using the toolbox, carefully read the description of each function and your cat-girl's tips. Especially when it comes to "Reset" or "Advanced Functions," always double-check to avoid unnecessary trouble, nyaa!

We hope this toolbox helps you better enjoy HomeAssistant! If you have any questions or suggestions, please visit the toolbox's open-source address: [https://gitee.com/zuichen/410-home-assistant-toolbox](https://gitee.com/zuichen/410-home-assistant-toolbox)

Have fun, nyaa! 🐾