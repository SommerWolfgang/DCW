table 6086231 "CTS-CDN Country (ISO)"
{
    Caption = 'Country Code (ISO)';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = "Country/Region".Code;
        }
        field(4; "ISO Code"; Code[2])
        {
            Caption = 'ISO Code';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

