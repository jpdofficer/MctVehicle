class MctGui
{
    [string] $ip
    [string] $interface
    [string] $routerCsv
    [string] $vehicleCsv


    [void] setIpAddress([string] $ipAddress)
    {
       
            $this.ip = $ipAddress
       
    
    }


    
    [void] setInterface([string] $inter)
    {
        
        $this.interface = $inter
        
    }

    
    
    [void] setRouterCSV([string] $router_csv)
     {
        $this.routerCsv = $router_csv
        #$mctInfo.setCSVPath($routerFile)
        
        
    }

    [void]setVehicleCSV([string] $veh_csv)
    {
      
        $this.vehicleCsv = $veh_csv
        
    }

    #---------------------------------------------------------------------------------------------------------------------------#


    
    [string] getIpAddress()
    {
       
           return $this.ip 
       
    
    }


    
    [string] getInterface()
    {
        
        return $this.interface 
        
    }

    
    
    [string] getRouterCSV()
     {
        return $this.routerCsv
        #$mctInfo.setCSVPath($routerFile)
        
        
    }

    [string]getVehicleCSV()
    {
      
        return $this.vehicleCsv
        
    }
}

#$mctInfo = [MctGui]::new()
#$mctInfo.setIPAddress("192.168.0.1")
#$mctInfo.setInterface("Ethernet")






