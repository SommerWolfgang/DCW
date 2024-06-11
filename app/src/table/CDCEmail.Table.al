table 6085606 "CDC E-mail"
{
    Caption = 'DC Email';

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

