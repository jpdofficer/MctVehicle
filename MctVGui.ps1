#Requires -RunAsAdministrator

#make sure that these files are all in the same directory
#If they are not then you will get a butt-load of errors telling
#you that it cannot find [MctGui] or [MctVehicle]
using module C:\TEMP\CompFolder\MctVehicle\MctVehicle\MctGui.ps1
using module C:\TEMP\CompFolder\MctVehicle\MctVehicle\MctVehicle.ps1

# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


[MctGui]$mctInfo = [MctGui]::new()
# Create a new form
$ConfigurationForm                    = New-Object system.Windows.Forms.Form

# Define the size, title and background color
$ConfigurationForm.text               = "MCT-Vehicle"
$ConfigurationForm.Size               = New-Object System.Drawing.Size(640,480)
$ConfigurationForm.BackColor          = "#ffffff"
$ConfigurationForm.StartPosition      = 'CenterScreen'

$Titel                           = New-Object system.Windows.Forms.Label
$Titel.text                      = "Configure MCTVehicle"
$Titel.AutoSize                  = $true
$Titel.width                     = 25
$Titel.height                    = 10
$Titel.location                  = New-Object System.Drawing.Point(20,20)
$Titel.Font                      = 'Microsoft Sans Serif,13'
$ConfigurationForm.Controls.Add($Titel)


$Description                     = New-Object system.Windows.Forms.Label
$Description.text                = "This app writes a configureation file for the mct"
$Description.AutoSize            = $false
$Description.width               = 450
$Description.height              = 50
$Description.location            = New-Object System.Drawing.Point(20,50)
$Description.Font                = 'Microsoft Sans Serif,10'
$ConfigurationForm.Controls.Add($Description)


$Title2                           = New-Object system.Windows.Forms.Label
$Title2.text                      = "Router IP Address:"
$Title2.AutoSize                  = $true
#$Title2.width                     = 25
#$Title2.height                    = 10
$Title2.location                  = New-Object System.Drawing.Point(20,100)
$Title2.Size                      = New-Object System.Drawing.Point(280,20)
$Title2.Font                      = 'Microsoft Sans Serif,13'
$ConfigurationForm.Controls.Add($Title2)

$ipAddress                     = New-Object system.Windows.Forms.TextBox
$ipAddress.multiline           = $false
#$ipAddress.width               = 314
#$ipAddress.height              = 20
$ipAddress.location            = New-Object System.Drawing.Point(215,100)
$ipAddress.Size                = New-Object System.Drawing.Size(260,20)
#$ipAddress.Font                = 'Microsoft Sans Serif,10'
#$ipAddress.Visible             = $true
$ipAddress.Text                 = "192.168.0.1"
$ipAddress.Add_TextChanged({setIpAddress})
$ConfigurationForm.Controls.Add($ipAddress)


$Tite3                           = New-Object system.Windows.Forms.Label
$Tite3.text                      = "Router CSV Path:"
$Tite3.AutoSize                  = $true
$Tite3.width                     = 25
$Tite3.height                    = 10
$Tite3.location                  = New-Object System.Drawing.Point(20,150)
$Tite3.Font                      = 'Microsoft Sans Serif,13'
$ConfigurationForm.Controls.Add($Tite3)

$fileButton                     = New-Object System.Windows.Forms.Button
$fileButton.location            = New-Object System.Drawing.Point(200,150)
$fileButton.Size                = New-Object System.Drawing.Size(170,30)
#$ipAddress.Font                = 'Microsoft Sans Serif,10'
#$ipAddress.Visible             = $true
$fileButton.Text                 = "Select the CSV file"
$fileButton.Add_Click({setRouterCSV})
$ConfigurationForm.Controls.Add($fileButton)


$Title4                         = New-Object System.Windows.Forms.Label
$Title4.Text                    = "Network Interface:" 
$Title4.Width                   = 25
$Title4.Height                  = 10
$Title4.Location                = New-Object System.Drawing.Point(20,200)
$Title4.Size                     = New-Object System.Drawing.Size(190,30)
$Title4.Font                    = 'Microsoft Sans Serif, 13'
$ConfigurationForm.Controls.Add($Title4)

#Interface button
$interfaceButton = New-Object System.Windows.Forms.Button
$interfaceButton.Text = "View Active Interfaces"
$interfaceButton.Width = 130
$interfaceButton.Height = 30
$interfaceButton.Location = New-Object System.Drawing.Point(210,200)
$interfaceButton.Size =            New-Object System.Drawing.Size(190,30)
$interfaceButton.Add_Click({setInterface})
$ConfigurationForm.Controls.Add($interfaceButton)



$Tite5                           = New-Object system.Windows.Forms.Label
$Tite5.text                      = "Vehicle CSV Path:"
$Tite5.AutoSize                  = $true
$Tite5.width                     = 25
$Tite5.height                    = 10
$Tite5.location                  = New-Object System.Drawing.Point(20,250)
$Tite5.Font                      = 'Microsoft Sans Serif,13'
$ConfigurationForm.Controls.Add($Tite5)

$vehicleFileButton                     = New-Object System.Windows.Forms.Button
$vehicleFileButton.location            = New-Object System.Drawing.Point(210,250)
$vehicleFileButton.Size                = New-Object System.Drawing.Size(190,30)
$vehicleFileButton.Text                 = "Select the CSV file"
$vehicleFileButton.Add_Click({setVehicleCSV})
$ConfigurationForm.Controls.Add($vehicleFileButton)


#submit button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Submit"
$submitButton.Width = 130
$submitButton.Height = 30
$submitButton.Location = New-Object System.Drawing.Point(200,400)
$submitButton.Add_Click({submitForm})
$submitButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$ConfigurationForm.AcceptButton = $submitButton
$ConfigurationForm.Controls.Add($submitButton)









$ConfigurationForm.Add_Shown({$ipAddress.Select()})
#-----------------------------------------functions------------------------------------------------#



        function setIpAddress
        {
            
                
                $mctInfo.setIpAddress($ipAddress.Text)
            
            
        
        }

        function setInterface
        {
            $interface = Get-NetIPInterface | Where-Object {($_.ConnectionState -eq "Connected") -and ($_.AddressFamily -eq "IPv4" ) } |out-Gridview -Title "Active Interfaces" -PassThru
            $mctInfo.setInterface($interface.InterfaceAlias)
            
        }



        function setRouterCSV {
            $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
            $routerFile = $FileBrowser.ShowDialog()
            

            if($routerFile -eq "OK")
            {
                
                [MctGui]$mctInfo.setRouterCSV( $FileBrowser.FileName)
                
            }
            #$mctInfo.setCSVPath($routerFile)
            
            
        }
        function setVehicleCSV
        {
            $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
            $vehFile = $FileBrowser.ShowDialog()

            if($vehFile -eq "OK")
            {
                
                [MctGui]$mctInfo.setVehicleCSV($FileBrowser.FileName)
            }
            
            
        }

        #this schedules the script to run everyday at 5 am
        function scheduleTask()
        { 
            $user = ("$env:userdomain\$env:USERNAME")
            $credentials = Get-Credential -Credential $user
            $password = $credentials.GetNetworkCredential().Password

            $randomTime = Get-Random -Maximum 24
            if ($randomTime -ge 12)
            {
                $amPm = -join ($randomTime ,"pm")
            }
            else {
                
                $amPm = -join ($randomTime ,"am")
            }
            $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -windowstyle hidden -file C:\TEMP\CompFolder\MctVehicle\MctVehicle\MctVGui.ps1" 

            $trigger = @(
                $(New-ScheduledTaskTrigger -AtLogOn  ),
                $(New-ScheduledTaskTrigger -Daily -At $amPm )
            )

            $principal = New-ScheduledTaskPrincipal -UserId $user -LogonType ServiceAccount   -RunLevel Highest 
            $settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries  -MultipleInstances IgnoreNew -StartWhenAvailable 
           
            $task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
            Register-ScheduledTask -TaskName "MctVehicle" -User $user -Password $password -InputObject $task 
            
        }
    
    
function submitForm 
{
    $configPath = "C:\TEMP\CompFolder\MctVehicle\config.xml"
    if(-not(Test-Path -Path $configPath -PathType Leaf))
    {
        try
        {

            $null = New-Item -ItemType File -Path $configPath -Force -ErrorAction Inquire
            #$xml = ConvertTo-Xml -As Document -InputObject($mctInfo) 
            #$xml.Save($configPath)
            [System.Xml.XmlDocument] $configXML = New-Object System.Xml.XmlDocument

            $Parent = $configXML.CreateElement("Config")
            #create the ip xml
            $ipaddy = $configXML.CreateElement("ip")
            $ipaddy.SetAttribute("value", $mctInfo.getIpAddress())
            $Parent.AppendChild($ipaddy)
            
            #create the interface xml
            $inter = $configXML.CreateElement("interface")
            $inter.SetAttribute("value", $mctInfo.getInterface())
            $Parent.AppendChild($inter)

            #create the routercvs xml
            $routerX = $configXML.CreateElement("routerCvs")
            $routerX.SetAttribute("value", $mctInfo.getRouterCSV())
            $Parent.AppendChild($routerX)

            #create the vehicleXml
            $vehicleX = $configXML.CreateElement("vehicleCvs")
            $vehicleX.SetAttribute("value", $mctInfo.getVehicleCSV())
            $Parent.AppendChild($vehicleX)
            
            
           
            
            
            
            $configXML.AppendChild($Parent)
            $configXML.Save($configPath)

            

        }
        catch {
            throw $_.Exception.Message
        }
        
    }
    $ConfigurationForm.Dispose()
}





#------------------------------End Functions-------------------------------------------------------#

#while C:\TEMP\CompFolder\MctVehicle\config.xml file does not exist
while(-not (Test-Path -Path "C:\TEMP\CompFolder\MctVehicle\config.xml" -PathType Leaf))
{
    $ConfigurationForm.ShowDialog() #run the gui
    
}

#if the config.xml does exisit do not run the gui and instead configure everything else

    [MctVehicle]$mctVInfo = [MctVehicle]::new()
    $mctVInfo.autoUserName() #Call AutoName
    $mctVInfo.autoComputerName() #call computer name
    $mctVInfo.autoComputerIP() #call computer ip
    $mctVInfo.autoComputerMacAddress() #call mac address
    $mctVInfo.autoRouterMac() # This gets the ROuters Mac
    $mctVInfo.autoRouterState() #call router state

    $routerInventory = Import-Csv -Path $mctVInfo.getCSVPath() #Import the router.csv file

    #if the routerInventory mac matches the $mctInfo.mac
    if(($routerInventory.mac -match $mctVInfo.getRouterMac() )) 
    {
        #we set the property name where the mac recorded in the csv file is eq to the one stored in the class
        $mctVInfo.setRouterName( ($routerInventory | Where-Object {$_.mac -eq  $mctVInfo.getRouterMac()} | Select-Object name).name )
        $mctVInfo.setRouterSerial(($routerInventory | Where-Object {$_.mac -eq  $mctVInfo.getRouterMac()} | Select-Object serial_number).serial_number)

    }
    elseif(-not($routerInventory.mac -eq $mctVInfo.getRouterMac() )) #if it does documented mac and routermac does not match place a N/S in name field
    {
        #if not we place not assigned in the value
        $mctVInfo.setRouterName("Not Assigned")

    }

    try
    {
        $mctVInfo | Export-Csv -Path $mctVInfo.getMctCvsPath() -Append -NoTypeInformation -Force  
    }
   catch 
   {
       
            $randomSleep = Get-Random  -minimum 1 -Maximum 1800  # set a number between 1 and 30 mins
            Write-Host $randomSleep
            Start-Sleep -Seconds $randomSleep #sleep for that long
            $mctVInfo | Export-Csv -Path $mctVInfo.getMctCvsPath() -Append -NoTypeInformation -Force #try again  
        
    }

    scheduleTask
    
    
   

