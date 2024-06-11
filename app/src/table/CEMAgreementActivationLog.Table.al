table 6086490 "CEM Agreement Activation Log"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Editable = false;
            NotBlank = true;
            TableRelation = "CEM Bank";
        }
        field(3; "Agreement ID"; Text[30])
        {
            Caption = 'Agreement ID';
            Editable = false;
        }
        field(30; "Request Status"; Option)
        {
            Caption = 'Request Status';
            Editable = false;
            OptionCaption = ' ,Pending,Activated,Rejected';
            OptionMembers = " ",Pending,Activated,Rejected;
        }
        field(31; "Request Time"; DateTime)
        {
            Caption = 'Request Time';
            Editable = false;
        }
        field(32; "Request By User"; Code[50])
        {
            Caption = 'Request By User';
            Editable = false;
        }
        field(35; "Reject Reason"; Text[250])
        {
            Caption = 'Reject Reason';
        }
        field(40; "Request GUID"; Guid)
        {
            Caption = 'Request GUID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        AgreementActivationLog: Record "CEM Agreement Activation Log";
    begin
        if AgreementActivationLog.FindLast() then
            "Entry No." := AgreementActivationLog."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}

