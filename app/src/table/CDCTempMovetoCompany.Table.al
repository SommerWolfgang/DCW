table 6085703 "CDC Temp. Move to Company"
{
    Caption = 'Temp. Move to Company';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'UIC,Company';
            OptionMembers = UIC,Company;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; Type, Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

