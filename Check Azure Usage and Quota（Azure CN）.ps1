
$result =@()
$locations=@("ChinaNorth","ChinaNorth2","ChinaEast","ChinaEast2")
$subscriptions = Get-AzureRmSubscription 
$count=$subscriptions.Count

foreach ($subscription in $subscriptions) {
 Write-Output ($count--)
 Set-AzureRmContext $subscription.Name
 
 foreach($location in $locations){

        $vms=Get-AzureRmVMUsage -Location $location
        if($vms -ne $null -and $vms.Count -gt 0){
               $vms=$vms | select @{label="Subscription";expression={$subscription.Name}},@{label="Name";expression={$_.name.LocalizedValue}},currentvalue,limit,@{label="Location";expression ={$location}}
               $result+=$vms
        }


        $storages=Get-AzureRmStorageUsage -Location $location 
        if($storages -ne $null -and  $storages.Count -gt 0){
               $storages= $storages |  select @{label="Subscription";expression={$subscription.Name}},name,currentvalue,limit,@{label="Location";expression ={$location}}
               $result+=$storages
        }



        $networks=Get-AzureRmNetworkUsage -Location $location
        if($networks -ne $null -and  $networks.Count -gt 0){
               $networks=$networks |  select @{label="Subscription";expression={$subscription.Name}}, @{label="Name";expression={$_.resourcetype}},currentvalue,limit,@{label="Location";expression ={$location}}
               $result+=$networks
        }
  
 }

 #break; 
 }

 $result | Export-CSV C:\Users\Zx\Desktop\Usage\Usage_Quota_v2.1.csv