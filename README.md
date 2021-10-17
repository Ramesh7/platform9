# platform9

Assume you are the administrator of a cloud which hosts some finite number of Virtual Machines. Users of your cloud can borrow or check-out VMs for use. Once they are done using it, they can check-in the VM back. Once a VM is checked in, as an administrator, you should perform some cleanup on the VM and then return it back to the pool of VMs. 

This repository is having 3 main scripts :

## 1 scripts/pool_manager.rb

This script is responsible for provision pool. This has capability to take different inputs from user like instance-id, size of instance & AMI. 

```
$ bundle exec ruby ./scripts/pool_manager.rb

Already exists key pair named : pt-poc
Pool Status :
  Current Size : 1
  Expected Sixe : 3
  Change : 2
Provisioned new instance with ID : i-0e4xxx
Successfully tagged to i-0e4xxx
Provisioned new instance with ID : i-06ff7xxx
Successfully tagged to i-06ff7xxx

```

## 2 scripts/client.rb

This script is reponsible to reserve or unreserve instances for client. By running they can either reserve instance or they can release instances.


```
$ bundle exec ruby ./scripts/client.rb

List of unreserved pool instances:
1 :
  ID : i-0e8bbebcbb9ddad72
  Private IP : 10.171.151.35
  Public IP : 54.205.233.107
2 :
  ID : i-0e4c4fa5d1fa31ba9
  Private IP : 10.170.209.76
  Public IP : 54.147.6.132
3 :
  ID : i-06ff778d58fc19dd2
  Private IP : 10.165.167.225
  Public IP : 3.91.249.200
Please select instance number you wanted to check-in/reserve :
1
```

## 3 scripts/admin.rb

This script is reponsible for admin stuff for cleanup activity once any VM is released by client after their use.


```
bundle exec ruby ./scripts/admin.rb
```
