#####################################################################
# システム情報
#####################################################################
function QueryPcInfo(){
    $ReturnData = New-Object PSObject | Select-Object   HostName,`          # ホスト名
                                                        Manufacturer,`      # メーカー
                                                        Model,`             # モデル
                                                        SN,`                # シリアル番号
                                                        CPUName,`           # CPU 名
                                                        CpuDataWidth,`      # CPU データ幅
                                                        CpuAddressWidth,`   # CPU アドレス幅
                                                        PhysicalCores,`     # 物理コア数
                                                        Sockets,`           # ソケット数
                                                        MemorySize,`        # メモリーサイズ(GB)
                                                        DiskInfos,`         # ディスク情報(GB)
                                                        OS,`                # OS 名
                                                        BuildNumber,`       # ビルド番号
                                                        OsVersion,`         # OS バージョン
                                                        OsArchitecture,`    # OS アーキテクチャ
                                                        SystemType,`        # システムタイプ
                                                        IPAddress           # IP アドレス

    $Win32_BIOS = Get-WmiObject Win32_BIOS
    $Win32_Processor = Get-WmiObject Win32_Processor
    $Win32_ComputerSystem = Get-WmiObject Win32_ComputerSystem
    $Win32_OperatingSystem = Get-WmiObject Win32_OperatingSystem

    # ホスト名
    $ReturnData.HostName = hostname

    # メーカー名
    $ReturnData.Manufacturer = $Win32_BIOS.Manufacturer

    # モデル名
    $ReturnData.Model = $Win32_ComputerSystem.Model

    # シリアル番号
    $ReturnData.SN = $Win32_BIOS.SerialNumber

    # CPU 名
    $ReturnData.CPUName = @($Win32_Processor.Name)[0]

    # CPU 仕様
    $ReturnData.CpuDataWidth = $Win32_Processor.DataWidth
    $ReturnData.CpuAddressWidth = $Win32_Processor.AddressWidth

    # 物理コア数
    $PhysicalCores = 0
    $Win32_Processor.NumberOfCores | % { $PhysicalCores += $_}
    $ReturnData.PhysicalCores = $PhysicalCores

    # ソケット数
    $ReturnData.Sockets = $Win32_ComputerSystem.NumberOfProcessors

    # メモリーサイズ(GB)
    $Total = 0
    Get-WmiObject -Class Win32_PhysicalMemory | % {$Total += $_.Capacity}
    $ReturnData.MemorySize = [int]($Total/1GB)

    # ディスク情報
    [array]$DiskDrives = Get-WmiObject Win32_DiskDrive | ? {$_.Caption -notmatch "Msft"} | sort Index
    $DiskInfos = @()
    foreach( $DiskDrive in $DiskDrives ){
        $DiskInfo = New-Object PSObject | Select-Object Index, DiskSize
        $DiskInfo.Index = $DiskDrive.Index              # ディスク番号
        $DiskInfo.DiskSize = [int]($DiskDrive.Size/1GB) # ディスクサイズ(GB)
        $DiskInfos += $DiskInfo
    }
    $ReturnData.DiskInfos = $DiskInfos

    # OS
    $OS = $Win32_OperatingSystem.Caption
    $SP = $Win32_OperatingSystem.ServicePackMajorVersion
    if( $SP -ne 0 ){ $OS += "SP" + $SP }
    $ReturnData.OS = $OS

    # Winver のビルド番号
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $RegKey = "CurrentBuild"
    $MajorNumber = (Get-ItemProperty -Path $RegPath -name $RegKey).$RegKey
    $RegKey = "UBR"
    $MinorNumber = (Get-ItemProperty -Path $RegPath -name $RegKey).$RegKey
    $ReturnData.BuildNumber = $MajorNumber + "." + [String]$MinorNumber

    # Winver のバージョン
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $RegKey = "ReleaseId"
    $ReturnData.OsVersion = (Get-ItemProperty $RegPath -name $RegKey -ErrorAction SilentlyContinue).$RegKey

    # OS アーキテクチャ
    $ReturnData.OsArchitecture = $Win32_OperatingSystem.OSArchitecture

    # システムタイプ
    $ReturnData.SystemType = $Win32_ComputerSystem.SystemType

    # IP Address
    [array]$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration
    $IPAddresses = @()
    foreach( $NIC in $NICs ){
        [array]$IPs = $NIC.IPAddress
        if($IPs.Count -ne 0){
            foreach($IP in $IPs){
                $IPAddresses += $IP
            }
        }
    }
    $ReturnData.IPAddress = $IPAddresses

    return $ReturnData
}

QueryPcInfo
