table 6086011 "CDC Web Sub Menu"
{
    Caption = 'Web Sub Menu';

    fields
    {
        field(1; "Web Menu Code"; Code[20])
        {
            Caption = 'Web Menu Code';
            NotBlank = true;
            TableRelation = "CDC Web Menu".Code;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Approval Code Filter"; Code[20])
        {
            Caption = 'Approval Code Filter';
        }
        field(11; "Table ID Filter"; Text[30])
        {
            Caption = 'Table ID Filter';
        }
        field(12; "Document Type Filter"; Text[30])
        {
            Caption = 'Document Type Filter';
        }
        field(13; Sorting; Integer)
        {
            Caption = 'Sorting';
        }
    }

    keys
    {
        key(Key1; "Web Menu Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

