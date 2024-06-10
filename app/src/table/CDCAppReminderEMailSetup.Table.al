table 6085736 "CDC App. Reminder E-Mail Setup"
{
    Caption = 'Approval Reminder Email Setup';

    fields
    {
        field(1; Level; Integer)
        {
            Caption = 'Level';
            NotBlank = true;
        }
        field(3; "Due Date Calculation"; DateFormula)
        {
            Caption = 'Due Date Calculation';
        }
        field(4; "Send CC to"; Option)
        {
            Caption = 'Send CC to';
            OptionCaption = ' ,Approver ID of Original Approver,Approver ID of Current Approver';
            OptionMembers = " ","Approver ID of Original Approver","Apporver ID of Current Approver";
        }
        field(5; "Send CC to User ID"; Code[50])
        {
            Caption = 'Send CC to User ID';
        }
        field(6; "E-mail Subject"; Text[80])
        {
            Caption = 'Email Subject';
        }
    }

    keys
    {
        key(Key1; Level)
        {
            Clustered = true;
        }
    }
}