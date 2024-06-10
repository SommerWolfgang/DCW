table 6086223 "CTS-CDN Network Profile Group"
{
    Caption = 'Network Profile Group';

    fields
    {
        field(1; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
        }
        field(2; "Code"; Code[30])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Group Customization ID"; Text[250])
        {
            Caption = 'Group Customization ID';
        }
        field(5; "No. of Profiles"; Integer)
        {
            CalcFormula = Count("CTS-CDN Network Profile" WHERE("Network Name" = FIELD("Network Name"),
                                                                 "Network Profile Group Code" = FIELD(Code)));
            Caption = 'No. of Network Profiles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "System ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'System ID';
        }
    }

    keys
    {
        key(Key1; "Network Name", "Code")
        {
            Clustered = true;
        }
        key(Key2; "System ID")
        {
        }
    }

    fieldgroups
    {
    }
}

