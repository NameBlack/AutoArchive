#!/bin/sh

# ============项目配置信息============"
# TeamID
Team_ID=""
# 工程名称
project_name=""
# 工程Scheme
scheme_name=""

# AppStore上传账号、密码
AppStore_key="";
AppStore_issuer="-17c2-423d-ba98-7cae59fc18fa";

# 蒲公英发布Ukey、Api_key
PGY_UKey="";
PGY_AKey="";

# ============选择打包方式============"
Tag_output=0;
while ([ $Tag_output != 1 ] && [ $Tag_output != 2 ] && [ $Tag_output != 3 ] && [ $Tag_output != 4 ]) do
    echo "选择发布方式(输入序号) 【 1:AppStore 2:Ad-Hoc 3:Enterprise 4:Development 】\n"
    read Tag_output
done

# ============选择编译方式============"
if [ "$Tag_output" != 1 ];then
    Tag_build=0;
    while ([ $Tag_build != 1 ] && [ $Tag_build != 2 ]) do
        echo "选择编译方式(输入序号) 【 1:Release 2:Debug 】\n"
        read Tag_build
    done
fi

# ============配置导出文件============"
if [ "$Tag_output" == 1 -o "$Tag_build" == 1 ];then
    configuration="Release";
else
    configuration="Debug";
fi
case "$Tag_output" in
    1) method="app-store";;
    2) method="ad-hoc";;    
    3) method="enterprise";;
    4) method="development";;
esac
/usr/libexec/PlistBuddy -c "Set :method ${method}"  ExportOptions.plist
/usr/libexec/PlistBuddy -c "Set :teamID ${Team_ID}" ExportOptions.plist

# ============文件路径信息============"
# 工程绝对路径
project_path=$(cd `dirname $0`;cd ..; pwd)
# 配置文件路径
plist_path="${project_path}/AutoTool/ExportOptions.plist";
# IPA目录路径
ipa_filePath="${project_path}/AutoTool/Build/${project_name}"
# 编译存储路径
archive_path="${project_path}/AutoTool/Build/${project_name}.xcarchive"

# 导出配置文件是否存在
if [ ! -e $plist_path ];then
    echo "=================================="
    echo "       没有找到导出配置文件          "; 
    echo "=================================="
    exit;
fi
# 删除编译存储目录
rm -rf "${project_path}/AutoTool/Build"

echo "=================================="
echo "===========开始清洁工程===========\n\n"
cd ..
xcodebuild clean -configuration ${configuration} -quiet
# 工程清洁结果
if [ $? = 0 ];then
    echo "****     Clean  Success     ****";
else
    echo "****     Clean  Failure     ****";
    echo "==================================";
    exit
fi

echo "===========开始编译工程===========\n\n"
# 项目是否使用cocoapods 管理
if [ -e "${project_name}.xcworkspace" ];then 

    # 编译文件路径
    workspace_path="${project_path}/${project_name}.xcworkspace"
    # 打包命令
    xcodebuild archive \
    -scheme       ${scheme_name} \
    -workspace ${workspace_path} \
    -configuration ${configuration} \
    -archivePath ${archive_path}  -quiet
elif [ -e "${project_name}.xcodeproj" ];then

    # 编译文件路径
    workspace_path="${project_path}/${project_name}.xcodeproj"  
    # 打包命令
    xcodebuild archive \
    -scheme       ${scheme_name} \
    -project   ${workspace_path} \
    -configuration ${configuration} \
    -archivePath ${archive_path}  -quiet
else
    echo "****    当前目录缺少工程文件    ****";
    echo "==================================";
    exit
fi

# 工程编译结果
if [ -e ${archive_path} -a $?=0 ];then
    echo "\n\n****    Archive  Success    ****"; 
else
    echo "\n\n****    Archive  Failure    ****";
    echo "=================================="
    exit
fi

echo "===========开始导出工程===========\n\n"
# 导出命令
xcodebuild -exportArchive -archivePath ${archive_path} \
-configuration ${configuration} \
-exportPath ${ipa_filePath} \
-exportOptionsPlist ${plist_path} -quiet

# IPA文件路径
ipa_path="${ipa_filePath}/${project_name}.ipa";
# 导出安装包是否成功
if [ -e $ipa_path -a $?=0 ];then
    echo "\n\n****    Export  Success    ****"; 
else
    echo "\n\n****    Export  Failure    ****"; 
    echo "=================================="
    exit
fi

# 文件上传、发布操作
if [ "$Tag_output" = 1 ];then
    echo "=========AppStore(验证APP)========\n\n"
    # AppStore验证命令
    xcrun altool --validate-app -f $ipa_path -t ios --apiKey $AppStore_key --apiIssuer $AppStore_issuer -quiet

    # AppStore验证结果
    if [ $? != 0 ];then
        echo "\n\n****    AppStore验证失败    ****";
        break;
    else
        echo "\n\n****    AppStore验证成功    ****";
    fi

    echo "=========AppStore(上传APP)========\n\n"
    # AppStore上传命令
    xcrun altool --upload-app -f $ipa_path -t ios --apiKey $AppStore_key --apiIssuer $AppStore_issuer -quiet     

    # AppStore上传结果
    if [ $? != 0 ];then
        echo "\n\n****    AppStore上传失败    ****";
    else
        echo "\n\n****    AppStore上传成功    ****";
    fi
else
    echo "============蒲公英发布============\n\n"
    # 蒲公英发布命令
    RESULT=$(curl -F "file=@$ipa_path" \
            -F "uKey=${PGY_UKey}"      \
            -F "_api_key=${PGY_AKey}"  \
            http://www.pgyer.com/apiv1/app/upload)
    
    # 蒲公英发布结果验证
    code=`echo $RESULT | awk -F 'code\":' '{print $2}'| awk -F ',' '{print $1}'`;
    if [  $?=0 -a $code=0 ];then
        echo "\n\n****     蒲公英发布成功     ****"; 
    else
        echo "\n\n****     蒲公英发布失败     ****";
    fi
fi

#.删除打包文件夹
rm -rf "${project_path}/AutoTool/Build";
echo "=================================="