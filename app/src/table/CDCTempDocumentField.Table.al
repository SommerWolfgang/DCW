table 6085595 "CDC Temp. Document Field"
{
    Caption = 'Temp. Document Field';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
        }
        field(3; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(4; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
        }
        field(7; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(8; "Has Lookup"; Boolean)
        {
            Caption = 'Has Lookup';
        }
        field(100; "XML Path"; Text[250])
        {
            Caption = 'XML Path';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Field Code")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Sort Order")
        {
        }
    }

    fieldgroups
    {
    }
}

