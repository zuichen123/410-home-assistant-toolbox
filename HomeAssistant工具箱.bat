@echo off
@title HomeAssistant工具箱 by:zuichen
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
setlocal enabledelayedexpansion
@echo off
:: ########## 版本号和更新配置 ##########
set "version=v1.0.4"
:: Gitee仓库的 "所有者/仓库名"
set "REPO=zuichen/410-home-assistant-toolbox"
:: Gitee API地址
set "REPO_API_URL=https://gitee.com/api/v5/repos/!REPO!/releases/latest"

:: ########## 核心：获取脚本所在目录的绝对路径 ##########
set "SCRIPT_DIR=%~dp0"
:: 定义 bin 和 img 文件夹的绝对路径
set "BIN_DIR=!SCRIPT_DIR!bin"
set "IMG_DIR=!SCRIPT_DIR!img"
set "BASE_DIR=!SCRIPT_DIR!base"
:: 定义 adb、fastboot 及镜像文件的完整路径
set "ADB=!BIN_DIR!\adb.exe"
set "FASTBOOT=!BIN_DIR!\fastboot.exe"
set "FLASHBASE=!BASE_DIR!\一键刷入工具.bat"
set "CUSTOMBASE=!BIN_DIR!\bambu_lab.zip"
set "CUSTOM_BAMBU_URL=https://gh-proxy.com/github.com/greghesp/ha-bambulab/releases/download/v2.2.10/bambu_lab.zip"
set "CUSTOM_XIAOMI_URL=https://gh-proxy.com/https://github.com/XiaoMi/ha_xiaomi_home/releases/download/v0.4.3/xiaomi_home.zip"
set "CUSTOM_XIAOMI_NAME=xiaomi_home.zip"
set "CUSTOM_BAMBU_NAME=bambu_lab.zip"
set "UV_URL="https://mirrors.ustc.edu.cn/pypi/simple""


:: ########## 日志记录机制 ##########
set "LOG_DIR=!SCRIPT_DIR!logs"
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!"
:: 创建带时间戳的日志文件名
set "DATETIME=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "DATETIME=!DATETIME: =0!"
set "LOG_FILE=!LOG_DIR!\!DATETIME!.log"
echo [!DATETIME!] Log session started. > "!LOG_FILE!"
goto :check_files

:: 日志记录子程序: :log "消息"
:log
echo %~1
echo [%date% %time%] %~1 >> "!LOG_FILE!"
goto :eof


:: ########## 检查必要文件是否存在 ##########
:check_files
call :log "检查必要文件..."
if not exist "!ADB!" (
    call :log "[!] 错误：未找到 adb 工具，路径：!ADB!"
    call :log "请确保 bin 文件夹下存在 adb.exe"
    pause
    exit /b 1
)
if not exist "!FASTBOOT!" (
    call :log "[!] 错误：未找到 fastboot 工具，路径：!FASTBOOT!"
    call :log "请确保 bin 文件夹下存在 fastboot.exe"
    pause
    exit /b 1
)
if not exist "!IMG_DIR!" (
    call :log "[!] 警告：未找到 img 文件夹，路径：!IMG_DIR!"
    call :log "将无法使用相关高级功能"
    call :log "3秒后继续..."
    timeout /t 3 /nobreak >nul
)
if not exist "!CUSTOMBASE!" (
    call :log "未找到集成压缩包！"
    call :log "正在尝试下载..."
    powershell -Command "try { (New-Object System.Net.WebClient).DownloadFile('!CUSTOM_XIAOMI_URL!', '!BIN_DIR!\!CUSTOM_XIAOMI_NAME!') } catch { Write-Host 'DOWNLOAD_FAILED'; exit 1 }" >> "!LOG_FILE!" 2>&1
    powershell -Command "try { (New-Object System.Net.WebClient).DownloadFile('!CUSTOM_BAMBU_URL!', '!BIN_DIR!\!CUSTOM_BAMBU_NAME!') } catch { Write-Host 'DOWNLOAD_FAILED'; exit 1 }" >> "!LOG_FILE!" 2>&1
    if errorlevel 1 (
        echo.
        call :log "[!] 错误：下载文件失败。请检查您的网络连接或手动下载。"
        call :log "小米集成下载链接:!CUSTOM_XIAOMI_URL!"
        call :log "拓竹集成下载链接:!CUSTOM_BAMBU_URL!"
        pause
        goto main
    )
    call :log "已自动下载，3秒后继续..."
    timeout /t 3 /nobreak >nul
)

:: ########## 跳转到更新检查 ##########
goto CheckForUpdates

:: ########## OTA 更新功能 开始 ##########
:CheckForUpdates
cls
echo ==================================================================================
echo.
call :log "正在检查更新，请稍候..."
echo.
echo ==================================================================================

:: 检查PowerShell是否存在
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    call :log "[!] 警告: 未找到 PowerShell，无法进行自动更新检查。"
    call :log "    请确保您的系统已安装 PowerShell 并将其添加至系统路径。"
	call :log "    3秒后将跳过更新检查..."
	timeout /t 3 /nobreak >nul
    goto main
)

:: 使用 PowerShell 从 Gitee API 获取最新版本号
set "LATEST_VERSION="
for /f "delims=" %%i in ('powershell -Command "$ErrorActionPreference = 'SilentlyContinue'; try { (Invoke-RestMethod -Uri '!REPO_API_URL!').tag_name } catch { Write-Output 'error' }"') do set "LATEST_VERSION=%%i"

:: 处理网络或API错误
if "!LATEST_VERSION!"=="error" (
    call :log "[!] 无法连接到 Gitee API 或获取版本信息，已跳过更新检查。"
	call :log "    可能是网络问题或仓库没有发布任何release。"
	call :log "    3秒后将继续..."
	timeout /t 3 /nobreak >nul
    goto main
)
if "!LATEST_VERSION!"=="" (
    call :log "[!] 未在Gitee仓库中找到任何有效的发布版本，跳过更新检查。"
	call :log "    3秒后将继续..."
	timeout /t 3 /nobreak >nul
    goto main
)

call :log "当前版本: !version!"
call :log "最新版本: !LATEST_VERSION!"
echo.

:: 比较版本号
if "!version!"=="!LATEST_VERSION!" (
    call :log "当前已是最新版本。"
::	timeout /t 2 /nobreak >nul
    goto main
)

echo 发现新版本 (!LATEST_VERSION!)，是否立即更新？
set /p "update_choice=请输入 (y/n) 并回车: "
echo [USER_INPUT] 用户选择: !update_choice! >> "!LOG_FILE!"
if /i "!update_choice!" NEQ "y" (
    call :log "已取消更新，继续使用当前版本。"
	timeout /t 2 /nobreak >nul
    goto main
)

goto DownloadAndUpdate
goto main


:DownloadAndUpdate
echo ----------------------------------------------------------------------
call :log "正在准备更新，请不要关闭此窗口..."

:: 定义新旧脚本文件名
set "BAT_NAME=%~nx0"
set "TEMP_BAT_NAME=%BAT_NAME%.new"

:: 使用 PowerShell 获取新版 .bat 文件的下载链接
set "DOWNLOAD_URL="
set "PS_COMMAND=(Invoke-RestMethod -Uri '!REPO_API_URL!').assets | Where-Object { $_.name.EndsWith('.bat') } | Select-Object -ExpandProperty browser_download_url"
for /f "delims=" %%i in ('powershell -Command "!PS_COMMAND!"') do set "DOWNLOAD_URL=%%i"

if "!DOWNLOAD_URL!"=="" (
    call :log "[!] 错误：在最新版本中未找到以 .bat 结尾的文件。"
    call :log "更新失败，请检查Gitee Release发布包中是否包含了工具箱的bat文件作为独立附件。"
    pause
    goto main
)

call :log "正在从以下地址下载新版本:"
call :log "!DOWNLOAD_URL!"
call :log "此地址已复制到剪贴板，如果下载失败可以用浏览器手动下载"
(echo !DOWNLOAD_URL!) | clip
echo.

:: 使用 PowerShell 下载新脚本
call :log "执行下载命令..."
powershell -Command "try { (New-Object System.Net.WebClient).DownloadFile('!DOWNLOAD_URL!', '!TEMP_BAT_NAME!') } catch { Write-Host 'DOWNLOAD_FAILED'; exit 1 }" >> "!LOG_FILE!" 2>&1
if errorlevel 1 (
    echo.
    call :log "[!] 错误：下载文件失败。请检查您的网络连接或手动前往Gitee下载。"
    if exist "!TEMP_BAT_NAME!" del "!TEMP_BAT_NAME!"
    pause
    goto main
)

call :log "下载完成。一个新窗口将弹出以完成更新并重启脚本..."
timeout /t 2 >nul

:: ##########【终极解决方案】##########
call :log "启动独立进程执行更新操作..."
start "OTA Updater" /D "%~dp0" cmd.exe /c "echo 正在应用更新，请勿关闭此窗口... & ping 127.0.0.1 -n 4 > nul & move /Y "!TEMP_BAT_NAME!" "!BAT_NAME!" > nul & echo 更新完成，正在重启... & timeout /t 2 > nul & start "" "!BAT_NAME!""

:: 立即退出当前脚本
exit
:: ########## OTA 更新功能 结束 ##########


:: ########## 主菜单 ##########
:main
cls
echo ==================================================================================
echo 欢迎使用HomeAssistant工具箱！ (当前版本: !version!)
echo 本系统基于酷安@lkiuyu编译的debian13超频版，感谢大佬的付出
echo 本系统为MakeWorld@蓝白色的蓝白碗 的拓竹打印机配件项目打造，但是并不局限于此使用场景
echo 关于手动安装HomeAssistant方法（适用于大部分linux设备）
echo 请访问http://zuichen.top:2043
echo 注意：410版号不同刷入方法也不同，不可选错
echo 注意：此刷机包使用前需要先刷入debian底包
echo 在使用此脚本前请先打开棒子的adb，打开方式并不统一
echo 本工具箱开源地址:https://gitee.com/zuichen/410-home-assistant-toolbox
echo ==================================================================================
echo.
echo HomeAssistant默认账号:bambulab   默认密码:bambulab
echo.
echo 请选择功能:
echo 1.连接wifi
echo 2.获取ip
echo 3.修改HomeAssistant密码
echo 4.创建HomeAssistant账号
echo 5.查看HomeAssistant账号
echo 6.获取HomeAssistant日志
echo 7.重启HomeAssistant
echo 8.重置HomeAssistant
echo 9.添加bambu_lab和xiaomi_home集成
echo 10.一键修复
echo 11.释放空间
echo 12.高级功能(一般情况不用进)

set "choice="
set /p "choice=请输入对应数字:"
echo [USER_INPUT] 用户选择: !choice! >> "!LOG_FILE!"

if "!choice!"=="1" goto connectwifi
if "!choice!"=="2" goto getip
if "!choice!"=="3" goto changeaccount
if "!choice!"=="4" goto creataccount
if "!choice!"=="5" goto listaccount
if "!choice!"=="6" goto getlog
if "!choice!"=="7" goto restartha
if "!choice!"=="8" goto harecovery
if "!choice!"=="9" goto pushcustom_main
if "!choice!"=="10" goto fix
if "!choice!"=="11" goto clean_main
if "!choice!"=="12" goto flash
goto error

:changeaccount
echo.
set /p "ACCOUNT=请输入账号:"
set /p "PASSWD=请输入新的密码:"
echo.
echo 要修改的账号:!ACCOUNT!
echo 新的密码:!PASSWD!
echo 确定修改吗？
echo.
set /p "sure=请输入(y/n):"
echo [USER_INPUT] 用户选择: !sure! >> "!LOG_FILE!"
if /i "!sure!" NEQ "y" goto main
set sure=n
call :log "正在为账号[!ACCOUNT!]修改密码..."
!ADB! shell "hass --script auth change_password !ACCOUNT! !PASSWD!" >> "!LOG_FILE!" 2>&1
echo.
call :log "!ACCOUNT!的密码成功改为:!PASSWD!"
echo.
echo 按任意键回到主菜单
pause
goto main

:creataccount
echo.
set /p "ACCOUNT=请输入新的账号:"
set /p "PASSWD=请输入新的密码:"
echo.
echo 新的账号:!ACCOUNT!
echo 新的密码:!PASSWD!
echo 确定创建吗？
echo.
set /p "sure=请输入(y/n):"
echo [USER_INPUT] 用户选择: !sure! >> "!LOG_FILE!"
if /i "%sure%" NEQ "y" goto main
set sure=n
call :log "正在创建新账号[!ACCOUNT!]..."
!ADB! shell "hass --script auth add !ACCOUNT! !PASSWD!" >> "!LOG_FILE!" 2>&1
echo.
call :log "成功创建新账号:!ACCOUNT!"
call :log "新账号的密码:!PASSWD!"
echo.
echo 按任意键回到主菜单
pause
goto main

:listaccount
call :log "正在获取账户名..."
!ADB! shell "hass --script auth list" >> "!LOG_FILE!" 2>&1
echo.
call :log "账户列表已输出到日志文件。"
echo 账户列表获取完成，请查看日志文件 !LOG_FILE!
pause
goto main

:restartha
echo 确定重启吗？
echo.
set /p "sure=请输入(y/n):"
echo [USER_INPUT] 用户选择: !sure! >> "!LOG_FILE!"
if /i "%sure%" NEQ "y" goto main
set sure=n
echo.
call :log "正在重启HomeAssistant..."
!ADB! shell "systemctl restart homeassistant" >> "!LOG_FILE!" 2>&1
call :log "重启完成!"
pause
goto main

:getlog
cls
call :log "正在获取HomeAssistant系统日志..."
!ADB! shell "systemctl status homeassistant -l" > log.txt 2>&1
call :log "获取完成！日志已保存在脚本目录下的log.txt中！"
call :log "日志文件已复制到剪贴板，直接粘贴即可发送！"
clip < log.txt
pause
goto main

:harecovery
cls
echo 你真的要恢复HomeAssistant为初始状态吗？
echo 注意！这个操作无法撤销！
echo HomeAssistant将恢复为初始状态，所有配置将丢失！
set /p "sure=请输入(y/n):"
echo [USER_INPUT] 用户选择: !sure! >> "!LOG_FILE!"
if /i "%sure%" NEQ "y" goto main
set sure=n
echo.
call :log "正在关闭HomeAssistant..."
!ADB! shell "systemctl stop homeassistant" >> "!LOG_FILE!" 2>&1
call :log "已关闭HomeAssistant"
echo.
call :log "正在重置(删除配置文件夹)..."
!ADB! shell "rm -rf /root/.homeassistant" >> "!LOG_FILE!" 2>&1
call :pushcustom
call :log "已重置！已无法复原！正在修复HomeAssistant..."
call :fix
goto main

:fix
cls
call :clean
call :log "[1] 更新服务文件..."
!ADB! shell "echo '[Unit]' > /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'Description=Home Assistant Service' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'After=network.target' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo '' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo '[Service]' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'Type=simple' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'User=root' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'WorkingDirectory=/root/.homeassistant' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'ExecStartPre=/bin/sleep 60' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'ExecStart=/usr/local/bin/hass' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'Restart=always' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'RestartSec=5' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'KillMode=process' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo '' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo '[Install]' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'WantedBy=multi-user.target' >> /etc/systemd/system/homeassistant.service" >> "!LOG_FILE!" 2>&1
call :log "[1] 服务文件写入完成，重新加载系统服务..."
!ADB! shell "systemctl daemon-reload" >> "!LOG_FILE!" 2>&1
call :log "[2] 为uv换源..."
!ADB! shell "mkdir -p /root/.config/uv/" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo '[[index]]' > /root/.config/uv/uv.toml" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'url = !UV_URL!' >> /root/.config/uv/uv.toml" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo 'default = true' >> /root/.config/uv/uv.toml" >> "!LOG_FILE!" 2>&1
!ADB! shell "systemctl daemon-reload" >> "!LOG_FILE!" 2>&1
call :log "[2] 换源完成"
call :log "[3] 创建swap..."
!ADB! shell "swapoff /swapfile" >> "!LOG_FILE!" 2>&1
!ADB! shell "rm -rf /swapfile" >> "!LOG_FILE!" 2>&1
!ADB! shell "dd if=/dev/zero of=/swapfile bs=1M count=100" >> "!LOG_FILE!" 2>&1
!ADB! shell "chmod 600 /swapfile" >> "!LOG_FILE!" 2>&1
!ADB! shell "mkswap /swapfile" >> "!LOG_FILE!" 2>&1
!ADB! shell "echo '/swapfile none swap sw,noatime 0 0' >> /etc/fstab" >> "!LOG_FILE!" 2>&1
call :log "[3] swap已创建"
call :log "修复已完成，正在自动重启..."
!ADB! shell "reboot" >> "!LOG_FILE!" 2>&1
call :log "重启命令已发送，3秒后返回主菜单"
timeout /t 3 /nobreak >nul
goto main

:clean_main
call :clean
call :log "空间已释放，三秒后回到主菜单"
timeout /t 3 /nobreak >nul
goto main

:clean
cls
call :log "开始清理..."
call :log "[1] 清理APT缓存..."
!ADB! shell "rm -rf /var/cache/apt/*" >> "!LOG_FILE!" 2>&1
!ADB! shell "rm -rf /var/lib/apt/lists/*" >> "!LOG_FILE!" 2>&1
!ADB! shell "apt purge" >> "!LOG_FILE!" 2>&1
!ADB! shell "apt clean" >> "!LOG_FILE!" 2>&1
call :log "[1] APT缓存清理完毕"
call :log "[2] 清理pip缓存..."
!ADB! shell "pip cache purge" >> "!LOG_FILE!" 2>&1
call :log "[2] pip缓存清理完毕"
call :log "[3] 清理日志..."
!ADB! shell "journalctl --vacuum-size=1M" >> "!LOG_FILE!" 2>&1
!ADB! shell "rm -rf /root/.homeassistant/home-assistant.log*" >> "!LOG_FILE!" 2>&1
!ADB! shell "find /var/log -name '*.log' -type f -mtime +0 -exec truncate -s 0 {} \;" >> "!LOG_FILE!" 2>&1
call :log "[3] 日志清理完成"
call :log "[4] 关闭不必要服务..."
!ADB! shell "systemctl disable exim4" >> "!LOG_FILE!" 2>&1
call :log "[4] 不必要服务已关闭"
exit /b 0

:flash
cls
echo 请选择你的板号:
echo 1. ufi003
echo 2. jz02v10
echo 3. sp970
echo 4. ufi001b
echo 5. ufi001c
echo 6. uz801
echo 7. wf2
echo 8. 刷入底包(未刷机的安卓棒子请先选择这个之后再使用其他选项)

echo.
set "choice="
set /p "choice=输入对应数字:"
echo [USER_INPUT] 用户选择: !choice! >> "!LOG_FILE!"

:: 根据选择设置板号和对应的boot镜像
if "!choice!"=="1" set "board=ufi001c"
if "!choice!"=="2" set "board=jz02v10"
if "!choice!"=="3" set "board=sp970"
if "!choice!"=="4" set "board=ufi001b"
if "!choice!"=="5" set "board=ufi001c"
if "!choice!"=="6" set "board=uz801"
if "!choice!"=="7" set "board=wf2"
if "!choice!"=="8" goto flashbase
set "choice="

:: 检查当前板号的boot镜像是否存在
set "BOOT_IMG=!IMG_DIR!\boot-!board!.img"
if not exist "!BOOT_IMG!" (
    call :log "[!] 错误：未找到 !board! 对应的boot镜像，路径：!BOOT_IMG!"
    pause
    goto main
)

:: 确认选择
cls
echo 你选择的是：!board!，确定要刷入吗？
set /p "sure=请输入(y/n):"
echo [USER_INPUT] 用户选择: !sure! >> "!LOG_FILE!"
if /i "%sure%" NEQ "y" goto main
set sure=n
goto flash_device

:flashbase
call :log "准备执行底包刷入脚本..."
!FLASHBASE! >> "!LOG_FILE!" 2>&1
goto main

:: ########## 执行刷入操作 ##########
:flash_device
cls
call :log "正在重启设备进入fastboot模式..."
"!ADB!" reboot bootloader >> "!LOG_FILE!" 2>&1
call :log "等待设备进入fastboot模式（5秒）..."
timeout /t 5 /nobreak >nul


:: 刷入boot镜像
call :log "正在刷入 boot-!board!.img..."
"!FASTBOOT!" flash boot "!BOOT_IMG!" >> "!LOG_FILE!" 2>&1

:: 刷入rootfs镜像
set "ROOTFS_IMG=!IMG_DIR!\rootfs-fastboot.img"
if not exist "!ROOTFS_IMG!" (
    call :log "[!] 错误：未找到rootfs镜像，路径：!ROOTFS_IMG!"
    pause
    exit /b 1
)
call :log "正在刷入rootfs-fastboot.img..."
"!FASTBOOT!" flash -S 100M rootfs "!ROOTFS_IMG!" >> "!LOG_FILE!" 2>&1

goto end


:: ########## 完成操作 ##########
:end
cls
call :log "恭喜！刷机已完成！"
call :log "正在重启设备..."
"!FASTBOOT!" reboot >> "!LOG_FILE!" 2>&1
call :log "等待设备重启（10秒）..."
timeout /t 10 /nobreak >nul

:: 等待设备重新连接ADB
call :log "等待设备上线..."
"!ADB!" wait-for-device devices >> "!LOG_FILE!" 2>&1
call :log "设备已上线"
call :log "正在进行最后一步操作 (resize2fs)..."
"!ADB!" shell "resize2fs /dev/mmcblk0p14" >> "!LOG_FILE!" 2>&1
call :log "操作完成！"

:: 连接WiFi
echo.
echo 需要连接WiFi吗？
set /p "sure=请输入:(y/n):"
echo [USER_INPUT] 用户选择: !sure! >> "!LOG_FILE!"
if /i "%sure%" NEQ "y" goto main
set sure=n
goto connectwifi


:: ########## WiFi连接 ##########
:connectwifi
set /p "SSID=请输入WiFi名称:"
set /p "PASSWD=请输入WIFI密码:"
echo 确定吗？确定请按输入y，否则按其他键返回
set /p "sure=确定吗？(y/n):"
echo [USER_INPUT] 用户选择: !sure! >> "!LOG_FILE!"
if /i "%sure%" NEQ "y" goto main
set sure=n
call :log "正在连接WiFi [!SSID!]..."
"!ADB!" shell "nmcli dev wifi connect '!SSID!' password '!PASSWD!'" >> "!LOG_FILE!" 2>&1
:: echo 连接命令已发送，请稍后获取IP。
:: pause
:: goto main

:getip
call :log "尝试获取ip..."
echo.
:: 将结果输出到屏幕，同时也记录到日志
for /f "delims=" %%a in ('!ADB! shell "ifconfig ^| grep -oE 'inet [0-9\.]+' ^| grep -oE '[0-9\.]+' ^| grep -vE '^127\.0\.0\.1$|^192\.168\.68\.1$'"') do (
    call :log "设备IP为: %%a"
)
!ADB! shell "ifconfig | grep -oE 'inet [0-9\.]+' | grep -oE '[0-9\.]+' | grep -vE '^127\.0\.0\.1$|^192\.168\.68\.1$' | sed 's/.*/http:\/\/&:8123/'" | clip
echo.
call :log "已尝试将正确HomeAssistant网址复制到剪贴板，在浏览器粘贴即可访问"
call :log "如果看到ip地址说明成功，如果没有看到可以多尝试几次"
pause
goto main

:error
call :log "[!] 输入错误！请重新尝试！"
set sure=n
pause
goto main

:pushcustom
call :log "正在推送集成压缩包..."
!ADB! shell "mkdir -p /root/.homeassistant/custom_components/bambu_lab" >> "!LOG_FILE!" 2>&1
!ADB! shell "mkdir -p /root/.homeassistant/custom_components/xiaomi_home" >> "!LOG_FILE!" 2>&1
!ADB! push !BIN_DIR!\!CUSTOM_BAMBU_NAME! /root/.homeassistant/custom_components/bambu_lab/ >> "!LOG_FILE!" 2>&1
!ADB! push !BIN_DIR!\!CUSTOM_XIAOMI_NAME! /root/.homeassistant/custom_components/xiaomi_home/ >> "!LOG_FILE!" 2>&1
call :log "推送完成！"
call :log "正在解压..."
!ADB! shell "unzip -o -q /root/.homeassistant/custom_components/xiaomi_home/* -d /root/.homeassistant/custom_components/xiaomi_home/" >> "!LOG_FILE!" 2>&1
!ADB! shell "unzip -o -q /root/.homeassistant/custom_components/bambu_lab/* -d /root/.homeassistant/custom_components/bambu_lab/" >> "!LOG_FILE!" 2>&1
call :log "解压完成！"
exit /b 0

:pushcustom_main
call :pushcustom
goto main
