table 6086316 "CEM Company Code Backup"
{

    fields
    {
        field(1; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
        }
    }

    keys
    {
        key(Key1; "Company Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

