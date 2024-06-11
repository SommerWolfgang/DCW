table 6085740 "CDC Event Register"
{
    Caption = 'Event Register';

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "CDC Event Entry";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "CDC Event Entry";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(5; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(7; "Area"; Option)
        {
            Caption = 'Area';
            OptionCaption = 'Purch. Approval Status Email,Purch. Approval Reminder Email,Delegation Reminder Email';
            OptionMembers = "Purch. Approval Status E-mail","Purch. Approval Reminder E-mail","Delegation Reminder";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Area", "Creation Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EventEntry: Record "CDC Event Entry";
    begin
        EventEntry.SetRange("Entry No.", "From Entry No.", "To Entry No.");
        if not EventEntry.IsEmpty then
            EventEntry.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        EventRegister: Record "CDC Event Register";
    begin
        EventRegister.LockTable();
        if EventRegister.FindLast() then
            "No." := EventRegister."No." + 1
        else
            "No." := 1;

        "User ID" := UserId;
        "Creation Date" := Today;
        "Creation Time" := Time;
    end;
}

