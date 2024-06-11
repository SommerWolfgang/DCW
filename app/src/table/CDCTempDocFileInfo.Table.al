table 6085600 "CDC Temp. Doc. File Info."
{
    Caption = 'Temp. Doc. File Info.';

    fields
    {
        field(1; "Document Type"; Integer)
        {
            Caption = 'Document Type';
        }
        field(2; "Document Subtype"; Integer)
        {
            Caption = 'Document Subtype';
        }
        field(3; "Document ID"; Code[20])
        {
            Caption = 'Document ID';
        }
        field(4; "Document Ref. No."; Integer)
        {
            Caption = 'Document Ref. No.';
        }
        field(5; "Styled XML Filename"; Text[250])
        {
            Caption = 'Styled XML Filename';
        }
        field(6; "XML Filename"; Text[250])
        {
            Caption = 'XML Filename';
        }
        field(7; "XSL Filename"; Text[250])
        {
            Caption = 'XSL Filename';
        }
        field(8; "Create Styled XML File"; Boolean)
        {
            Caption = 'Create Styled XML File';
        }
    }

    keys
    {
        key(Key1; "Document Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

