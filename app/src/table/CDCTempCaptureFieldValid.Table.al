table 6085597 "CDC Temp. Capture Field Valid."
{
    Caption = 'Temp. Capture Field Validation';

    fields
    {
        field(1; "Field Type"; Option)
        {
            Caption = 'Field Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(2; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
            NotBlank = true;
        }
        field(3; "File Rule Entry No."; Integer)
        {
            Caption = 'File Rule Entry No.';
        }
        field(4; Rule; Text[250])
        {
            Caption = 'Rule';
            NotBlank = true;
        }
        field(5; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(6; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
        }
    }

    keys
    {
        key(Key1; "Field Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

