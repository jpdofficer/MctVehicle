#MctVehicle is a poweshell application that address the need of being able to view which mobile computer terminals(MCT) is located 
#in a vehicle. It does this by using the downloaded router.csv file found on net cloud which exports all the routers to a csv file
#This program was created and  run on the following Powershell to see if compatable do {PSVersionTable} in Powershell
#PSVersion                      5.1.19041.2673
#PSEdition                      Desktop
#PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
#BuildVersion                   10.0.19041.2673
#CLRVersion                     4.0.30319.42000
#WSManStackVersion              3.0
#PSRemotingProtocolVersion      2.3
#SerializationVersion           1.1.0.1


#This class is used in the storage and creation of a csv file that is used in the progrm
class MctVehicle

{

    [string]$timeStamp #stores a timestamp
    [string]$user_name  #stores the current user of the computer
    [string]$computer_name #stores the computer name
    [string]$router_name #stores the router name
    [string]$computer_mac #stores the computer mac
    [string]$computer_ip #stores the computer ip address
    [string]$router_mac # stores the router mac
    [string]$router_ip # stores the router ip
    [string]$router_state #stores the router state( active, inactive, pending ect)
    [string]$csvPath #stores the csv path of the downloaded file
    [string]$mctCvsPath #store the mctCvsPath
    [string]$interface #stores the interface 
    [string]$routerSerial #stores the routers serial number


    MctVehicle()
    {
        $this.setRouterIp( (Select-Xml -Path 'C:\TEMP\CompFolder\MctVehicle\config.xml' -XPath '/Config/ip' | ForEach-Object { $_.Node.Value }))
        $this.setInterface(( Select-Xml -Path 'C:\TEMP\CompFolder\MctVehicle\config.xml' -XPath '/Config/interface' | ForEach-Object { $_.Node.Value }))
        $this.setCSVPath(( Select-Xml -Path 'C:\TEMP\CompFolder\MctVehicle\config.xml' -XPath '/Config/routerCvs' | ForEach-Object { $_.Node.Value }))
        $this.setMctCSVPath(( Select-Xml -Path 'C:\TEMP\CompFolder\MctVehicle\config.xml' -XPath '/Config/vehicleCvs' | ForEach-Object { $_.Node.Value }))
        $this.autoTimeStamp()
        
    }

    #you must put a ip into the constructor it is a requirment to use this class
    #this allows for flexablity in the class in that if we change routers we can still get this information
    MctVehicle([string] $ip)
    {

        $this.router_ip = $ip #get the router ip
        $this.autoTimeStamp() #create the timestamp

    }

    
    #auto methods attempt to automatically set all variables
    [void] autoTimeStamp()

    {
       $this.timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." } #creat a time stamp
    }



    [void] autoUserName()

    {

       #$this.user_name = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name #get the current user
        $this.user_name    = Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" |
                        ForEach-Object { $_.GetOwner() } |
                        Select-Object -Unique -Expand User
    }

    #function autoInterface()
    #This function loops through all the interfaces that are connected and DHCP enabled. It excludes any Loopback addresses
    #Doing this it then test for a connection to the router ip
    #Once it can ping the router ip it assignes that interface to the classes interface value
    [void] autoInterface()
    {
    
        try {
            
       
        if(Test-Connection -IPAddress $this.getRouterIp() -Quiet -Count 1)
        { 
            #get the index of all network interfaces from the arp of that ping
            $index = Get-NetNeighbor -IPAddress $this.getRouterIp() | Where-Object {$_.State -eq 'Reachable' -and $_.ifIndex -ne '32'}
            $inter = $index | Sort-Object 
            $this.interface = (Get-NetIPConfiguration -ifIndex $inter[0].ifIndex | Select-Object InterfaceAlias).InterfaceAlias
        }
        else 
        {
            $this.interface = "No matching interface"    
        }
    }
    catch
        {
            throw $_.Exception.Message
        }
    }


    [void] autoComputerName()
    {

        $this.computer_name = $env:COMPUTERNAME #get the computer name

    }



    [void] autoComputerMacAddress()

    {
        $interTest = $this.getInterface()
        $temp = (Get-NetAdapter -Name $interTest |Select-Object MacAddress).MacAddress #get the computer mac address
        $this.computer_mac = $temp -replace '[-]' #remove the - delimiter as the cvs file stores it as all one value

    }



    [void] autoComputerIP()

    {
        
        $this.computer_ip = (Get-NetIPAddress -InterfaceAlias $this.getInterface() -AddressFamily IPV4 |Select-Object IPv4Address).IPv4Address #get the computer ip
    }



    [void] autoRouterMac()
    {

       $_Mac = (Get-NetNeighbor -IPAddress $this.getRouterIp() -InterfaceAlias $this.getInterface() | Select-Object LinkLayerAddress).LinkLayerAddress #get the mac address of router
        $this.router_mac = $_Mac -replace '[-]' -replace "2A","00" #remove the - 

    }

    

    #if you notice autoRouterIp is the only auto function that has a set value. YOu must supply an ip to this function in order for the 
    #program to work. This is actually set by the constructor but if you do need to change the ip address you can do it with this command
    [void]autoRouterIp([string] $router)

    {

        $this.router_ip = $router #set the router ip

    }


    #this gets the router state, as in can we connect to it
    [void]autoRouterState()

    {

        $this.router_state = (Get-NetNeighbor -IPAddress $this.getRouterIp() | Select-Object State).State #set the router state

    }


    #end auto methods

    #set methods allow the user to set  the data all functions allow a user to specify the values for the computer and router
    

    #user sets the users name
    [void] setUserName([string] $user)

    {

        $this.user_name = $user #set user name

    }


    #user sets the computer name
    [void] setComputerName([string] $computerName)

    {

        $this.computer_name = $computerName #set the computer name

    }


    #user sets the mac address
    [void] setMacAddress([string] $computerMac )

    {

        $temp = computerMac #set the mac address

        $this.computer_mac = $temp -replace '[-]' #remove the - delemiter

    }



    # user sets the computer ip address
    [void] setComputerIP([string] $computerIP)

    {

        $this.computer_ip = $computerIP #set the computer ip address

        

    }

    #user sets the router name
    [void] setRouterName([string] $routerName)
    {
        $this.router_name = $routerName #set the router name
    }

    #user sets the router mac
    [void] setRouterMac([string] $routerMac)

    {

        $_Mac = $routerMac# sets the router mac
        $this.router_mac = $_Mac -replace "2A",'00'

    }

    #set the routers serial number
    [void] setRouterSerial([string] $routerserial)
    {
        $this.routerSerial = $routerserial
    }
    
    #user sets the routers ip
    [void]setRouterIp([string] $router)

    {

        $this.router_ip = $router #sets the routers ip

    }



    #user sets the routers state
    [void]setRouterState( [string] $state)

    {

        $this.router_state = $state #set the router state

    }

    #user sets the exported routers csv path
    [void]setCSVPath([string] $path)
    {
        
        $this.csvPath = $path #set the csv path
    }


    [void]setMctCSVPath([string] $path)
    {
        $this.mctCvsPath = $path
    }

    [void]setInterface([string] $inter)
    {
        #test if the interface can ping the router
        if(Test-Connection -IPAddress $this.getRouterIp() -Quiet -Count 1)
        {
            $this.interface = $inter
        }
        else {
            $this.interface = $false
        }
    }
    #end set methods


    #get methods return the data
    [string] getTimeStamp()
    {
      

        return $this.timestamp #return the time stamp

    }





    [string] getUserName()

    {

        return $this.user_name #return the users name

    }



    [string] getComputerName()

    {

        return $this.computer_name #return the computers name

    }



    [string]getComputerMac()

    {

        return $this.computer_mac #returns the compter mac

    }



    [string]getComputerIp()

    {

        return $this.computer_ip #return the computer ip

    }

    

    [string] getRouterIp()

    {

        return $this.router_ip #return the router ip

    }



    [string] getRouterMac()

    {

        return $this.router_mac #return the computer mac

    }



    [string] getRouterState()

    {

        return $this.router_state #return the router state

    }

    [string]getCSVPath()
    {
        return $this.csvPath #return the csvPath
    }


    [string]getMctCvsPath()
    {
        return $this.mctCvsPath
    }

    [string]getInterface()
    {
        return $this.interface
    }

    
}



