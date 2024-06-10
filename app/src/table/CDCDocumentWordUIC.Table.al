table 6085603 "CDC Document Word (UIC)"
{
    Caption = 'Document Word (Unidentified Company)';
    DataPerCompany = false;

    fields
    {
        field(2; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(4; Word; Text[200])
        {
            Caption = 'Word';
        }
        field(5; Top; Integer)
        {
            Caption = 'Top';
        }
        field(6; Left; Integer)
        {
            Caption = 'Left';
        }
        field(7; Bottom; Integer)
        {
            Caption = 'Bottom';
        }
        field(8; Right; Integer)
        {
            Caption = 'Right';
        }
        field(9; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Text,Barcode';
            OptionMembers = Text,Barcode;
        }
        field(10; "Barcode Type"; Code[20])
        {
            Caption = 'Barcode Type';
        }
        field(11; Data; BLOB)
        {
            Caption = 'Data';
        }
        field(100; "Document Code"; Code[50])
        {
            Caption = 'Document Code';
        }
    }

    keys
    {
        key(Key1; "Document Code", "Page No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

