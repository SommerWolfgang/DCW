table 6085576 "CDC Document Category Language"
{
    Caption = 'Category Language';

    fields
    {
        field(1; "Document Category Code"; Code[10])
        {
            Caption = 'Document Category Code';
            NotBlank = true;
        }
        field(2; "Language Code"; Text[20])
        {
            Caption = 'Language Code';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Document Category Code", "Language Code")
        {
            Clustered = true;
        }
    }
}