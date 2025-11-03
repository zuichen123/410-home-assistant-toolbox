@echo off
@title HomeAssistant工具箱 by:zuichen
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
setlocal enabledelayedexpansion

:: ########## 核心：获取脚本所在目录的绝对路径 ##########
:: %~dp0 表示当前脚本所在目录的绝对路径（含末尾反斜杠）
set "SCRIPT_DIR=%~dp0"
:: 定义 bin 和 img 文件夹的绝对路径
set "BIN_DIR=!SCRIPT_DIR!bin"
set "IMG_DIR=!SCRIPT_DIR!img"
set "BASE_DIR=!SCRIPT_DIR!base"
:: 定义 adb、fastboot 及镜像文件的完整路径
set "ADB=!BIN_DIR!\adb.exe"
set "FASTBOOT=!BIN_DIR!\fastboot.exe"
set "FLASHBASE=!BASE_DIR!\一键刷入工具.bat"


:: ########## 检查必要文件是否存在 ##########
:check_files
echo 检查必要文件...
if not exist "!ADB!" (
    echo 错误：未找到 adb 工具，路径：!ADB!
    echo 请确保 bin 文件夹下存在 adb.exe
    pause
    exit /b 1
)
if not exist "!FASTBOOT!" (
    echo 错误：未找到 fastboot 工具，路径：!FASTBOOT!
    echo 请确保 bin 文件夹下存在 fastboot.exe
    pause
    exit /b 1
)
if not exist "!IMG_DIR!" (
    echo 错误：未找到 img 文件夹，路径：!IMG_DIR!
    pause
    exit /b 1
)
goto main




:: ########## 主菜单 ##########
:main
cls
echo ==================================================================================
echo 欢迎使用HomeAssistant工具箱！
echo 本系统基于酷安@lkiuyu编译的debian13超频版，感谢大佬的付出
echo 本系统为MakeWorld@蓝白色的蓝白碗 的拓竹打印机配件项目打造，但是并不局限于此使用场景
echo 关于手动安装HomeAssistant方法（适用于大部分linux设备）
echo 请访问http://zuichen.top:2043
echo 注意：410版号不同刷入方法也不同，不可选错
echo 主意：此刷机包使用前需要先刷入debian底包
echo 在使用此脚本前请先打开棒子的adb，打开方式并不统一
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
echo 6.高级功能(一般情况不用进)

set /p "choice=请输入对应数字:"
if "!choice!"=="1" goto connectwifi
if "!choice!"=="2" goto getip
if "!choice!"=="3" goto changeaccount
if "!choice!"=="4" goto creataccount
if "!choice!"=="5" goto listaccount
if "!choice!"=="6" goto flash
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
if "%sure%" NEQ "y" goto main
set sure=n
!ADB! shell "hass --script auth change_password !ACCOUNT! !PASSWD!"
echo.
echo !ACCOUNT!的密码成功改为:!PASSWD!
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
if "%sure%" NEQ "y" goto main
set sure=n
!ADB! shell "hass --script auth add !ACCOUNT! !PASSWD!
echo.
echo 成功创建新账号:!ACCOUNT!
echo 新账号的密码:!PASSWD!
echo.
echo 按任意键回到主菜单
pause
goto main

:listaccount
echo 正在获取账户名...
!ADB! shell "hass --script auth list"
pause
goto main

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
    echo 错误：未找到 !board! 对应的boot镜像，路径：!BOOT_IMG!
    pause
    goto main
)

:: 确认选择
cls
echo 你选择的是：!board!，确定要刷入吗？
set /p "sure=请输入(y/n):"
if "%sure%" NEQ "y" goto main
set sure=n
goto flash_device

:flashbase
!FLASHBASE!
goto main

:: ########## 执行刷入操作 ##########
:flash_device
cls
echo 正在重启设备进入fastboot模式...
"!ADB!" reboot bootloader
echo 等待设备进入fastboot模式（5秒）...
timeout /t 5 /nobreak >nul


:: 刷入boot镜像
echo 正在刷入 boot-!board!.img...
"!FASTBOOT!" flash boot "!BOOT_IMG!"

:: 刷入rootfs镜像
set "ROOTFS_IMG=!IMG_DIR!\rootfs-fastboot.img"
if not exist "!ROOTFS_IMG!" (
    echo 错误：未找到rootfs镜像，路径：!ROOTFS_IMG!
    pause
    exit /b 1
)
echo 正在刷入rootfs-fastboot.img...
"!FASTBOOT!" flash -S 100M rootfs "!ROOTFS_IMG!"

goto end


:: ########## 完成操作 ##########
:end
cls
echo 恭喜！刷机已完成！
echo 正在重启设备...
"!FASTBOOT!" reboot
echo 等待设备重启（10秒）...
timeout /t 10 /nobreak >nul

:: 等待设备重新连接ADB
echo 等待设备上线...
"!ADB!" wait-for-device devices
echo 设备已上线

:: 连接WiFi
echo.
echo 需要连接WiFi吗？
set /p "sure=请输入:(y/n):"
if "%sure%" NEQ "y" goto main
set sure=n
goto connectwifi


:: ########## WiFi连接 ##########
:connectwifi
set /p "SSID=请输入WiFi名称:"
set /p "PASSWD=请输入WIFI密码:"
echo 确定吗？确定请按输入y，否则按其他键返回
set /p "sure=确定吗？(y/n):"
echo 正在连接...
if "%sure%" NEQ "y" goto main
set sure=n
"!ADB!" shell "nmcli dev wifi connect "%SSID%" password "%PASSWD%""

:getip
echo 尝试获取ip
echo 设备IP是:
echo.
"!ADB!" shell "ifconfig | grep -Eo 'inet (192\.168(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){2})' | grep -Eo '192\.168[^ ]*' | grep -v '192.168.68.1'"
echo.
echo 如果看到192.168开头的ip地址说明成功，如果没有按回车可以再尝试一次，获取到之后记下IP就可以关闭脚本了
pause
goto main

:error
echo 输入错误！请重新尝试！
set sure=n
pause
goto main





endlocal