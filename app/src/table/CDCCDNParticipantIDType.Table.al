table 6086205 "CDC CDN Participant ID Type"
{
    Caption = 'Participation Identifier Type';

    fields
    {
        field(1; "System ID"; Integer)
        {
            Caption = 'System ID';
        }
        field(2; "Network Name"; Text[30])
        {
            Caption = 'Network ID';
            TableRelation = "CDC CDN Network";
        }
        field(3; "Identifier Type ID"; Text[4])
        {
            Caption = 'Identifier Type ID';
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(10; Default; Boolean)
        {
            Caption = 'Default';
        }
    }

    keys
    {
        key(Key1; "System ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

