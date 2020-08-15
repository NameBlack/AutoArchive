#!/bin/sh

# ============项目配置信息============"
# 工程名称
name_project="qizuang"
# 工程Scheme
name_scheme="qizuang"

# AppStore上传使用秘钥
AppStore_key="23JS8279KH";
AppStore_issuer="de2a9f39-f5f8-4416-825e-4b4d34b11cb3";

# 蒲公英发布Ukey、Api_key
PGY_UKey="a3905abac345ec2ed6e65484378786e4";
PGY_AKey="1598c6d546afe087a297d4a5226ee3bd";

# 项目路径、配置文件路径
# path_project="/Users/Home/Desktop/SourceTree/app_qz_ios/qizuang"
path_project="/Users/Home/Desktop/iOS/SwiftUI"
path_plist="/Users/Home/Pictures/AutoTool/ExportOptions.plist"

# ========================《验证路径信息》=======================
# 项目文件是否存在
if [ ! -e ${path_project} ];then
    echo "=================================="
    echo "       打包项目文件路径无效          ";
    echo "=================================="
    exit;
fi

# 导出配置文件是否存在
if [ ! -e ${path_plist} ];then
    echo "=================================="
    echo "       导出配置文件路径无效          "; 
    echo "=================================="
    exit;
fi
# ========================《操作方式选择》=========================
# 选择打包方式
Tag_output=0;
while ([ ${Tag_output} != 1 ] && [ ${Tag_output} != 2 ] && 
       [ ${Tag_output} != 3 ] && [ ${Tag_output} != 4 ]) do

    echo "选择发布方式(输入序号) 【 1:AppStore 2:Ad-Hoc 3:Enterprise 4:Development 】\n"
    read Tag_output
done

# 选择编译方式
if [ "${Tag_output}" != 1 ];then
    Tag_build=0;
    while ([ ${Tag_build} != 1 ] && [ ${Tag_build} != 2 ]) do
        echo "选择编译方式(输入序号) 【 1:Release 2:Debug 】\n"
        read Tag_build
    done
fi

# 选择发布方式
if [ "${Tag_output}" != 1 ];then
    Tag_upload=0;
    while ([ ${Tag_upload} != 1 ] && [ ${Tag_upload} != 2 ]) do

        echo "选择发布方式(输入序号) 【 1:蒲公英  2:不发布 】\n"
        read Tag_upload
    done
fi
# ========================《配置导出文件》=========================
# 编译方式
if [ "${Tag_output}" == 1 -o "${Tag_build}" == 1 ];then
    configuration="Release";
else
    configuration="Debug";
fi
# 打包方式
case ${Tag_output} in
    1) method="app-store";;
    2) method="ad-hoc";;    
    3) method="enterprise";;
    4) method="development";;
esac
/usr/libexec/PlistBuddy -c "Set :method ${method}" ${path_plist}

# ========================《设置文件路径》=========================
# 桌面路径
desktop=$(cd ~/Desktop/;pwd)
# 打包路径
package="${desktop}/package"
# 当前时间
dateStr=$(date '+%Y-%m-%d-%H:%M:%S')

# 导出目录
path_export="${package}/${dateStr}"
# 归档文件
path_archive="${path_export}/${name_project}.xcarchive"
# ipa文件
path_ipa="${path_export}/${name_project}.ipa"

cd ${path_project}
# ========================《开始打包操作》=========================
echo "============开始清洁工程============"
echo "\n\n\n"
xcodebuild clean -configuration ${configuration} -quiet
# 工程清洁结果
if [ $? = 0 ];then

    echo "******     Clean  Success     ******";
    echo "====================================";
else

    echo "******     Clean  Failure     ******";
    echo "====================================";
    exit
fi

echo "============开始编译工程============"
echo "\n\n"
# 项目是否使用cocoapods 管理
if [ -e "${name_project}.xcworkspace" ];then 

    # 编译文件路径
    path_workspace="${path_project}/${name_project}.xcworkspace"
    
    # 打包命令
    xcodebuild OTHER_CFLAGS="-fembed-bitcode" \
    archive                          \
    -scheme        ${name_scheme}    \
    -workspace     ${path_workspace} \
    -configuration ${configuration}  \
    -archivePath   ${path_archive}  -quiet
elif [ -e "${name_project}.xcodeproj" ];then

    # 编译文件路径
    path_xcodeproj="${path_project}/${name_project}.xcodeproj"  

    # 打包命令
    xcodebuild  OTHER_CFLAGS="-fembed-bitcode" \
    archive                           \
    -scheme         ${name_scheme}    \
    -project        ${path_xcodeproj} \
    -configuration  ${configuration}  \
    -archivePath    ${path_archive}  -quiet
else

    echo "******    当前目录缺少工程文件    ******";
    echo "====================================";
    exit
fi
# 工程编译结果
if [ -e ${path_archive} -a $?=0 ];then

    echo "\n\n"
    echo "******    Archive  Success    ******"; 
    echo "====================================";

else

    echo "\n\n"
    echo "******    Archive  Failure    ******";
    echo "====================================";
    exit
fi

echo "============开始导出工程============"
echo "\n\n"
# 导出命令
xcodebuild     OTHER_CFLAGS="-fembed-bitcode" \
-exportArchive                       \
-archivePath        ${path_archive}  \
-configuration      ${configuration} \
-exportPath         ${path_export}   \
-exportOptionsPlist ${path_plist} -quiet

# 导出安装包是否成功
if [ -e ${path_ipa} -a $?=0 ];then

    echo "\n\n"
    echo "******    Export   Success    ******"; 
    echo "====================================";
else

    echo "\n\n"
    echo "******    Export   Failure    ******"; 
    echo "====================================";
    exit
fi

# ========================《安装包操作函数》=========================
# AppStore验证App
function validate_appStore(){

    echo "==========AppStore(验证APP)========="
    echo "\n\n"
    # AppStore验证命令
    xcrun altool --validate-app -f $ipa_path -t ios --apiKey $AppStore_key --apiIssuer $AppStore_issuer -quiet

    # AppStore验证结果
    if [ $? != 0 ];then

        echo "\n\n"
        echo "******    AppStore验证失败    ******";
        echo "====================================";
    else

        echo "\n\n"
        echo "******    AppStore验证成功    ******";
        echo "====================================";
    fi
}
# AppStore上传APP
function upload_appStore(){

    echo "==========AppStore(上传APP)========="
    echo "\n\n"
    # AppStore上传命令
    xcrun altool --upload-app -f $ipa_path -t ios --apiKey $AppStore_key --apiIssuer $AppStore_issuer -quiet     

    # AppStore上传结果
    if [ $? != 0 ];then

        echo "\n\n"
        echo "******    AppStore上传失败    ******";
        echo "====================================";
    else

        echo "\n\n"
        echo "******    AppStore上传成功    ******";
        echo "====================================";
    fi
}
# 蒲公英上传App
function upload_pgy(){

    echo "=============蒲公英发布============="
    echo "\n\n"
    # 蒲公英发布命令
    RESULT=$(curl                      \
            -F "file=@${path_ipa}"     \
            -F "uKey=${PGY_UKey}"      \
            -F "_api_key=${PGY_AKey}"  \
            http://www.pgyer.com/apiv1/app/upload)

    # 命令执行失败
    if [  $? != 0 ];then

        echo "\n\n"
        echo "******     蒲公英发布失败     ******";
        echo "====================================";
        exit;
    fi

    # 蒲公英发布结果
    code=`echo $RESULT | awk -F 'code\":' '{print $2}'| awk -F ',' '{print $1}'`;
    if [  "${code}" = 0 ];then

        echo "\n\n"
        echo "******     蒲公英发布成功     ******"; 
        echo "====================================";
    else

        echo "\n\n"
        echo "******     蒲公英发布失败     ******";
        echo "====================================";
    fi
}


#  ipa发布流程
if [ "${Tag_output}" = 1 ];then

   validate_appStore
   if [ $? != 0 ];then

        upload_appStore
   fi
elif [ "${Tag_upload}" = 1 ];then

    upload_pgy
else
    exit;
fi

