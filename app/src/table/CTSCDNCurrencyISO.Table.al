table 6086232 "CTS-CDN Currency (ISO)"
{
    Caption = 'Currency Code (ISO)';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = Currency.Code;
        }
        field(4; "ISO Code"; Code[3])
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

