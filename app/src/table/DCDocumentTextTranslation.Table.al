table 12032009 "DC - Document Text Translation"
{
    Caption = 'Document Text Translation';

    fields
    {
        field(1; "Document Text Code"; Code[20])
        {
            Caption = 'Document Text Code';
            NotBlank = true;
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
        }
        field(3; Text; Text[250])
        {
            Caption = 'Text';
        }
    }

    keys
    {
        key(Key1; "Document Text Code", "Language Code")
        {
            Clustered = true;
        }
        key(Key2; "Language Code", "Document Text Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Document Text Code", Text)
        {
        }
    }
}