table 6192775 "CDC Client Activation Buffer"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Product Code"; Code[10])
        {
            Caption = 'Product Code';
        }
        field(3; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
        }
        field(4; "Company GUID"; Guid)
        {
            Caption = 'Company GUID';
        }
        field(5; "Product Version"; Text[30])
        {
            Caption = 'Product Version';
        }
        field(6; Deleted; Boolean)
        {
            Caption = 'Deleted';
        }
        field(7; "Product Name"; Text[250])
        {
            Caption = 'Product Name';
        }
        field(10; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

