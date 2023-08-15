# MctVehicle
Prior to MCTAware, the C++ version of this program I wrote it as a Powershell script, I decided to include it so that you can get up and running while I finish the C++ version
In order to use this application you need the following 
1. A csv file that has all the routers ( such as routers.csv from cradle point), As long as you can export all
routers to a csv file you
should be good to go

C:\TEMP\CompFolder\MctVehicle\MctVehicle\
This is very important, or the computer cannot find the related files I have
already stored them
under \MctVehicle\MctVehicle. I do plan on adding a function that creates
these folders if they are not there but as I am waiting on vehicles I felt the
main body was what was important

3. You have to have a place to store the new csv file. I recommend that you
keep it under whatever
location you store the router.csv. I have named mine vehicle csv. Good news is
that it should be already created from other usages of the software. But if it
is not just create a csv file and
name it vehicles or whatever you want

4. Navigate to C:\TEMP\CompFolder\MctVehicle\MctVehicle
5. Run .\MctVGui.ps1
6.  If you get "Unable to find [MctGui] " Restart Powershell as Admin and navigate back to
C:\TEMP\CompFolder\MctVehicle\MctVehicle

7. Make sure you enter a IP address( Even if the one listed is the correct one
enter the ip address, it is just a label and will not
transfer over)

8. Select the CSV that you have all your routers stored on. ( In case of
Cradlepoint it will be router.csv)

9.Now select the Network Interface that you are going to use, in the cars they
are always named like Ethernet 2 or such.

10. Select the CSV in which you are going to store this information, in my
case its vehicle.csv

11. Click Submit and your done, you should get a confirmation
