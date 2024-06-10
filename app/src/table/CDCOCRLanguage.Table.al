table 6085578 "CDC OCR Language"
{
    Caption = 'OCR Language';

    fields
    {
        field(1; "Code"; Text[20])
        {
            Caption = 'Code';
            Editable = false;
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(3; Dictionary; Boolean)
        {
            Caption = 'Dictionary';
            Editable = false;
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

