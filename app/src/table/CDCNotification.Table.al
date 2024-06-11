table 6086015 "CDC Notification"
{
    Caption = 'Notification';

    fields
    {
        field(1; "Notification Type ID"; Guid)
        {
            Caption = 'Notification Type ID';
        }
        field(2; Scope; Option)
        {
            Caption = 'Scope';
            OptionCaption = 'Per User,Global';
            OptionMembers = "Per User",Global;
        }
        field(3; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(10; "Do Not Show Again"; Boolean)
        {
            Caption = 'Do Not Show Again';
        }
        field(11; "Show After"; Date)
        {
            Caption = 'Show After';
        }
    }

    keys
    {
        key(Key1; "Notification Type ID", Scope, "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

