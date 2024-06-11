table 6086206 "CDC CDN Network Profile"
{
    Caption = 'Network Profile';

    fields
    {
        field(1; "System ID"; Integer)
        {
            Caption = 'System ID';
        }
        field(2; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CDC CDN Network";
        }
        field(3; "Process Identifier"; Text[250])
        {
            Caption = 'Process Identifier';
        }
        field(4; "Document Identifier"; Text[250])
        {
            Caption = 'Document Identifier';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(10; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
    }

    keys
    {
        key(Key1; "System ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

