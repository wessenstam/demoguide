# Active Directory (AD) Bridging

## What is Active Directory Bridging?
At a basic level, Active Directory (AD) bridging enables non-Windows systems to be joined to AD. Doing this allows Active Directory benefits to be extended consistently across Windows, Linux, and UNIX IT systems and network devices.

One key benefit is allowing administrators to log in to non-Windows systems using their dedicated AD login credentials instead of a local privileged account such as root, ec2-user, or ubuntu. As part of an identity consolidation best practice, this helps reduce the attack surface by avoiding the proliferation of multiple local accounts across IT systems and ensures full accountability of privileged activities by preventing the use of these anonymous shared, privileged accounts.

More advanced AD bridging capabilities include supporting complex multi-forest AD architectures and trust models, a hierarchical model for cross-platform role-based access control, deep AD service integrations (e.g., Kerberos, AD-DNS, and AD-CS), extending AD group policy to non-Windows platforms, and Windows smart card login configuration extended to Linux systems.

## Environment description

In the environment there are Linux machines that have been prepared and are joined to the Active Directory (AD). As this is a demo environment we will not discuss what the steps have been to make this work. But it boils down to the following steps:

1. Install the Delinea Server PAM solution
2. Configure the installation to put the Linux machine under control of the software using an agent
3. Install the agent on the Linux machines
4. "Push" configurations

## Working with the Web-Linux machine

Login to the Client as **Delinealabs/AFoster**. To show the AD integration, open Putty from the Start bar ![server PAM](images/lab001.png). There will be a machine ready to be used (**web-linux.delinealabs.local**), double click on the machine and a SSH session will open 

!!! Note
    Make sure the machine is running. If it is not, start it. If you haven't touch the machine for more than 2 hours (Skytap configuration), it may have been shutdown.


### Using a SSO login

The agent that is installed on the Linux machine is capable of using the Kerberos ticket from the machine, on which the user is logged in. This saves the password retyping. To make this work, type the username **afoster@delinealabs.local** in the Putty screen

![server PAM](images/lab002.png)

As soon as you hit the **ENTER** key you will see that the system logs you in directly, without any retyping the password. This is due to the fact that you have already logged in to your WIndows machine. Log out of the ssh session.

!!! Note
    To log out of the SSH session use **CTRL+D** or type **exit**


### Using "normal" login

Besides the way of logging in using the Kerberos ticket, the agent also allows access using the username and its password as credentials. Open Putty again and double click the **web-linux.delinealabs.local**. Log in as **tsmith@delinealabs.local** and hit **ENTER** on your keyboard. Type **Delinea/4u** as the password and you are logged into the system. 

![server PAM](images/lab003.png)

To check that the accounts afoster and tsmith don't exist on the system as local accounts, run ``cat /etc/passwd | grep afoster`` for the **afoster** account and exchange *afoster* for **tsmith** and see that there is no line shown that has the account in them.

![server PAM](images/lab004.png)

Log out of the session and try to login using the **state@delinealabs.local** account and see that that account, even though it exists in the AD, has no rights to login to the system (the system will allow 5 Times before it closes the attempt). 

![server PAM](images/lab005.png)

Close the Putty session as the last step of this module

## Conclusion

Using a relative simple process it is possible to make a Linux machine part of the AD where **allowed** users can login to Linux systems using their AD Credentials. All actions are now logged on their account and makes the accountability something easier to report on we will look at that later in the lab.


