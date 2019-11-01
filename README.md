# AutoArchive
### 一个iOS自动打包的Shell脚本
> 集成说明
 - 1.拖拽AutoTool目录到工程目录下
 - 2.修改Shell.sh工程配置信息
 
> 配置说明
  - Team_ID：自动签名的组织号码
  - project_name：工程名称
  - scheme_name：工程编译别名
  - AppStore_key：   AppStore上传key
  - AppStore_issuer：AppStore上传issuer
  - PGY_UKey：蒲公英发布使用UKey
  - PGY_AKey：蒲公英发布使用API_Key
```
  # ============项目配置信息============"
  # TeamID
  Team_ID=""
  # 工程名称
  project_name="AutoArchive"
  # 工程Scheme
  scheme_name="AutoArchive"

  # AppStore上传账号、密码
  AppStore_key="开发者账号";
  AppStore_issuer="开发者密码";

  # 蒲公英发布Ukey、Api_key
  PGY_UKey="";
  PGY_AKey="";
```

> 操作说明
  - 1.cd 到AutoTool目录下
  - 2.执行 ./Shell.sh
  - 3.选择发布的方式
  - 4.选择编译的环境
  
