function sendEmail {

param(
    [string]$subjectName = " ",
    [string]$date = " "

)

    #creating outlook and msg object
    $outlook = New-Object -ComObject Outlook.Application
    $meeting = $outlook.CreateItem('olAppointmentItem')

    $meeting.Subject = $subjectName

    $date = [DateTime] $date

    $meeting.ReminderSet = $true
    $meeting.Importance = 1
    $meeting.MeetingStatus = [Microsoft.Office.Interop.Outlook.OlMeetingStatus]::olMeeting
    <# Add users to the email by calling $meeting.Recipients.Add('testemail@email.com')  #>
    $meeting.Recipients.Add('testemail@email.com')


    $meeting.ReminderMinutesBeforeStart = 15
    $meeting.Start = $date
    $meeting.Duration = 30
    $meeting.Send()

    $meeting = $null
    $date =  $null
    $outlook = $null
}


#     Make a call to sendEmail with using -subjectName and -date Params
#          Example: sendEmail -subjectName "Bid Rankings Due to Site" -date "03/30/2022 10:00 AM"
#
sendEmail -subjectName "Bid Rankings Due to WF" -date "04/06/2022 10:00 AM"