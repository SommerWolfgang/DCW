table 6085609 "CDC E-mail (UIC)"
{
    Caption = 'DC Email';
    DataPerCompany = false;

    fields
    {
        field(1; GUID; Guid)
        {
            Caption = 'GUID';
        }
        field(10; "E-Mail File"; BLOB)
        {
            Caption = 'Email File';
        }
    }

    keys
    {
        key(Key1; GUID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

