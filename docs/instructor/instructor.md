# Instructions for the Demo Guide

After downloading the demo ova images the following needs to be done to get the demo environment up and running:

1. Network layout
2. Network changes to be made if needed
3. Order of starting the VMs
4. Testing the environment before the demo

## Network layout

The network that is being used in the demo environment is in the 172.31.32.0/24 subnet. To overcome any possible issues, this subnet needs to be available in the network. Below table shows the VMs, there function and the IP addresses.

| VM name | Description | OS version |IP address |
| - | - | - | - |
| CentOS Server | CentOS Server | CentOS 7.9 | 172.31.32.121 |
| Client | Client VM | Windows 10 | 172.31.32.118 |
| DC1 | Domain Controller | Windows 2016 | 172.31.32.10 |
| lnx-platform | CentOS Server for the Cloud tenant | CentOS 7.9 | 172.31.32.200 |
| pfSense | pfSense router for some secrets demos| pfSense 20.1.4 | 172.31.32.8 |
| RDS01 | RDS server for some secrets demos | Windows 2016 | 172.31.32.129 |
| SSPM | Secret Server and Privilege Manager installation | Windows 2016 | 172.31.32.114 |
| vRouter | VyOS based router between the networks | VyOS 1.8 | 172.31.32.254 |
| win-platform | Windows platform for the Cloud tenant | Windows 2016 | 172.31.32.210 |

As the vRouter is the routing device between the demo network and the LAN of the installation (172.31.32.253 is the default gateway on all VMs), this VM has two nics. One of them (LAN side) is using a DHCP defined NIC. Making it possible to route between then networks, it has Network MASQ enabled on this NIC. The pfSense also has two NICS, but is not used for routing. It can be set up to become the router and not the VyOS router, but that is out of scope of this instruction. Documentation can be found on the internet.

A graphical representation of the network is shown below:

![](../images/lab000.png)

Changes may be needed to get the routing working, if MASQ (NAT/PAT) is needed due to the fact that a static route can not be added to the LAN network, or the machine on which the demo is run. The next chapter describes what needs to be changed.

## Network changes to be made if needed

As this VyOS router is a very common virtual router, changes can be easily found on the internet. A good location would be:

- For MASQ (NAT/PAT/port forwarding) rules would be: https://forum.vyos.io/t/resolved-port-forward-troubles/7732
- For disabling NAT/PAT there are some possibilities:

    1. Run ``vi /config/config.boot`` and remark the part that show **nat** using /* and */ at the end of the component. Below is an example

        Before:
        ```bash
        nat {
            source {
                rule 100 {
                    outbound-interface eth0
                    source {
                        address 172.31.32.0/24
                    }
                    translation {
                        address masquerade
                    }
                }
            }
        }
        ```

        After:
        ```bash
        /*
        nat {
            source {
                rule 100 {
                    outbound-interface eth0
                    source {
                        address 172.31.32.0/24
                    }
                    translation {
                        address masquerade
                    }
                }
            }
        }
        */
        ```
        After this has been done the VyOS router must be reboot using the ``reboot`` command and the ``Y`` to confirm the reboot.
    2. Deleting the NAT rules using the ``config`` command. After the login run ``config`` to get into the configuration environment. Then run these commands:

        - ``delete nat source rule 100 outbound-interface 'eth0'``
        - ``delete nat source rule 100 source address '172.31.32.0/24'``
        - ``delete nat source rule 100 translation address 'masquerade'``

    3. ReIP all VMs that exist in the demo environment to a more convenient range. This invokes a lot of steps that must be done:

        1. ReIP all VMs, based on the O/S some are easier then others
        2. Recreate the DNS records in the DC1 to correspond to the new IPs and range
        3. Reconfigure the DNS server to use forwarders that are available to the system
        4. Check all connectivity on Domain level before running the demo.

## Order of starting the VMs

The order of starting the VMs is important. If the order is not correct, some topics in the demo guide will not function as expected/described.

The ideal order is:

1. vRouter
2. lnx-platform
3. win-platform
4. DC1
5. SSPM
6. Client
7. RDS01
8. CentOS server
9. pfSense

!!!tip
    VMs 1,2 and 4 can be started together. The win-platform is dependent on the lnx-platform as it holds the databases that are being used by the win-platform server. Then wait till the DC1 is 100% running before starting the other machines. As the SSPM server is the SQL server for the databases that are used in the ServerPAM solutions, this server has to be started after the DC1. The Client, MUST be started BEFORE the RDS01 server. Reason is that the Client holds the management component for the Delinea Server PAM. If this server gets started AFTER the RDS01, the login into the RDS01, will not work. The easiest way to solve this issue is to reboot the RDS01 so the cache DB will be cleaned and refilled.

## Licenses

As the environment has no licenses in it, you have to inject the licenses in SSPM, for Secret Server and Privilege Manager and DC and DA licenses for Delinea Server PAM.
For injecting the license, follow these steps:

1. Delinea Secret Server and Privilege Manager - https://docs.delinea.com/secrets/current/setup/licensing/adding-activating-deleting-licenses/index.md
2. Delinea Server PAM: https://docs.centrify.com/Content/inst-lic/ManageLicensesIntro.htm

For the Windows Server Operating Systems, including RDS, follow the Licensing steps as described by Microsoft.

!!!tip
    If RDS licenses are not available in the organisation, there is a script on the desktop of the RDS01 to reset the grace period back to 180 days. Run the PowerShell script as an administrator and reboot the server after running the script.
    

## Testing the environment before the demo

After the VMs have been started, run the demo guide as shown on https://workshop.thyintresources.com/demoguide/

Quick checks:

1. Can login as the user on the RDS01 and get MFA challenges
2. Can login to the Secret Server UI from the Client.
3. Can login to all VMs using the mentioned username and password combination

### Username and passwords

| VM name/App | Username | Password |
| - | - | - | 
| CentOS Server | root | Delinea/4u |
| Client | Standard User (user) | Delinea/4u |
| DC1 | THYLAB\Administrator | Delinea/4u |
| lnx-platform | root | Delinea/4u |
| pfSense | root | Controlled by Secret Server |
| RDS01 | Standard User (user) | Delinea/4u | 
|       | THYLAB\adm-training | Delinea/4u
| SSPM | adm-training | Delinea/4u |
|      | ss_admin | Delinea/4u |
| vRouter | vyos | Delinea/4u |
| win-platform | administrator | Delinea/4u |

!!!danger

    Please try to avoid logging into the lnx- and win-platform machines. They are needed as they are, or the cloud tenant will not run as it is supposed to be in the demo environment. 

