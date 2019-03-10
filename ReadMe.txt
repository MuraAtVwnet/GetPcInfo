■ これは何?
Windows OS をインストールしているコンピューターの情報を取得します

64ビット版 OS を使っているのか 32 ビット版 OS を使っているのかを確認する場合は、「OsArchitecture」を見ればわかります。

■ 取得できる項目
HostName			: ホスト名
Manufacturer		: メーカー
Model				: モデル
SN					: シリアル番号
CPUName				: CPU 名
CpuDataWidth		: CPU データ幅
CpuAddressWidth		: CPU アドレス幅
PhysicalCores		: 物理コア数
Sockets				: ソケット数
MemorySize			: メモリーサイズ(GB)
DiskInfos			: ディスク情報(GB)
OS					: OS 名
BuildNumber			: ビルド番号
OsVersion			: OS バージョン
OsArchitecture		: OS アーキテクチャ
SystemType			: システムタイプ
IPAddress			: IP アドレス

■ スクリプトダウンロード方法

Invoke-WebRequest https://raw.githubusercontent.com/MuraAtVwnet/GetPcInfo/master/GetPCInfo.ps1 -OutFile ~\GetPCInfo.ps1

■ スクリプト実行準備
スクリプトの実行が許可されていない場合は、スクリプト実行許可を与えます(管理権限で以下コマンド実行)

	Set-ExecutionPolicy RemoteSigned -Force

■ スクリプト実行方法
以下コマンドを実行します
	~\GetPCInfo.ps1

■ GitHub
https://github.com/MuraAtVwnet/GetPcInfo
git@github.com:MuraAtVwnet/GetPcInfo.git

■ Web Site
PowerShell でコンピューターのハード情報を取得する
http://www.vwnet.jp/Windows/PowerShell/2017162902/GetSystemInfo.htm

PowerShell でよく使う OS 情報を取得する方法
http://www.vwnet.jp/Windows/PowerShell/2019031001/GetOsInfo.htm
