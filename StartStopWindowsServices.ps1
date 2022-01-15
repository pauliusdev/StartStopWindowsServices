#store all of the ec services
$ec_ServicesList = [System.Collections.ArrayList]@(
    'Wuauserv'
    'W32Time'
    )
#store all of the lib services
$lib_ServicesList = [System.Collections.ArrayList]@(
    'Wuauserv'
    'W32Time'
    )

#store all of the singer services
$singer_ServicesList = [System.Collections.ArrayList]@(
    'Wuauserv'
    'W32Time'
    )


#strictly specified list of services in bulks
$EC = $ec_Services
$LIB = $lib_ServicesList
$SING = $singer_ServicesList

#services list from the targeted pc, showing only name and status properties
$services = Get-Service -ComputerName media-w12s12dev | Select-Object -Property Name, Status

#check if my selected services are all within the list
$selectChoicesCount = 0

function tempFunction()
{
    $userImput = Read-Host -Prompt 'Do you wish to Stop/Start single or multiple services: YES/NO'
    if($userImput -eq 'YES')
    {
        Read-Host -Prompt "Press enter get services list window"
        $servicesChoice  =  Get-Service -ComputerName media-w12s12dev | Select-Object -Property Name,Status | Out-GridView -PassThru | Select-Object -ExpandProperty Name
        
        foreach($service in $services)
        {
            foreach($serviceSelected in $servicesChoice)
            {
             if($service.Name -eq $serviceSelected)
                {
                    $selectedChoicesCount ++
                    Write-Host "Service Name: $serviceSelected service found!"
                    Write-Host "STATUS:"$service.Status
                }
            }
        }

        #check if all of the services selected exist within the services list
        if($servicesChoice.Count -eq $selectedChoicesCount)
        {
            Write-Host 'Great! all of the services are in the list'

            $yesNoImput = Read-Host -Prompt 'Start or Stop service/services?: Type START or STOP'

            if($yesNoImput -eq 'START')
            {
                $servicesChoice | Get-Service -ComputerName media-w12s12dev | Start-Service
            }
            elseif($yesNoImput -eq 'STOP')
            {
                $servicesChoice | Get-Service -ComputerName media-w12s12dev | Stop-Service 
            }
            else
            {
                Write-Host "command $yesNoImput is incorrect"
                Read-Host -Prompt "Press enter to restart"
                tempFunction
            }
        }
        else
        {
            Write-host 'Some services you selected does not exist within the list'
        }
                  
    }
    elseif($userImput -eq 'NO')
    {
        $userImput = Read-Host -Prompt 'Stop or Start all of the services for Lib or Ec or N1'
    
        if($userImput -eq 'EC')
        {
            $userImput = Read-Host -Prompt 'Start or Stop service?: Type START or STOP'
            if($userImput -eq 'START')
            {
                Write-Host 'Not finished!'
                #$ec_ServicesList | Get-Service | Start-Service
            }
            elseif($userImput -eq 'STOP')
            {
                Write-Host 'Not finished!'
                #$ec_ServicesList | Get-Service | Stop-Service
            }
            else
            {
                Write-Host "command $userImput is incorrect"
                Read-Host -Prompt "Press enter to restart"
                tempFunction
            }
        }
        elseif($userImput -eq 'LIB')
        {
            Write-Host 'Not finished!'
            #$ec_Services | Get-Service | Start-Service
        }
        elseif($userImput -eq 'SING')
        {
            Write-Host 'Not finished!'
            #$ec_Services | Get-Service | Start-Service
        }
        else
        {
            Write-Host "List of Services: | $user | does not exist"
            Read-Host -Prompt "Press enter to restart"
            tempFunction
        } 
    }
    Read-Host -Prompt "Press enter to restart"
    tempFunction 
}

tempFunction

Read-Host -Prompt "Press Enter to exit."
