# Auditing and Monitoring

The Delinea Audit & Monitoring Service enables you to create and manage an audit infrastructure - the **audit** installation - to store and query sessions based on the criteria of interest. In addition, audit events allow you to record successful and failed operations and integrate with incident monitoring programs to generate alerts and automate responsive actions.

## Direct Audit via the agent

One way to perform audits is to have an agent installed on the machines that are to be audited. The agent can be installed on the same supported versions of the Operating Systems (Windows and *NIX) as the Privileged Elevation Services.

During the chapters we ran, already audits have been taken place. Most actions you ran on the machines have been audited, so we have so great information to look at. The actions should be all familiar...
### Look at the generated audit

On the **Client VM** open the Audit Analyzer (on the Desktop), accept the UAC, select the **DefaultInstallation**, and click **OK**. Navigate to **Audit Analyzer -> Audit Sessions -> Today**

![](images/lab001.png)

!!!tip "Remark"
    The above screenshot may look a bit different in your environment.

By double clicking on one of the lines you can see what has happened. All should be very familiar. Click in the menu bar the **Session** text and select **Pending for review** 

![](../../images/lab0029.png)

Provide some text in the message box that appears and click **OK**.

![](../../images/lab0030.png)

Close the DirectAudit screen (the window where the video is displayed). Back in the table view, refresh the page and look for the line that you have double clicked. Scroll to the right and see that your remark is displayed and the status of the audit.

![](images/lab002.png)

Using this process, auditors are capable of documenting their progress and share information with each other.

!!!warning

    This process can only be used internally. When it comes to court, the storage that is used for the storing of the videos is not putting the videos in a legal hold mode (meaning **nobody** can alter the content). This means that the videos can be altered in favor of defended and offender and will not hold in court as evidence...